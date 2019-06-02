using HPCDS.OData.API.Code.NetExtensions;
using HPCDS.OData.API.Models;
using Microsoft.AspNet.OData;
using Microsoft.AspNet.OData.Extensions;
using Microsoft.Owin.Security.OAuth;
using Microsoft.Restier.AspNet.Batch;
using Microsoft.Restier.EntityFramework;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace HPCDS.OData.API
{
    public static class WebApiConfig
    {
        public async static void RegisterAsync(HttpConfiguration config)
        {
            // Web API configuration and services

            //// Web API routes
            //config.MapHttpAttributeRoutes();

            //config.Routes.MapHttpRoute(
            //    name: "DefaultApi",
            //    routeTemplate: "api/{controller}/{id}",
            //    defaults: new { id = RouteParameter.Optional }
            //);

            config.SuppressDefaultHostAuthentication();
            config.Filters.Add(new HostAuthenticationFilter(OAuthDefaults.AuthenticationType));

            config.Filters.Add(new PrgmRequireHttpsAttributeAttribute());

            // enable query options for all properties
            config.Filter().Expand().Select().OrderBy().MaxTop(null).Count();

            // enable ETAGs
            config.MessageHandlers.Add(new ETagMessageHandler());

            // Use camel case for JSON data.
            config.Formatters.JsonFormatter.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();

            // Web API routes
            config.MapHttpAttributeRoutes();

            // Web API routes
            await config.MapRestierRoute<EntityFrameworkApi<hpcdsDbContext>>(
                "MyODataRoutes",
                "hpcds",
                new RestierBatchHandler(GlobalConfiguration.DefaultServer));
        }
    }
}
