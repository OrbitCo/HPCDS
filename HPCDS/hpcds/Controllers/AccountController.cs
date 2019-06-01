using hpcds.Code.Constants;
using hpcds.Models;
using hpcds.Providers;
using HPCDS.Resources;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using static hpcds.Code.NetOverrides.IdentityOverrides;

namespace hpcds.Controllers
{
    [Authorize]
    public class AccountController : Controller
    {
        private ApplicationSignInManager _signInManager;
        private ApplicationUserManager _userManager;
        private EmailService _eService;

        public AccountController()
        {
        }

        public AccountController(ApplicationUserManager userManager, ApplicationSignInManager signInManager, EmailService eService)
        {
            UserManager = userManager;
            SignInManager = signInManager;
            EService = eService;
        }

        public EmailService EService
        {
            get
            {
                return _eService ?? new EmailService();
            }
            private set
            {
                _eService = value;
            }
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

        // The Authorize Action is the end point which gets called when you access any
        // protected Web API. If the user is not logged in then they will be redirected to 
        // the Login page. After a successful login you can call a Web API.
        [HttpGet]
        public ActionResult Authorize()
        {
            var claims = new ClaimsPrincipal(User).Claims.ToArray();
            var identity = new ClaimsIdentity(claims, "Bearer");
            AuthenticationManager.SignIn(identity);
            return new EmptyResult();
        }

        //
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Login(LoginViewModel model, string returnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // This doesn't count login failures towards account lockout
            // To enable password failures to trigger account lockout, change to shouldLockout: true
            var result = await SignInManager.PasswordSignInAsync(model.Email, model.Password, model.RememberMe, shouldLockout: true);
            switch (result)
            {
                case SignInStatus.Success:
                    var user = UserManager.FindByEmail(model.Email);
                    Session["CurrentUsersName"] = user.FirstName + " " + user.LastName;
					Session["CurrentUsersOrg"] = user?.Organization.OrganizationName?? "ERROR, No Organization";
                    return RedirectToLocal(returnUrl);
                case SignInStatus.LockedOut:
                    ViewBag.DefaultAccountLockoutTimeSpan = UserManager.DefaultAccountLockoutTimeSpan.TotalMinutes;
                    return View("Lockout");
                case SignInStatus.RequiresVerification:
                    return RedirectToAction("SendCode", new { ReturnUrl = returnUrl, RememberMe = model.RememberMe });
                case SignInStatus.Failure:
                default:
                    ModelState.AddModelError("", "The email/password combination entered is not valid. Please try again.");
                    return View(model);
            }
        }

        //
        // GET: /Account/VerifyCode
        [AllowAnonymous]
        public async Task<ActionResult> VerifyCode(string provider, string returnUrl, bool rememberMe)
        {
            // Require that the user has already logged in via username/password or external login
            if (!await SignInManager.HasBeenVerifiedAsync())
            {
                return View("Error");
            }
            return View(new VerifyCodeViewModel { Provider = provider, ReturnUrl = returnUrl, RememberMe = rememberMe });
        }

        //
        // POST: /Account/VerifyCode
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> VerifyCode(VerifyCodeViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // The following code protects for brute force attacks against the two factor codes. 
            // If a user enters incorrect codes for a specified amount of time then the user account 
            // will be locked out for a specified amount of time. 
            // You can configure the account lockout settings in IdentityConfig
            var result = await SignInManager.TwoFactorSignInAsync(model.Provider, model.Code, isPersistent: model.RememberMe, rememberBrowser: model.RememberBrowser);
            switch (result)
            {
                case SignInStatus.Success:
                    return RedirectToLocal(model.ReturnUrl);
                case SignInStatus.LockedOut:
                    ViewBag.DefaultAccountLockoutTimeSpan = UserManager.DefaultAccountLockoutTimeSpan.TotalMinutes;
                    return View("Lockout");
                case SignInStatus.Failure:
                default:
                    ModelState.AddModelError("", "Invalid code.");
                    return View(model);
            }
        }

        //
        // GET: /Account/Register
        [AllowAnonymous]
        public ActionResult Register()
        {
            var model = new RegisterViewModel();
            model.Qs = new List<ChallengeQandAViewModel>() { new ChallengeQandAViewModel(), new ChallengeQandAViewModel(), new ChallengeQandAViewModel() };

            return View(model);
        }

        //
        // POST: /Account/Register
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Register(RegisterViewModel model)
        {
            if (ModelState.IsValid)
            {
                var user = new ApplicationUser
                {
                    FirstName = model.FirstName,
                    LastName = model.LastName,
                    PhoneNumber = model.PhoneNumber,
                    PhoneInternationalFlag = model.PhoneInternationalFlag,
                    UserName = model.Email,
                    Email = model.Email,
                    JobTitle = model.JobTitle,
                    O_ID = model.O_ID.GetValueOrDefault(-1),
                };
                var result = await UserManager.CreateAsync(user, model.Password);

                if (result.Succeeded)
                {
                    // Add the related Security Questions and Answers
                    DataProviderAuth.CreateUserQuestions(user, model.Qs);
                    if (!model.IsHpcdsOrganization)
                    {
                        user.O_ID = DataProviderAuth.CreateOrganization(model.NewOrganization);
                        await UserManager.UpdateAsync(user);
                    }

                    await UserManager.AddToRolesAsync(user.Id, UserRoles.PendingAccess);
                    await SignInManager.SignInAsync(user, isPersistent: false, rememberBrowser: false);
                    await SendConfrimEmail(user);

                    return RedirectToAction("Index", "Home");
                }
                AddErrors(result);
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        private async Task<bool> SendConfrimEmail(ApplicationUser user)
        {
            // For more information on how to enable account confirmation and password reset please visit https://go.microsoft.com/fwlink/?LinkID=320771
            // Send an email with this link
            string code = await UserManager.GenerateEmailConfirmationTokenAsync(user.Id);
            var callbackUrl = Url.Action("ConfirmEmail", "Account", new { userId = user.Id, code = code }, protocol: Request.Url.Scheme);
            var emailMsg = new PgrmIdentityMessage()
            {
                Destination = user.Email,
                Subject = EmailRes.EmailValidationSubjectFormat,
                Body = String.Format(EmailRes.EmailValidationBodyFormat, callbackUrl)
            };
            await UserManager.SendEmailAsync(user.Id, emailMsg.Subject, emailMsg.Body);
#if DEBUG
            TempData["DebugMessage"] = emailMsg.ToStringEmail();
#endif
            return true;
        }

        // Button/Link to request for the email confirmation to be resent
        // GET: /Account/ResendConfirmEmail (HPCDS-16)
        [Authorize]
        public async Task<ActionResult> ResendConfirmEmail()
        {
            var userId = User.Identity.GetUserId();
            var user = UserManager.FindById(userId);
            await SendConfrimEmail(user);
            return RedirectToAction("Index", "Home");
        }

        /// <summary>
        /// Email sent to oganization users (or site admins) for access (HPCDS-22)
        /// </summary>
        /// <param name="user"></param>
        /// <returns></returns>
        private async Task<bool> SendApprovedEmail(ApplicationUser user)
        {
            bool isSentToAdmins = false;
            var roleIds = DataProviderAuth.GetAppRolesFor(new List<string>(new string[] { UserRoles.PendingAccess }), false).Select(s => s.Id);
            string DestinationEmails = string.Join("; ", user.Organization
                                                                .Users
                                                                    .Where(w => w.LockoutEndDateUtc == null && w.EmailConfirmed 
                                                                             && w.Roles.Any(a => roleIds.Contains(a.RoleId)) ) // HPCDS-22 TODO: specify a better way of IDentify'n active users
                                                                    .Select(s => s.Email).ToList());
            if (String.IsNullOrWhiteSpace(DestinationEmails))
            {
                var adminUsers = DataProviderAuth.GetAdminUsers();
                DestinationEmails = string.Join("; ", adminUsers.Select(s => s.Email).ToList());
                isSentToAdmins = true;
            }

            var emailMsg = new PgrmIdentityMessage()
            {
                Destination = DestinationEmails,
                Subject = isSentToAdmins ? EmailRes.RegistrationApprovalReqForAdminSubjectFormat : EmailRes.RegistrationApprovalReqForOrgUsersSubjectFormat,
                Body = String.Format(isSentToAdmins ? EmailRes.RegistrationApprovalReqForAdminBodyFormat : EmailRes.RegistrationApprovalReqForOrgUsersBodyFormat
                                        //"email: {0} organization name: {1} urlControllerAction: {2} token: {3}"
                                        , user.Email, user?.Organization.OrganizationName ?? "ERROR-NO Organization Name", "URL-TODO: (HPCDS-25)", "TOKEN-APPROVE-USER"), 
            };
            await EService.SendAsync(emailMsg);
#if DEBUG
            TempData["DebugMessage"] = emailMsg.ToStringEmail();
#endif
            return true;
        }

        // Button/Link to request for an email to be sent so an authorized person can approve
        // GET: /Account/ResendApprovalRequestEmail (HPCDS-22)
        [Authorize]
        public async Task<ActionResult> ResendApprovalRequestEmail()
        {
            var userId = User.Identity.GetUserId();
            var user = UserManager.FindById(userId);
            await SendApprovedEmail(user);
            return RedirectToAction("Index", "Home");
        }

        //
        // GET: /Account/ConfirmEmail
        [AllowAnonymous]
        public async Task<ActionResult> ConfirmEmail(string userId, string code)
        {
            if (userId == null || code == null)
            {
                return View("Error");
            }
            var result = await UserManager.ConfirmEmailAsync(userId, code);
            return View(result.Succeeded ? "ConfirmEmail" : "Error");
        }

        //
        // GET: /Account/ForgotPassword
        [AllowAnonymous]
        public ActionResult ForgotPassword()
        {
            return View();
        }

        //
        // POST: /Account/ForgotPassword
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ForgotPassword(ForgotPasswordViewModel model)
        {
            if (ModelState.IsValid)
            {
                var user = await UserManager.FindByNameAsync(model.Email);
                var emailMsg = new PgrmIdentityMessage
                {
                    Destination = user?.Email ?? model.Email
                };

                if (user == null)
                {
                    // Don't reveal that the user does not exist or is not confirmed
                    EmailSetupForNotRegisterdUser(emailMsg);
                    await EService.SendAsync(emailMsg);
                }
                else if (!(await UserManager.IsEmailConfirmedAsync(user.Id)))
                {
                    string code = await UserManager.GenerateEmailConfirmationTokenAsync(user.Id);
                    EmailSetupForNotVerifiedUser(emailMsg, user.Id, code);
                    await UserManager.SendEmailAsync(user.Id, emailMsg.Subject, emailMsg.Body);
                }
                else
                {
                    //For more information on how to enable account confirmation and password reset please visit https://go.microsoft.com/fwlink/?LinkID=320771
                    // Send an email with this link 
                    string code = await UserManager.GenerateUserTokenAsync("CanAnswerSecQuestions", user.Id);
                    EmailSetupForRegisterdUser(emailMsg, code, "VerifyUser");
                    await UserManager.SendEmailAsync(user.Id, emailMsg.Subject, emailMsg.Body);
                }
#if DEBUG
                TempData["DebugMessage"] = emailMsg.ToStringEmail();
#endif
                return RedirectToAction("ForgotPasswordConfirmation", "Account");
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // GET: /Account/ForgotPasswordConfirmation
        [AllowAnonymous]
        public ActionResult ForgotPasswordConfirmation()
        {
#if DEBUG
            ViewBag.DebugMessage = (TempData["DebugMessage"] ?? string.Empty).ToString();
            TempData["DebugMessage"] = null;
#endif
            return View();
        }

        //
        // GET: /Account/ResetPassword
        [AllowAnonymous]
        public ActionResult ResetPassword(string code, string email)
        {
            return code == null ? View("Error") : View();
        }

        //
        // POST: /Account/ResetPassword
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ResetPassword(ResetPasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }
            var user = await UserManager.FindByNameAsync(model.Email);
            if (user == null)
            {
                // Don't reveal that the user does not exist
                return RedirectToAction("ResetPasswordConfirmation", "Account");
            }
            if (UserManager.PasswordHasher.VerifyHashedPassword(user.PasswordHash, model.Password).Equals(SignInStatus.Success))
            {
                ModelState.AddModelError("", "The password you selected matches your most recent password. Please use a different password.");
                return View();
            }
            var result = await UserManager.ResetPasswordAsync(user.Id, model.Code, model.Password);
            if (result.Succeeded)
            {
                return RedirectToAction("ResetPasswordConfirmation", "Account");
            }
            AddErrors(result);
            return View();
        }

        //
        // GET: /Account/VerifyUser
        [HttpGet]
        [AllowAnonymous]
        public async Task<ActionResult> VerifyUser(string userId, string code)
        {

            var user = await UserManager.FindByEmailAsync(userId);
            if (user != null && UserManager.IsLockedOut(user.Id))
            {
                ViewBag.DefaultAccountLockoutTimeSpan = UserManager.DefaultAccountLockoutTimeSpan.TotalMinutes;
                return View("Lockout");
            }
            else if (user != null && UserManager.VerifyUserToken(user.Id, "CanAnswerSecQuestions", code))
            {
                var questionVM = new ChallengeQandAViewModel();
                var r = new Random();
                var num = r.Next(user.UserQuestions.Count);
                var userQandA = user.UserQuestions.ToList()[num];
                questionVM.Question = userQandA.SecurityQuestion.Questions;
                questionVM.Q_ID = userQandA.SecurityQuestion.ID;
                questionVM.Code = code;
                questionVM.UserId = userId;
                return View(questionVM);
            }
            return View("InvalidToken");
        }

        //
        // POST: /Account/VerifyUser
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> VerifyUser(ChallengeQandAViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var user = await UserManager.FindByEmailAsync(model.UserId);
            var qId = user.UserQuestions.Where(m => m.Q_ID.Equals(model.Q_ID)).FirstOrDefault();

            if (model.Answer.Equals(qId.Answer,StringComparison.OrdinalIgnoreCase))
            {
                model.Code = await UserManager.GeneratePasswordResetTokenAsync(user.Id);
                return RedirectToAction("ResetPassword", "Account", new { code = model.Code, email = model.UserId });
            }
            else
            {
                user.SecQandAFailCount += 1;
                await UserManager.UpdateAsync(user);
                if (user.SecQandAFailCount >= UserManager.MaxFailedAccessAttemptsBeforeLockout)
                {
                    UserManager.SetLockoutEndDate(user.Id, DateTimeOffset.UtcNow.Add(UserManager.DefaultAccountLockoutTimeSpan));
                    user.SecQandAFailCount = 0;
                    await UserManager.UpdateAsync(user);
                    ViewBag.DefaultAccountLockoutTimeSpan = UserManager.DefaultAccountLockoutTimeSpan.TotalMinutes;
                    return View("Lockout");
                }
                return RedirectToAction("VerifyUser", new { userId = model.UserId, code = model.Code });
            }
        }

        //
        // GET: /Account/ResetPasswordConfirmation
        [AllowAnonymous]
        public ActionResult ResetPasswordConfirmation()
        {
            return View();
        }

        //
        // POST: /Account/ExternalLogin
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ExternalLogin(string provider, string returnUrl)
        {
            // Request a redirect to the external login provider
            return new ChallengeResult(provider, Url.Action("ExternalLoginCallback", "Account", new { ReturnUrl = returnUrl }));
        }

        //
        // GET: /Account/SendCode
        [AllowAnonymous]
        public async Task<ActionResult> SendCode(string returnUrl, bool rememberMe)
        {
            var userId = await SignInManager.GetVerifiedUserIdAsync();
            if (userId == null)
            {
                return View("Error");
            }
            var userFactors = await UserManager.GetValidTwoFactorProvidersAsync(userId);
            var factorOptions = userFactors.Select(purpose => new SelectListItem { Text = purpose, Value = purpose }).ToList();
            return View(new SendCodeViewModel { Providers = factorOptions, ReturnUrl = returnUrl, RememberMe = rememberMe });
        }

        //
        // POST: /Account/SendCode
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> SendCode(SendCodeViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View();
            }

            // Generate the token and send it
            if (!await SignInManager.SendTwoFactorCodeAsync(model.SelectedProvider))
            {
                return View("Error");
            }
            return RedirectToAction("VerifyCode", new { Provider = model.SelectedProvider, ReturnUrl = model.ReturnUrl, RememberMe = model.RememberMe });
        }

        //
        // GET: /Account/ExternalLoginCallback
        [AllowAnonymous]
        public async Task<ActionResult> ExternalLoginCallback(string returnUrl)
        {
            var loginInfo = await AuthenticationManager.GetExternalLoginInfoAsync();
            if (loginInfo == null)
            {
                return RedirectToAction("Login");
            }

            // Sign in the user with this external login provider if the user already has a login
            var result = await SignInManager.ExternalSignInAsync(loginInfo, isPersistent: false);
            switch (result)
            {
                case SignInStatus.Success:
                    return RedirectToLocal(returnUrl);
                case SignInStatus.LockedOut:
                    return View("Lockout");
                case SignInStatus.RequiresVerification:
                    return RedirectToAction("SendCode", new { ReturnUrl = returnUrl, RememberMe = false });
                case SignInStatus.Failure:
                default:
                    // If the user does not have an account, then prompt the user to create an account
                    ViewBag.ReturnUrl = returnUrl;
                    ViewBag.LoginProvider = loginInfo.Login.LoginProvider;
                    return View("ExternalLoginConfirmation", new ExternalLoginConfirmationViewModel { Email = loginInfo.Email });
            }
        }

        //
        // POST: /Account/ExternalLoginConfirmation
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ExternalLoginConfirmation(ExternalLoginConfirmationViewModel model, string returnUrl)
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Manage");
            }

            if (ModelState.IsValid)
            {
                // Get the information about the user from the external login provider
                var info = await AuthenticationManager.GetExternalLoginInfoAsync();
                if (info == null)
                {
                    return View("ExternalLoginFailure");
                }
                var user = new ApplicationUser { UserName = model.Email, Email = model.Email, Hometown = model.Hometown };
                var result = await UserManager.CreateAsync(user);
                if (result.Succeeded)
                {
                    result = await UserManager.AddLoginAsync(user.Id, info.Login);
                    if (result.Succeeded)
                    {
                        await SignInManager.SignInAsync(user, isPersistent: false, rememberBrowser: false);
                        return RedirectToLocal(returnUrl);
                    }
                }
                AddErrors(result);
            }

            ViewBag.ReturnUrl = returnUrl;
            return View(model);
        }

        //
        // POST: /Account/LogOff
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            Session["CurrentUsersName"] = Session["CurrentUsersOrg"] = null;
            return RedirectToAction("Index", "Home");
        }

