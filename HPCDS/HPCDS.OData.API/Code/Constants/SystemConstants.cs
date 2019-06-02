using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace HPCDS.OData.API.Code.Constants
{
    public class SystemConstants
    {
        public static string odataUrl { get { return WebConfigurationManager.AppSettings["odataService"]; } }
    }
}