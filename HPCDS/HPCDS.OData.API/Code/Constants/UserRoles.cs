using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HPCDS.OData.API.Code.Constants
{
    /// <summary>
    /// A static class to represent the list of User roles
    /// </summary>
    public static class UserRoles 
    {
        /// <summary>
        /// Role : App admin
        /// </summary>
        public const string AppAdmin = "AppAdmin";
        /// <summary>
        /// Role : Reporters
        /// </summary>
        public const string Reporters = "Reporters";
        /// <summary>
        /// Role : Site admin
        /// </summary>
        public const string SiteAdmin = "SiteAdmin";
        /// <summary>
        /// Role : State admin
        /// </summary>
        public const string StateAdmin = "StateAdmin";
        /// <summary>
        /// Role : Pending access
        /// </summary>
        public const string PendingAccess = "PendingAccess";

        /// Role Groups
        public const string AdminGroup              = AppAdmin + "," + SiteAdmin ;
        public const string SiteStateAdminGroup     = AppAdmin + "," + SiteAdmin + "," + StateAdmin;
        public const string HpcdsUserGroup          = AppAdmin + "," + SiteAdmin + "," + StateAdmin + "," + Reporters;

    }
}