        // 
        // GET: /Account/Register
        [Authorize(Roles = UserRoles.AdminGroup)]
        public ActionResult SendResetLink()
        {
            var model = new SendResetLinkViewModel { Users = AllUsersList() };
            return View(model);
        }        

        // 
        // GET: /Account/Register
        [HttpPost]
        [Authorize(Roles = UserRoles.AdminGroup)]
        public async Task<ActionResult> SendResetLink(SendResetLinkViewModel model)
        {
            var user = UserManager.FindById(model.SelectedUserId);
            string code = await UserManager.GeneratePasswordResetTokenAsync(user.Id);
            var emailObj = new PgrmIdentityMessage { Destination = user.Email };
            EmailSetupForRegisterdUser(emailObj, code, "ResetPasswordByAdmin");
#if DEBUG
            ViewBag.DebugMessage = emailObj.ToStringEmail();
#endif
            await UserManager.SendEmailAsync(user.Id, emailObj.Subject, emailObj.Body);
            model.Users = AllUsersList();
            model.IsSend = true;
            return View(model);
        }

        //
        // GET: /Account/ResetPasswordByAdmin (HPCDS-35)
        [AllowAnonymous]
        public async Task<ActionResult> ResetPasswordByAdmin(string userId, string code)
        {
            var user = await UserManager.FindByEmailAsync(userId);
            var isValidToken = UserManager.VerifyUserToken(user.Id, "ResetPassword", code);

            if (string.IsNullOrEmpty(code) || user == null || !isValidToken)
                return View("InvalidToken");
            else if (isValidToken)
            {
                var model = new ResetPasswordByAdminViewModel
                {
                    Email = userId,
                    Code = code,
                    Questions = new List<ChallengeQandAViewModel>() { new ChallengeQandAViewModel(), new ChallengeQandAViewModel(), new ChallengeQandAViewModel() }
                };
                return View(model);
            }

            return View("Error");
        }

