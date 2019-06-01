using System;
using System.Linq;
using System.Threading.Tasks;
using hpcds.Models;
using Microsoft.Owin.Security.OAuth;

namespace hpcds.Providers
{
    public class ApplicationOAuthProvider : OAuthAuthorizationServerProvider
    {
        private readonly string _publicClientId;

        public ApplicationOAuthProvider(string publicClientId)
        {
            if (publicClientId == null)
            {
                throw new ArgumentNullException("publicClientId");
            }

            _publicClientId = publicClientId;
        }

        public override Task ValidateClientRedirectUri(OAuthValidateClientRedirectUriContext context)
        {
            if (context.ClientId == _publicClientId)
            {
                Uri expectedRootUri = new Uri(context.Request.Uri, "/");
                var audiences = DataProviderAuth.GetApiAudience(context.ClientId);

                if (expectedRootUri.AbsoluteUri == context.RedirectUri)
                {
                    context.Validated();
                }
                else if (context.ClientId == "web" )
                {
                    var expectedUri = new Uri(context.Request.Uri, context.Request.PathBase.ToUriComponent() + "/");
                    context.Validated(expectedUri.AbsoluteUri);
                }
                else if (audiences.Any())
                {
                    // Validated if request is from the expected domain
                    if (context.Request.Uri.ToString().ToLower().Contains(audiences.First().Domain.ToLower()))
                    {
                        context.Validated();
                    }
                }
            }

            return Task.FromResult<object>(null);
        }
    }
}