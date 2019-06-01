using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace hpcds.Code.NetExtensions
{
    public class PrgmRequireHttpsAttributeAttribute : AuthorizationFilterAttribute
    {
        /// <summary>
        /// Note: with HSTS enabled a user should never see the following error message; since modern browsers will auto redirect to https
        /// </summary>
        /// <param name="actionContext"></param>
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            var request = actionContext.Request;
            if (request.RequestUri.Scheme != Uri.UriSchemeHttps)
            {
                UriBuilder uri = new UriBuilder(request.RequestUri);
                uri.Scheme = Uri.UriSchemeHttps;
                uri.Port = 443;

                actionContext.Response = request.CreateErrorResponse(HttpStatusCode.Forbidden,
                    String.Format("HTTPS Required, the resource can be found at {0}.", uri.Uri.AbsoluteUri));

            }
        }
    }
}