using hpcds.Code.Constants;
using hpcds.Providers;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using System.Web;
using System.Web.Mvc;

namespace hpcds.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {

        private ApplicationSignInManager _signInManager;
        private ApplicationUserManager _userManager;

        public HomeController()
        {
        }

        public HomeController(ApplicationUserManager userManager, ApplicationSignInManager signInManager)
        {
            UserManager = userManager;
            SignInManager = signInManager;
        }

        public ApplicationSignInManager SignInManager
        {
            get
            {
                return _signInManager ?? HttpContext.GetOwinContext().Get<ApplicationSignInManager>();
            }
            private set
            {
                _signInManager = value;
            }
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }

        public ActionResult Index()
        {
            var userId = User.Identity.GetUserId();
            var user = UserManager.FindById(userId);
            ViewBag.IsEmailConfirmed = user.EmailConfirmed;
            ViewBag.IsOrganizationActive = DataProviderAuth.IsOrganizationActive(user.O_ID);

            // TODO: (HPCDS-70) - find alt method to display
            Session["CurrentUsersName"] = user.FirstName + " " + user.LastName;
            Session["CurrentUsersOrg"] = user?.Organization.OrganizationName ?? "ERROR, No Organization";

            bool isPendingAccess = User.IsInRole(UserRoles.PendingAccess);
            if ( isPendingAccess && !ViewBag.IsEmailConfirmed)
            { // Registration Submitted but user hasn't confirmed email, hence
              // User is Required to Check Email and Confirm or Request for the email to be resent
                ViewBag.Title = "Account Information Submitted"; // or "Registration Submitted" 
#if DEBUG
                ViewBag.DebugMessage = TempData["DebugMessage"] ?? "Request to resend, with button above";
                TempData["DebugMessage"] = null;
#endif
            }
            else if (isPendingAccess && ViewBag.IsEmailConfirmed)
            { // Requires a site/state admin to approve the registration
                ViewBag.Title = "Email Address Validated"; // or  "Pending Access" 
				// TODO: HPCDS-25/HPCDS-35
#if DEBUG
                ViewBag.DebugMessage = TempData["DebugMessage"] ?? "Request to resend, with button above";
                TempData["DebugMessage"] = null;
#endif
            }
            else 
            { // Access Granted
                ViewBag.Title = "Dashboard";
            }

            return View();
        }
    }
}