        //
        // POST: /Account/Register (HPCDS-35)
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ResetPasswordByAdmin(ResetPasswordByAdminViewModel model)
        {
            if (ModelState.IsValid)
            {
                var user = await UserManager.FindByEmailAsync(model.Email);
                var result = await UserManager.ResetPasswordAsync(user.Id, model.Code, model.Password);
                
                if (result.Succeeded)
                {
                    // Del/Add the related Security Questions and Answers
                    DataProviderAuth.CreateUserQuestions(user, model.Questions);
                    // Auto SignIn
                    await SignInManager.SignInAsync(user, isPersistent: false, rememberBrowser: false);

                    return RedirectToAction("Index", "Home");
                }
                AddErrors(result);
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // GET: /Account/ExternalLoginFailure
        [AllowAnonymous]
        public ActionResult ExternalLoginFailure()
        {
            return View();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_userManager != null)
                {
                    _userManager.Dispose();
                    _userManager = null;
                }

                if (_signInManager != null)
                {
                    _signInManager.Dispose();
                    _signInManager = null;
                }
            }

            base.Dispose(disposing);
        }

        #region Helpers
        // Used for XSRF protection when adding external logins
        private const string XsrfKey = "XsrfId";

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Home");
        }

        internal class ChallengeResult : HttpUnauthorizedResult
        {
            public ChallengeResult(string provider, string redirectUri)
                : this(provider, redirectUri, null)
            {
            }

