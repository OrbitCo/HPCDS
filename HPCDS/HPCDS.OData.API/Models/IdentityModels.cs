using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace HPCDS.OData.API.Models
{
    // You can add profile data for the user by adding more properties to your ApplicationUser class, please visit https://go.microsoft.com/fwlink/?LinkID=317594 to learn more.
    public class ApplicationUser : IdentityUser
    {
        [Required] [MaxLength(50)]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }

        [Required] [MaxLength(50)]
        [Display(Name ="Last Name")]
        public string LastName { get; set; }

        [Display(Name ="International Number")]
        public bool PhoneInternationalFlag { get; set; }
        
        public string Hometown { get; set; } // TODO: Remove

        [Display(Name ="Security Questions")]
        public virtual ICollection<UserQuestion> UserQuestions { get; set; }

        [Display(Name = "Organization")]
        public int O_ID { get; set; }
        public virtual Organization Organization { get; set; }

        [Display(Name = "Times Incorrectly Answered")] // as secutity question (HPCDS-80)
        public int SecQandAFailCount { get; set; }

        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, DefaultAuthenticationTypes.ApplicationCookie);
            // Add custom user claims here
            return userIdentity;
        }
        [MaxLength(50)]
        [Display(Name = "Job title")]
        public string JobTitle { get; set; } 
    }

    /// <summary>
    /// List of approved ClientId allowed to have access to the api
    /// </summary>
    public class ApiAudience
    {
        [Key]
        [MaxLength(32)]
        public string ClientId { get; set; }

        [MaxLength(80)]
        [Required]
        public string Base64Secret { get; set; }

        [MaxLength(100)]
        [Required]
        public string Name { get; set; }

        [MaxLength(100)]
        [Required]
        public string Domain { get; set; }
    }

}