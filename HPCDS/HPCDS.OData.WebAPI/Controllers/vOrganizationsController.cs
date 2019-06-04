﻿using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.ModelBinding;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.OAuth;
using HPCDS.OData.WebAPI.Models;
using HPCDS.OData.WebAPI.Providers;
using HPCDS.OData.WebAPI.Results;
using System.Linq;
using Newtonsoft.Json;

namespace HPCDS.OData.WebAPI.Controllers
{
    [Authorize]
    public class vOrganizationsController : ApiController
    {
        public IHttpActionResult Get()
        {
            using (var context = new hpcdsDbContext())
            {
                IQueryable<vOrganization> list = from data in context.vOrganizations select data;
                List<vOrganization> values = list.ToList();
                return Ok(JsonConvert.SerializeObject(values));
            }
        }
    }
}