            public ChallengeResult(string provider, string redirectUri, string userId)
            {
                LoginProvider = provider;
                RedirectUri = redirectUri;
                UserId = userId;
            }

            public string LoginProvider { get; set; }
            public string RedirectUri { get; set; }
            public string UserId { get; set; }

            public override void ExecuteResult(ControllerContext context)
            {
                var properties = new AuthenticationProperties { RedirectUri = RedirectUri };
                if (UserId != null)
                {
                    properties.Dictionary[XsrfKey] = UserId;
                }
                context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
            }
        }

        private void EmailSetupForNotRegisterdUser(PgrmIdentityMessage message)
        {
            var callbackUrl = Url.Action("Register", "Account", null, protocol: Request.Url.Scheme);
            message.Subject = EmailRes.ResetPWD_NotRegisterdUserSubjectFormat;
            message.Body = String.Format(EmailRes.ResetPWD_NotRegisterdUserBodyFormat, callbackUrl);
        }

        private void EmailSetupForRegisterdUser(PgrmIdentityMessage message, string code, string action)
        {
            var callbackUrl = Url.Action(action, "Account", new { userId = message.Destination, code }, protocol: Request.Url.Scheme);
            message.Subject = EmailRes.ResetPWD_RegisterdUserSubjectFormat;
            message.Body = String.Format(EmailRes.ResetPWD_RegisterdUserBodyFormat, callbackUrl);
        }

        private void EmailSetupForNotVerifiedUser(PgrmIdentityMessage message, string userID, string code)
        {
            var callbackUrl = Url.Action("ConfirmEmail", "Account", new { userId = userID, code }, protocol: Request.Url.Scheme);
            message.Subject = EmailRes.ResetPWD_NotVerifiedUserSubjectFormat;
            message.Body = String.Format(EmailRes.ResetPWD_NotVerifiedUserBodyFormat, callbackUrl, Url.Action("Index", "Home", null, protocol: Request.Url.Scheme), Url.Action("ForgotPassword", "Account", null, protocol: Request.Url.Scheme));
        }

        private List<SelectListItem> AllUsersList()
        {
            var userList = new List<SelectListItem>();
            foreach (var usr in UserManager.Users)
            {
                userList.Add(new SelectListItem
                {
                    Value = usr.Id,
                    Text = String.Format("{0} {1} ({2})", usr.FirstName, usr.LastName, usr.Email)
                });
            }
            return userList;
        }

        #endregion
    }
}
