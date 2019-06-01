using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using static hpcds.Code.Constants.DbConstants;

namespace hpcds.Models
{
    // Models returned by AccountController actions.
    public class ExternalLoginConfirmationViewModel
    {
        [Required]
        [Display(Name = "Email")]
        public string Email { get; set; }

        [Display(Name = "Hometown")]
        public string Hometown { get; set; }
    }

    public class ExternalLoginListViewModel
    {
        public string ReturnUrl { get; set; }
    }

    public class SendCodeViewModel
    {
        public string SelectedProvider { get; set; }
        public ICollection<System.Web.Mvc.SelectListItem> Providers { get; set; }
        public string ReturnUrl { get; set; }
        public bool RememberMe { get; set; }
    }

    public class VerifyCodeViewModel
    {
        [Required]
        public string Provider { get; set; }

        [Required]
        [Display(Name = "Code")]
        public string Code { get; set; }
        public string ReturnUrl { get; set; }

        [Display(Name = "Remember this browser?")]
        public bool RememberBrowser { get; set; }

        public bool RememberMe { get; set; }
    }

    public class ForgotViewModel
    {
        [Required]
        [Display(Name = "Email")]
        public string Email { get; set; }
    }

    public class LoginViewModel
    {
        [Required]
        [Display(Name = "Email")]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [Display(Name = "Remember me?")]
        public bool RememberMe { get; set; }
    }
    
    public class UserProfileViewModel
    {
        
        [Required]
        [MaxLength(50)]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }

        [Required]
        [MaxLength(50)]
        [Display(Name = "Last Name")]
        public string LastName { get; set; }

        [Display(Name = "This is a non-U.S. telephone number")]
        public bool PhoneInternationalFlag { get; set; }

        [MaxLength(25)]
        [Display(Name = "Telephone Number")]
        public string PhoneNumber { get; set; }

        [EmailAddress]
        [Display(Name = "Email")]
        public virtual string Email { get; set; }

        public bool HasPassword { get; set; }

        public List<ChallengeQandAViewModel> Qs { get; set; }

        [Display(Name = "Organization")]
        public virtual Organization Organization { get; set; }
        
        [Display(Name = "Job Title")]
        public string JobTitle { get; set; }
    }

    public class RegisterViewModel : UserProfileViewModel
    {
        [Required]	
        public override string Email { get; set; }
	
        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirm password")]
        [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }

        // TODO: (HPCDS-16) --> remove
        [Display(Name = "Hometown")]
        public string Hometown { get; set; }
        // <--

        [Display(Name = "Is your Organization already registered?")]
        public bool IsHpcdsOrganization { get; set; } = true;

        [Display(Name = "Search and select from registered organizations")]
        [UIHint("cbOrganizations")]
        public int? O_ID { get; set; }

        [Display(Name = "Register new organization")]
        public OrganizationViewModel NewOrganization { get; set; } = new OrganizationViewModel();
    }

    public class ResetPasswordByAdminViewModel
    {
        [EmailAddress]
        [Display(Name = "Email")]
        public string Email { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirm password")]
        [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }

        public List<ChallengeQandAViewModel> Questions { get; set; }

        public string Code { get; set; }
    }

    [NotMapped]
    public class OrganizationViewModel : Organization
    {
        public OrganizationViewModel()
        {
            MailingAddress = new OrganizationAddress();
            PhysicalAddress = new OrganizationAddress(AddressTypeEnum.Physical);
        }

        [Display(Name = "Mailing Address")]
        public OrganizationAddress MailingAddress { get; set; }

        [Display(Name = "Physical Address")]
        public OrganizationAddress PhysicalAddress { get; set; }

    }


    public class ChallengeQandAViewModel
    {
        [UIHint("ddQuestions")]
        [Required]
        [ForeignKey("SecurityQuestion")]
        [Display(Name = "Question")]
        public int Q_ID { get; set; }

        [Display(Name = "Question")]
        public string Question { get; set; }

        [Required]
        [StringLength(100)]
        [MinLength(3)]
        [Display(Name = "Answer")]
        public string Answer { get; set; }

        public string UserId { get; set; }

        public string Code { get; set; }

        public virtual SecurityQuestion SecurityQuestion { get; set; }
    }

    public class ResetPasswordViewModel
    {
        [Required]
        [EmailAddress]
        [Display(Name = "Email")]
        public string Email { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirm password")]
        [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }

        public string Code { get; set; }
    }

    public class ForgotPasswordViewModel
    {
        [Required]
        [EmailAddress]
        [Display(Name = "Email")]
        public string Email { get; set; }
    }

    public class SendResetLinkViewModel
    {
        public string SelectedUserId { get; set; }
        public ICollection<System.Web.Mvc.SelectListItem> Users { get; set; }
        public bool IsSend { get; set; } = false;
    }
}
