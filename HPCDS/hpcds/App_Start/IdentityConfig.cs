using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using Microsoft.Owin.Security;
using hpcds.Models;
using SendGrid;
using System.Net;
using System.Configuration;
using System.Diagnostics;
using Exceptions;
using System.Text;

namespace hpcds
{
    public class EmailService : IIdentityMessageService
    {
        public async Task SendAsync(IdentityMessage message)
        {
            await configSendGridasync(message);
            // Plug in your email service here to send an email.
            // return Task.FromResult(0);
        }

        // Use NuGet to install SendGrid (Basic C# client lib) 
        private async Task configSendGridasync(IdentityMessage message)
        {
            var myMessage = new SendGridMessage();

            myMessage.AddTo(message.Destination);
            myMessage.From = new System.Net.Mail.MailAddress(
                ConfigurationManager.AppSettings["mailFromEmail"],
                ConfigurationManager.AppSettings["mailFromName"]
                );
            myMessage.Subject = message.Subject;
            myMessage.Text = message.Body;
            myMessage.Html = message.Body;

            var credentials = new NetworkCredential(
                       ConfigurationManager.AppSettings["mailAccount"],
                       ConfigurationManager.AppSettings["mailPassword"]
                       );

            // Create a Web transport for sending email.
            var transportWeb = new Web(credentials);

            // Send the email.
            if (transportWeb != null)
            {
                try
                {
                    await transportWeb.DeliverAsync(myMessage);
                }
                catch (InvalidApiRequestException ex)
                {
                    var detalle = new StringBuilder();

                    detalle.Append("ResponseStatusCode: " + ex.ResponseStatusCode + ".   ");
                    for (int i = 0; i < ex.Errors.Count(); i++)
                    {
                        detalle.Append(" -- Error #" + i.ToString() + " : " + ex.Errors[i]);
                    }

                    throw new ApplicationException(detalle.ToString(), ex);
                }
                
            }
            else
            {
                Trace.TraceError("Failed to create Web transport.");
                await Task.FromResult(0);
            }
        }
    }

    public class SmsService : IIdentityMessageService
    {
        public Task SendAsync(IdentityMessage message)
        {
            // Plug in your SMS service here to send a text message.
            return Task.FromResult(0);
        }
    }

    // Configure the application user manager which is used in this application.
    public class ApplicationUserManager : UserManager<ApplicationUser>
    {
        public ApplicationUserManager(IUserStore<ApplicationUser> store)
            : base(store)
        {
        }
        public static ApplicationUserManager Create(IdentityFactoryOptions<ApplicationUserManager> options,
            IOwinContext context)
        {
            var manager = new ApplicationUserManager(new UserStore<ApplicationUser>(context.Get<ApplicationDbContext>()));
            // Configure validation logic for usernames
            manager.UserValidator = new UserValidator<ApplicationUser>(manager)
            {
                AllowOnlyAlphanumericUserNames = false,
                RequireUniqueEmail = true
            };

            // Configure validation logic for passwords
            manager.PasswordValidator = new PasswordValidator
            {
                RequiredLength = 6,
                RequireNonLetterOrDigit = true,
                RequireDigit = true,
                RequireLowercase = true,
                RequireUppercase = true,
            };

            // Configure user lockout defaults
            manager.UserLockoutEnabledByDefault = true;
            manager.DefaultAccountLockoutTimeSpan = TimeSpan.FromMinutes(20);
            manager.MaxFailedAccessAttemptsBeforeLockout = 5;

            // Register two factor authentication providers. This application uses Phone and Emails as a step of receiving a code for verifying the user
            // You can write your own provider and plug it in here.
            manager.RegisterTwoFactorProvider("Phone Code", new PhoneNumberTokenProvider<ApplicationUser>
            {
                MessageFormat = "Your security code is {0}"
            });
            manager.RegisterTwoFactorProvider("Email Code", new EmailTokenProvider<ApplicationUser>
            {
                Subject = "Security Code",
                BodyFormat = "Your security code is {0}"
            });
            manager.EmailService = new EmailService();
            manager.SmsService = new SmsService();
            var dataProtectionProvider = options.DataProtectionProvider;
            if (dataProtectionProvider != null)
            {
                manager.UserTokenProvider =
                    new DataProtectorTokenProvider<ApplicationUser>(dataProtectionProvider.Create("ASP.NET Identity"))
                    {
                        //Code for email confirmation and reset password life time
                        TokenLifespan = TimeSpan.FromHours(6)
                    };
            }
            return manager;
        }
    }

    // Configure the application sign-in manager which is used in this application.  
    public class ApplicationSignInManager : SignInManager<ApplicationUser, string>
    {
        public ApplicationSignInManager(ApplicationUserManager userManager, IAuthenticationManager authenticationManager) :
            base(userManager, authenticationManager)
        { }

        public override Task<ClaimsIdentity> CreateUserIdentityAsync(ApplicationUser user)
        {
            return user.GenerateUserIdentityAsync((ApplicationUserManager)UserManager);
        }

        public static ApplicationSignInManager Create(IdentityFactoryOptions<ApplicationSignInManager> options, IOwinContext context)
        {
            return new ApplicationSignInManager(context.GetUserManager<ApplicationUserManager>(), context.Authentication);
        }
    }
}
