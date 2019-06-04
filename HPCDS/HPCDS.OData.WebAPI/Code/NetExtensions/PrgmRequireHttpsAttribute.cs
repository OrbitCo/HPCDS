using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace HPCDS.OData.WebAPI.Code.NetExtensions
{
    // TODO: swith to AuthorizationFilterAttribute > OnAuthorization, as it calls before ActionFilterAttribute
    public class PrgmRequireHttpsAttributeAttribute : ActionFilterAttribute
    {
        /// <summary>
        /// Note: with HSTS enabled a user should never see the following error message; since modern browsers will auto redirect to https
        /// </summary>
        /// <param name="actionContext"></param>
        public override void OnActionExecuting(HttpActionContext actionContext)
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

            // HPCDS-40 (temp) - TODO: use actual Authorization method and RESTier Can<Table><Insert|...> methods
            List<string> blockTbl = new List<string>() { "report", "docu", "relationship", "cspa", "account", "setting" };
            foreach (var blk in blockTbl)
            {
                if (request.RequestUri.AbsoluteUri.ToLower().Contains(blk) && !request.RequestUri.AbsoluteUri.ToLower().Contains("vsearch") )
                {
                    actionContext.Response = request.CreateErrorResponse(HttpStatusCode.Forbidden,
                        String.Format("Authorization, required for this resource at {0}.", request.RequestUri));
                }
            }
            if (request.Method.Method != "GET")
                actionContext.Response = request.CreateErrorResponse(HttpStatusCode.Forbidden,
                    String.Format("Read-only, allowed at this time, use GET for this resource at {0}.", request.RequestUri));
        }
    }
}