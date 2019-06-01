using hpcds.Code.Constants;
using hpcds.Models;
using Microsoft.AspNet.Identity.Owin;
using System.Web;
using System.Web.Mvc;

namespace hpcds.Controllers
{
    [Authorize(Roles = UserRoles.Reporters)]
    public class ReportsController : Controller
    {
        private ApplicationSignInManager _signInManager;
        private ApplicationUserManager _userManager;

        public ReportsController()
        {
        }

        public ReportsController(ApplicationUserManager userManager, ApplicationSignInManager signInManager)
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

        // GET: /Reports/Index
        public ActionResult Index()
        {
            return View(new InventoryViewModel());
        }

        [HttpPost]
        public ActionResult Index(InventoryViewModel model)
        {
            return View(model);
        }
    }
}
