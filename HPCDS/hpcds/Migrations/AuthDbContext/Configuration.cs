namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using hpcds.Models;
    using Microsoft.AspNet.Identity;
    using Microsoft.AspNet.Identity.EntityFramework;

    internal sealed class Configuration : DbMigrationsConfiguration<SeederDbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
            MigrationsDirectory = @"Migrations\AuthDbContext";
        }

        protected override void Seed(SeederDbContext context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
            //  to avoid creating duplicate seed data.

            // -- Lookup: Security Questions
            context.SecurityQuestions.AddOrUpdate(q => q.ID,
                new SecurityQuestion() { ID = 1, Questions = "What was your childhood nickname?" },
                new SecurityQuestion() { ID = 2, Questions = "In what city did you meet your spouse/significant other?" },
                new SecurityQuestion() { ID = 3, Questions = "What is the name of your favorite childhood friend?" },
                new SecurityQuestion() { ID = 4, Questions = "What street did you live on in third grade?" },
                new SecurityQuestion() { ID = 5, Questions = "What is your oldest sibling’s birthday month and year?" },
                new SecurityQuestion() { ID = 6, Questions = "What is the middle name of your youngest child?" },
                new SecurityQuestion() { ID = 7, Questions = "What is your oldest sibling's middle name?" },
                new SecurityQuestion() { ID = 8, Questions = "What school did you attend for sixth grade?" },
                new SecurityQuestion() { ID = 9, Questions = "What was your childhood phone number including area code?" },
                new SecurityQuestion() { ID = 10, Questions = "What is your oldest cousin's first and last name?" },
                new SecurityQuestion() { ID = 11, Questions = "What was the name of your first stuffed animal?" },
                new SecurityQuestion() { ID = 12, Questions = "In what city or town did your mother and father meet?" },            // Seed user Q&A #1
                new SecurityQuestion() { ID = 13, Questions = "What was the last name of your third grade teacher?" },
                new SecurityQuestion() { ID = 14, Questions = "In what city does your nearest sibling live?" },
                new SecurityQuestion() { ID = 15, Questions = "What is your youngest brother’s birthday month and year?" },
                new SecurityQuestion() { ID = 16, Questions = "What is your maternal grandmother's maiden name?" },
                new SecurityQuestion() { ID = 17, Questions = "In what city or town was your first job?" },
                new SecurityQuestion() { ID = 18, Questions = "What is the name of the place your wedding reception was held?" },   // Seed user Q&A #2
                new SecurityQuestion() { ID = 19, Questions = "What is the name of a college you applied to but didn't attend?" },
                new SecurityQuestion() { ID = 20, Questions = "Where were you when you first heard about 9/11?" },
                new SecurityQuestion() { ID = 21, Questions = "What was the name of your elementary / primary school?" },
                new SecurityQuestion() { ID = 22, Questions = "What is the name of the company of your first job?" },
                new SecurityQuestion() { ID = 23, Questions = "What was your favorite place to visit as a child?" },
                new SecurityQuestion() { ID = 24, Questions = "What is your spouse's mother's maiden name?" },
                new SecurityQuestion() { ID = 25, Questions = "What is the country of your ultimate dream vacation?" },
                new SecurityQuestion() { ID = 26, Questions = "What is the name of your favorite childhood teacher?" },
                new SecurityQuestion() { ID = 27, Questions = "To what city did you go on your honeymoon?" },
                new SecurityQuestion() { ID = 28, Questions = "What time of the day were you born?" },
                new SecurityQuestion() { ID = 29, Questions = "What was your dream job as a child?" },
                new SecurityQuestion() { ID = 30, Questions = "What is the street number of the house you grew up in?" },
                new SecurityQuestion() { ID = 31, Questions = "What is the license plate (registration) of your dad's first car?" },
                new SecurityQuestion() { ID = 32, Questions = "Who was your childhood hero?" },
                new SecurityQuestion() { ID = 33, Questions = "What was the first concert you attended?" },
                new SecurityQuestion() { ID = 34, Questions = "What is your mother's maiden name?" },
                new SecurityQuestion() { ID = 35, Questions = "What was the color of your first car?" },
                new SecurityQuestion() { ID = 36, Questions = "What is your father's middle name?" },
                new SecurityQuestion() { ID = 37, Questions = "What was your favorite sport in high school?" },
                new SecurityQuestion() { ID = 38, Questions = "What month and day is your anniversary?" },
                new SecurityQuestion() { ID = 39, Questions = "What is your grandmother's first name?" },
                new SecurityQuestion() { ID = 40, Questions = "What is your mother's middle name?" },
                new SecurityQuestion() { ID = 41, Questions = "What is the last name of your favorite high school teacher?" },
                new SecurityQuestion() { ID = 42, Questions = "What was the make and model of your first car?" },
                new SecurityQuestion() { ID = 43, Questions = "Where did you vacation last year?" },
                new SecurityQuestion() { ID = 44, Questions = "What is the name of your grandmother's dog?" },
                new SecurityQuestion() { ID = 45, Questions = "What is the name, breed, and color of current pet?" },       // Seed user Q&A #3
                new SecurityQuestion() { ID = 46, Questions = "What is your preferred musical genre?" },
                new SecurityQuestion() { ID = 47, Questions = "In what city and country do you want to retire?" },
                new SecurityQuestion() { ID = 48, Questions = "What is the name of the first undergraduate college you attended?" },
                new SecurityQuestion() { ID = 49, Questions = "What was your high school mascot?" },
                new SecurityQuestion() { ID = 50, Questions = "What year did you graduate from High School?" },
                new SecurityQuestion() { ID = 51, Questions = "What is the name of the first school you attended?" }
            );
            // ---        Update Sequence
            context.SaveChanges();
            context.Database.ExecuteSqlCommand(@"
                    DECLARE @nextSeq int;
                    DECLARE @sql nvarchar(max);
                    SELECT TOP(1) @nextSeq = ID + 1 FROM dbo.SecurityQuestions ORDER BY ID desc;
                    SET @sql = N'ALTER SEQUENCE dbo.SeqQuestionId RESTART WITH '+ CAST(@nextSeq as nvarchar(20)) +';';
                    EXEC SP_EXECUTESQL @sql;
            ");

            // -- Lookup: Authorization Roles and managers
            var roleStore = new RoleStore<IdentityRole>(context);
            var roleManager = new RoleManager<IdentityRole>(roleStore);
            roleManager.Create(new IdentityRole { Name = Code.Constants.UserRoles.AppAdmin });
            roleManager.Create(new IdentityRole { Name = Code.Constants.UserRoles.SiteAdmin });
            roleManager.Create(new IdentityRole { Name = Code.Constants.UserRoles.StateAdmin });
            roleManager.Create(new IdentityRole { Name = Code.Constants.UserRoles.Reporters });
            roleManager.Create(new IdentityRole { Name = Code.Constants.UserRoles.PendingAccess });

            // -- User, ultra Site Admin (ERG)
            var userStore = new UserStore<ApplicationUser>(context);
            var userManager = new ApplicationUserManager(userStore);

            var userAppAdmin = userManager.FindByEmail("hpcds@erg.com")
                             ?? new ApplicationUser() { FirstName = "ERG", LastName = "HPCDS", UserName = "hpcds@erg.com", Hometown = "LEX", Email = "hpcds@erg.com", O_ID = -1 };
            if (String.IsNullOrEmpty(userAppAdmin.PasswordHash))
                userManager.Create(userAppAdmin, "Let$test1st");
            userAppAdmin.FirstName = "ERG"; userAppAdmin.LastName = "HPCDS"; userAppAdmin.EmailConfirmed = true;
            userManager.Update(userAppAdmin);
            userManager.AddToRole(userAppAdmin.Id, Code.Constants.UserRoles.SiteAdmin);
            Guid appAdminId = Guid.Parse(userAppAdmin.Id);

            // -- Organization, state and site admin organizations; plus an active (995) and inactive (996) test org
            context.Organizations.AddOrUpdate(o => o.ID,
                new Organization() { ID =  -1, OrganizationName = "TBD"         , IsActive = false,PIN = null     , CreatedBy = appAdminId, CreatedOn = DateTime.UtcNow, ModifiedBy = appAdminId, ModifiedOn = DateTime.UtcNow },
                
                new Organization() { ID = 800, OrganizationName = "ERG"         , IsActive = true, PIN = "1b3d5f7", CreatedBy = appAdminId, CreatedOn = DateTime.UtcNow, ModifiedBy = appAdminId, ModifiedOn = DateTime.UtcNow },
                new Organization() { ID = 801, OrganizationName = "NEWMOA"      , IsActive = true, PIN = "a2c4e6g", CreatedBy = appAdminId, CreatedOn = DateTime.UtcNow, ModifiedBy = appAdminId, ModifiedOn = DateTime.UtcNow },
                new Organization() { ID = 803, OrganizationName = "Oregon Health Authority", IsActive = true, PIN = "2c4e6g8", CreatedBy = appAdminId, CreatedOn = DateTime.UtcNow, ModifiedBy = appAdminId, ModifiedOn = DateTime.UtcNow },
                new Organization() { ID = 804, OrganizationName = "Vermont Department of Health", IsActive = true, PIN = "c4e6g8i", CreatedBy = appAdminId, CreatedOn = DateTime.UtcNow, ModifiedBy = appAdminId, ModifiedOn = DateTime.UtcNow },
                new Organization() { ID = 805, OrganizationName = "Washington State Department of Ecology", IsActive = true, PIN = "b3d5f7h", CreatedBy = appAdminId, CreatedOn = DateTime.UtcNow, ModifiedBy = appAdminId, ModifiedOn = DateTime.UtcNow, IsSameAsMailingAddress = false },

                new Organization() { ID = 995, OrganizationName = "Active Org"  , IsActive = true, PIN = "tA5f7h9", CreatedBy = appAdminId, CreatedOn = DateTime.UtcNow, ModifiedBy = appAdminId, ModifiedOn = DateTime.UtcNow, IsSameAsMailingAddress = false },
                new Organization() { ID = 996, OrganizationName = "Inactive Org", IsActive = false,PIN = null     , CreatedBy = appAdminId, CreatedOn = DateTime.UtcNow, ModifiedBy = appAdminId, ModifiedOn = DateTime.UtcNow, IsSameAsMailingAddress = false }
                );

            // -- Address, for the core organizations
            context.OrganizationAddresses.AddOrUpdate(a => new { a.OrganizationID, a.AddressType },
                new OrganizationAddress() { ID = 800, OrganizationID = 800, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Mailing, AddressLine1 = "110 Hartwell Ave", AddressLine2 = "", City = "Lexington", StateProv = "MA", CountryCd = "US", PostalCodeNumber = "02421" },
                new OrganizationAddress() { ID = 801, OrganizationID = 801, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Mailing, AddressLine1 = "89 South Street, Suite 600", AddressLine2 = "", City = "Boston", StateProv = "MA", CountryCd = "US", PostalCodeNumber = "02111" },
                new OrganizationAddress() { ID = 803, OrganizationID = 803, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Mailing, AddressLine1 = "800 NE Oregon Street, Suite 640", AddressLine2 = "", City = "Portland", StateProv = "OR", CountryCd = "US", PostalCodeNumber = "97232" },
                new OrganizationAddress() { ID = 804, OrganizationID = 804, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Mailing, AddressLine1 = "108 Cherry Street", AddressLine2 = "P.O. Box 70 – Drawer 30", City = "Burlington", StateProv = "VT", CountryCd = "US", PostalCodeNumber = "05402-0070" },
                new OrganizationAddress() { ID = 805, OrganizationID = 805, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Mailing, AddressLine1 = "PO Box 47600", AddressLine2 = "", City = "Olympia", StateProv = "WA", CountryCd = "US", PostalCodeNumber = "98504-7600" },
                new OrganizationAddress() { ID = 806, OrganizationID = 805, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Physical, AddressLine1 = "300 Desmond Drive SE", AddressLine2 = "", City = "Lacey", StateProv = "WA", CountryCd = "US", PostalCodeNumber = "98503" },

                new OrganizationAddress() { ID = 995, OrganizationID = 995, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Mailing, AddressLine1 = "Fake Mailing Address Line 1", AddressLine2 = "MAddLn2 for Fake Active Org", City = "Boston", StateProv = "MA", CountryCd = "US", PostalCodeNumber ="01234" },
                new OrganizationAddress() { ID = 997, OrganizationID = 995, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Physical, AddressLine1 = "Fake Physcial Address Line 1", AddressLine2 = "PAddLn2 for Fake Active Org", City = "Boston", StateProv = "MA", CountryCd = "US", PostalCodeNumber = "43210" },

                new OrganizationAddress() { ID = 996, OrganizationID = 996, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Mailing, AddressLine1 = "Fake Mailing Address Line 1", AddressLine2 = "MAddLn2 for Fake InActive Org", City = "Boston", StateProv = "MA", CountryCd = "US", PostalCodeNumber = "01234" },
                new OrganizationAddress() { ID = 998, OrganizationID = 996, AddressType = Code.Constants.DbConstants.AddressTypeEnum.Physical, AddressLine1 = "Fake Physcial Address Line 1", AddressLine2 = "PAddLn2 for Fake InActive Org", City = "Boston", StateProv = "MA", CountryCd = "US", PostalCodeNumber = "43210" }
                );

            // -- User, Info and their Roles
            var userSiteAdmin = userManager.FindByEmail("site.admin@erg.com") 
                             ?? new ApplicationUser() { FirstName="F", LastName="L", UserName = "site.admin@erg.com", Hometown = "LEX", Email = "site.admin@erg.com", O_ID = -1 };
            if (String.IsNullOrEmpty(userSiteAdmin.PasswordHash))
                userManager.Create(userSiteAdmin, "Let$test2");
            userSiteAdmin.FirstName = "Site"; userSiteAdmin.LastName = "Admin"; userSiteAdmin.EmailConfirmed = true; userSiteAdmin.LockoutEnabled = true;
            userSiteAdmin.O_ID = 801; //NEWMOA
            userManager.Update(userSiteAdmin);
            userManager.AddToRole(userSiteAdmin.Id, Code.Constants.UserRoles.SiteAdmin);

            context.Organizations.Where(w => w.ID == userSiteAdmin.O_ID).First().ContactUserId = userSiteAdmin.Id; // set Contact for Organization

            var userStateAdmin = userManager.FindByEmail("state.admin@erg.com")
                             ?? new ApplicationUser() { FirstName = "F", LastName = "L", UserName = "state.admin@erg.com", Hometown = "VT-OR-WA", Email = "state.admin@erg.com", O_ID = -1 };
            if (String.IsNullOrEmpty(userStateAdmin.PasswordHash))
                userManager.Create(userStateAdmin, "Let$test2");
            userStateAdmin.FirstName = "State"; userStateAdmin.LastName = "Admin"; userStateAdmin.LockoutEnabled = true;
            userStateAdmin.O_ID = 803; //OR, TFKA
            userManager.Update(userStateAdmin);
            userManager.AddToRole(userStateAdmin.Id, Code.Constants.UserRoles.StateAdmin);

            context.Organizations.Where(w => w.ID == userStateAdmin.O_ID).First().ContactUserId = userStateAdmin.Id; // set Contact for Organization

            var userReporter = userManager.FindByEmail("reporter@erg.com")
                             ?? new ApplicationUser() { FirstName = "F", LastName = "L", UserName = "reporter@erg.com", Hometown = "MA", Email = "reporter@erg.com", O_ID = -1 };
            if (String.IsNullOrEmpty(userReporter.PasswordHash))
                userManager.Create(userReporter, "Let$test2");
            userReporter.FirstName = "First"; userReporter.LastName = "Reporter"; userReporter.LockoutEnabled = true;
            userReporter.EmailConfirmed = true;
            userReporter.O_ID = 995; // Test 'Active Org'
            userManager.Update(userReporter);
            userManager.AddToRole(userReporter.Id, Code.Constants.UserRoles.Reporters);

            context.Organizations.Where(w => w.ID == userReporter.O_ID).First().ContactUserId = userReporter.Id; // set Contact for Organization

            var newUser = userManager.FindByEmail("new@erg.com")
                             ?? new ApplicationUser() { FirstName = "F", LastName = "L", UserName = "new@erg.com", Hometown = "TX", Email = "new@erg.com", O_ID = -1 };
            if (String.IsNullOrEmpty(newUser.PasswordHash))
                userManager.Create(newUser, "Let$test2");
            newUser.FirstName = "New"; newUser.LastName = "Reporter"; newUser.LockoutEnabled = true;
            newUser.EmailConfirmed = false;
            newUser.O_ID = 995; // Test new user to existing/'Active Org'
            userManager.Update(newUser);
            userManager.AddToRole(newUser.Id, Code.Constants.UserRoles.PendingAccess);

            var newUserOrg = userManager.FindByEmail("newUserOrg@erg.com")
                             ?? new ApplicationUser() { FirstName = "F", LastName = "L", UserName = "newUserOrg@erg.com", Hometown = "PR", Email = "newUserOrg@erg.com", O_ID = -1 };
            if (String.IsNullOrEmpty(newUserOrg.PasswordHash))
                userManager.Create(newUserOrg, "Let$test2");
            newUserOrg.FirstName = "New User"; newUserOrg.LastName = "& Org"; newUserOrg.LockoutEnabled = true;
            newUserOrg.EmailConfirmed = false;
            newUserOrg.O_ID = 996; // Test new user AND new org 'Inctive Org'
            userManager.Update(newUserOrg);
            userManager.AddToRole(newUserOrg.Id, Code.Constants.UserRoles.PendingAccess);

            context.Organizations.Where(w => w.ID == newUserOrg.O_ID).First().ContactUserId = newUserOrg.Id; // set Contact for Organization

            // -- Users, (fix) remove any Q&As from prior core-seed where they were incorrectly set to 1, 2, 3
            List<string> allTestUserIds = new List<string> { userAppAdmin.Id, userSiteAdmin.Id, userStateAdmin.Id, userReporter.Id, newUser.Id, newUserOrg.Id };
            context.UserQuestions.RemoveRange(context.UserQuestions.Where(w => allTestUserIds.Contains(w.U_ID)));
            context.SaveChanges();

            // -- User, Challenge Q&A
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 12, U_ID = userSiteAdmin.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 18, U_ID = userSiteAdmin.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 45, U_ID = userSiteAdmin.Id, Answer = "ans" });

            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 12, U_ID = userStateAdmin.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 18, U_ID = userStateAdmin.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 45, U_ID = userStateAdmin.Id, Answer = "ans" });

            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 12, U_ID = userReporter.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 18, U_ID = userReporter.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 45, U_ID = userReporter.Id, Answer = "ans" });

            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 12, U_ID = newUser.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 18, U_ID = newUser.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 45, U_ID = newUser.Id, Answer = "ans" });

            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 12, U_ID = newUserOrg.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 18, U_ID = newUserOrg.Id, Answer = "ans" });
            context.UserQuestions.AddOrUpdate(new UserQuestion() { Q_ID = 45, U_ID = newUserOrg.Id, Answer = "ans" });

            // -- Data, Api Audiences
            context.ApiAudience.AddOrUpdate(new ApiAudience() { Name = "odata-hpcds", ClientId = "099153c2625149bc8ecb3e85e03f0022", Base64Secret = "IxrAjDoa2FqElO7IhrSrUJELhUckePEPVpaePlS_Xaw", Domain = "https://carbdev.erg.com/odata/hpcds" });

            // -- Data, Legacy Data into HPCDS's official Organization list
            context.Database.ExecuteSqlCommand(@"
                    DECLARE @appAdmin uniqueidentifier 
                    SELECT @appAdmin = u.Id FROM dbo.AspNetUsers u WHERE u.Username LIKE 'hpcds@erg.com';
                    PRINT @appAdmin;

                    -- Add Organizations from Consolidated Legacy Org table (HPCDS-11)
                    MERGE [dbo].[Organizations] o
                    Using [hpcds-states].[dbo].[Legacy_Organization] l ON o.ID = l.[MOID]
						WHEN MATCHED 
							THEN UPDATE
							   SET o.[PIN] = ISNULL(o.PIN,l.[WA PIN]) -- update only if it's not null
								  ,o.[OrganizationName] = l.[MASTERNAME]
								  ,o.[IsLegacy] = 1
								  ,o.[LegacyWaPins] = STUFF(
                                                            ISNULL('; ' + l.[WA PIN], '')+
                                                            ISNULL('; ' + l.[WA-PIN2], '')+
                                                            ISNULL('; ' + l.[WA-PIN3], ''), 1, 2, '')
								  ,o.[IsSameAsMailingAddress] = 1
								  ,o.[ModifiedBy] = @appAdmin
								  ,o.[ModifiedOn] = GETUTCDATE()
						WHEN NOT MATCHED BY TARGET 
							THEN INSERT ([ID],[PIN],[OrganizationName],[IsLegacy],[IsActive],[IsSameAsMailingAddress],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn], [LegacyWaPins])
								 VALUES (l.[MOID],l.[WA PIN],l.[MASTERNAME]    ,1,0	        ,1                       ,@appAdmin,GETUTCDATE(),  @appAdmin,GETUTCDATE(), STUFF( ISNULL('; ' + l.[WA PIN], '')+ISNULL('; ' + l.[WA-PIN2], '')+ISNULL('; ' + l.[WA-PIN3], ''), 1, 2, ''))	
                    ;

					-- Add Physcial Address Location
					MERGE [dbo].[OrganizationAddresses] a
					Using [hpcds-states].[dbo].[Legacy_Organization] l ON a.[ID] = l.[MOID]
						WHEN MATCHED 
							THEN UPDATE
								SET  a.[AddressLine1] = ISNULL(l.[Line1Address],LEFT(l.[Physical Address (VT)],150)) -- HPCDS-3 (temp) Use trunc version of VT
									,a.[AddressLine2]		= l.[Line2Address]
									,a.[City]				= l.[CityName]
									,a.[StateProv]			= l.[StateCode]
									,a.[PostalCodeNumber]	= l.[PostalCodeNumber]
									,a.[CountryCd]			= l.[CountryCode]
									,a.[AddressType]		= 0
						WHEN NOT MATCHED BY TARGET 
							THEN INSERT ([ID],[OrganizationID],[AddressType],[AddressLine1],[AddressLine2]  ,[City]      ,[StateProv]  ,[PostalCodeNumber]  ,[CountryCd])
								 VALUES (l.[MOID],l.[MOID]                ,0,ISNULL(l.[Line1Address],LEFT(l.[Physical Address (VT)],150))
                                                                                           ,l.[Line2Address],l.[CityName],l.[StateCode],l.[PostalCodeNumber],l.[CountryCode])
					;

            ");

            base.Seed(context);
        }
    }
}
