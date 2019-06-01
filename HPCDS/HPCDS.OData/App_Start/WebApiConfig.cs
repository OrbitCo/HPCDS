using HPCDS.OData.Code.NetExtensions;
using HPCDS.OData.Models;
using Microsoft.AspNet.OData;
using Microsoft.AspNet.OData.Extensions;
using Microsoft.Restier.AspNet.Batch;
using Microsoft.Restier.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace HPCDS.OData
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

            config.Filters.Add(new PrgmRequireHttpsAttributeAttribute());

            // enable query options for all properties
            config.Filter().Expand().Select().OrderBy().MaxTop(null).Count();

            // enable ETAGs
            config.MessageHandlers.Add(new ETagMessageHandler());

            // Web API routes
            await config.MapRestierRoute<EntityFrameworkApi<hpcdsDbContext>>(
                "MyODataRoutes",
                "hpcds",
                new RestierBatchHandler(GlobalConfiguration.DefaultServer));
        }
    }
}
