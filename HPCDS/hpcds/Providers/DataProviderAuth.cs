using hpcds.Code.Constants;
using hpcds.Models;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;

namespace hpcds.Providers
{
    public class DataProviderAuth
    {
        internal static IQueryable<ApiAudience> GetApiAudience(string clientId)
        {
            using (ApplicationDbContext dataContext = new ApplicationDbContext())
            {
                return dataContext.ApiAudience.Where(w => w.ClientId == clientId);
            }
        }

        // TODO: AddApiAudience by site-admi 
        // see AudiencesStore.AddAudience in http://bitoftech.net/2014/10/27/json-web-token-asp-net-web-api-2-jwt-owin-authorization-server/

        /// <summary>
        /// Create new User Security Questions and Answers via Registration (HPCDS-16, story)
        /// </summary>
        /// <param name="user"></param>
        /// <param name="userQuestions"></param>
        internal static void CreateUserQuestions(ApplicationUser user, List<ChallengeQandAViewModel> userQuestions)
        {
            using (ApplicationDbContext dbContext = new ApplicationDbContext())
            {
                // Remove, any pre-existing question if any
                var currentUserQuestions = dbContext.UserQuestions.Where(w => w.U_ID == user.Id);
                dbContext.UserQuestions.RemoveRange(currentUserQuestions);

                // Add/Re-insert, user questions from view model
                int i = 1;
                foreach (var q in userQuestions)
                {
                    dbContext.UserQuestions.Add(new UserQuestion() { U_ID = user.Id, Q_ID = q.Q_ID, Answer = q.Answer.ToLower(), DisplayOrder = i++ });
                }
                dbContext.SaveChanges();
            }
        }
       
        /// <summary>
        /// Create Organization and Address Info
        /// </summary>
        /// <param name="modelVM"></param>
        /// <returns>Id of Organization Created</returns>
        internal static int CreateOrganization(OrganizationViewModel modelVM)
        {
            using (ApplicationDbContext dbContext = new ApplicationDbContext())
            {
                dbContext.Database.Log = x => System.Diagnostics.Debug.WriteLine(x);

                Organization model = new Organization()
                {
                    OrganizationName = modelVM.OrganizationName,
                    DUNSNumber = modelVM.DUNSNumber,
                    IsSameAsMailingAddress = modelVM.IsSameAsMailingAddress,
                    ModifiedOn = DateTime.UtcNow,
                    CreatedOn = DateTime.UtcNow,
                };

                model.Addresses.Add(modelVM.MailingAddress);
                if (!modelVM.IsSameAsMailingAddress)
                {
                    model.Addresses.Add(modelVM.PhysicalAddress);
                }

                dbContext.Organizations.Add(model);
                dbContext.SaveChanges();

                return model.ID;
            }
        }

        internal static List<IdentityRole> GetAppRolesFor(List<string> roleNames, Boolean contains = true)
        {
            using (ApplicationDbContext dbContext = new ApplicationDbContext())
            {
                var roleStore = new RoleStore<IdentityRole>(dbContext);
                var result = roleStore.Roles.Where(w => contains ? roleNames.Contains(w.Name) : !roleNames.Contains(w.Name)).ToList();
                return result;
            }
        }

        internal static List<ApplicationUser> GetUsersFor(List<string> roleNames, Boolean contains = true)
        {
            using (ApplicationDbContext dbContext = new ApplicationDbContext())
            {
                var roles = GetAppRolesFor(roleNames, contains);
                var roleIds = roles.Select(s => s.Id);
                return dbContext.Users.Where(w => w.Roles.Any(a => roleIds.Contains(a.RoleId))).ToList();
            }
        }

        internal static ICollection<ApplicationUser> GetAdminUsers()
        {
            return GetUsersFor(new List<string>(new string[] { UserRoles.AppAdmin, UserRoles.SiteAdmin, UserRoles.StateAdmin }));
        }

        internal static bool IsOrganizationActive(int organizationId)
        {
            var result = false;
            using (ApplicationDbContext dbContext = new ApplicationDbContext())
            {
                var roles = GetAppRolesFor(new List<string>(new string[] { UserRoles.PendingAccess }), false);
                var roleIds = roles.Select(s => s.Id);
                result = dbContext.Organizations.Where(w => w.ID == organizationId && w.IsActive).Any(a => a.Users.Any(u => u.Roles.Any(r => roleIds.Contains(r.RoleId))));
            }
            return result;
        }

        internal static OrganizationViewModel GetOrganizationInfo(int organizationId)
        {
            OrganizationViewModel result = new OrganizationViewModel();
            using (ApplicationDbContext dbContext = new ApplicationDbContext())
            {
                var org = dbContext.Organizations.Where(o => o.ID == organizationId).FirstOrDefault();

                result.ID = organizationId;
                result.IsActive = org.IsActive;
                result.IsLegacy = org.IsLegacy;
                result.IsSameAsMailingAddress = org.IsSameAsMailingAddress;
                result.LegacyWaPins = org.LegacyWaPins;
                result.OrganizationName = org.OrganizationName;
                result.PIN = org.PIN;
                result.ContactUserId = org.ContactUserId;
                result.DUNSNumber = org.DUNSNumber;

                result.Users = org.Users; // List of Members
                result.PhysicalAddress = org.Addresses.Where(m => m.AddressType == DbConstants.AddressTypeEnum.Physical).FirstOrDefault() ?? new OrganizationAddress(addressType: DbConstants.AddressTypeEnum.Physical);
                result.MailingAddress = org.Addresses.Where(m => m.AddressType == DbConstants.AddressTypeEnum.Mailing).FirstOrDefault() ?? new OrganizationAddress(addressType: DbConstants.AddressTypeEnum.Mailing);
            }
            return result;
        }

        /// <summary>
        /// Create Organization and Address Info
        /// </summary>
        /// <param name="modelVM"></param>
        /// <returns>Id of Organization Created</returns>
        internal static void UpdateOrganization(OrganizationViewModel modelVM)
        {
            using (ApplicationDbContext dbContext = new ApplicationDbContext())
            {
                dbContext.Database.Log = x => System.Diagnostics.Debug.WriteLine(x);
                var org = dbContext.Organizations.Where(o => o.ID == modelVM.ID).FirstOrDefault();
                org.OrganizationName = modelVM.OrganizationName;
                org.DUNSNumber = modelVM.DUNSNumber;
                org.IsSameAsMailingAddress = modelVM.IsSameAsMailingAddress;
                org.ModifiedOn = DateTime.UtcNow;
                org.ContactUserId = modelVM.ContactUserId;
                dbContext.SaveChanges();
                foreach (var i in modelVM.Addresses)
                {
                    var addr = dbContext.OrganizationAddresses.Where(a => a.ID == i.ID && a.OrganizationID == i.OrganizationID).FirstOrDefault();
                    
                    if (addr != null)
                    {
                        if (addr.AddressType == DbConstants.AddressTypeEnum.Physical && modelVM.IsSameAsMailingAddress)
                        {
                            dbContext.OrganizationAddresses.Remove(addr);
                        }
                        else { 
                            addr.AddressLine1 = i.AddressLine1;
                            addr.AddressLine2 = i.AddressLine2;
                            addr.City = i.City;
                            addr.CountryCd = i.CountryCd;
                            addr.PostalCodeNumber = i.PostalCodeNumber;
                            addr.StateProv = i.StateProv;
                        }
                    }
                    else {
                        i.OrganizationID = modelVM.ID;
                        dbContext.OrganizationAddresses.Add(i);
                    }
                    dbContext.SaveChanges();
                }
            }
        }
    }
}