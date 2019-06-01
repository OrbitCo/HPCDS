using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Caching;
using System.Web.Hosting;
using System.Web.Optimization;

namespace hpcds
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            // TODO: (PHAST-2) temporary patch to disable bundeling for web.release.config 
            BundleTable.EnableOptimizations = false;

            // ----------------- Script Bundles ----------------------------------------------------------
            bundles.Add(new ScriptBundle("~/bundles/jquery").WithLastModifiedQryString().Include(
                "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").WithLastModifiedQryString().Include(
                "~/Scripts/jquery.unobtrusive*",
                "~/Scripts/jquery.validate*"));

            bundles.Add(new ScriptBundle("~/bundles/kendo").WithLastModifiedQryString().Include(
                "~/Scripts/kendo/2019.2.514/jszip.min.js",
                "~/Scripts/kendo/2019.2.514/kendo.all.min.js",
                // uncomment below if using the Scheduler
                // "~/Scripts/kendo/2019.2.514/kendo.timezones.min.js",
                "~/Scripts/kendo/2019.2.514/kendo.aspnetmvc.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/knockout").WithLastModifiedQryString().Include(
                "~/Scripts/knockout-{version}.js",
                "~/Scripts/knockout.validation.js"));

            bundles.Add(new ScriptBundle("~/bundles/common").WithLastModifiedQryString().Include(
                "~/Scripts/app/common.js",
                "~/Scripts/app/common.funcs.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/app").WithLastModifiedQryString().Include(
                "~/Scripts/sammy-{version}.js",
                "~/Scripts/app/app.datamodel.js",
                "~/Scripts/app/app.viewmodel.js",
                "~/Scripts/app/home.viewmodel.js",
                "~/Scripts/app/_run.js"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at https://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").WithLastModifiedQryString().Include(
                "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").WithLastModifiedQryString().Include(
                "~/Scripts/popperJs/umd/popper.js",
                "~/Scripts/bootstrap.js"));


            bundles.Add(new ScriptBundle("~/bundles/app/account").WithLastModifiedQryString().Include(
                "~/Scripts/app/Account/register.funcs.js"));

            bundles.Add(new ScriptBundle("~/bundles/app/search").WithLastModifiedQryString().Include(
               "~/Scripts/app/Search/search.funcs.js"));

            // ----------------- Style Bundles ----------------------------------------------------------

            bundles.Add(new StyleBundle("~/Content/site").WithLastModifiedQryString().Include("~/Content/Site.css"));

            bundles.Add(new StyleBundle("~/Content/bootstrap").WithLastModifiedQryString().Include(
                 "~/Content/bootstrap.css",
                 "~/Content/bootstrap-themer-app/bootstrap.noric.all.min.css",
                 "~/Content/override-bootstrap.css"));

            bundles.Add(new StyleBundle("~/Content/kendo").WithLastModifiedQryString().Include(
                //"~/Content/kendo/2019.2.514/kendo.common-nova.min.css",  // use common/nova files for LESS-based Themes
                "~/Content/kendo/2019.2.514/kendo.mobile.all.min.css",
                //"~/Content/kendo/2019.2.514/kendo.nova.min.css",
                "~/Content/kendo/kendo.noric.all.min.css",            // for the SASS-based Themes, don't include common css files as it includes everything
                "~/Content/kendo/override-kendo.css")); 

        }
    }

    internal static class BundleExtensions
    { 
        public static Bundle WithLastModifiedQryString(this Bundle sb)
        {
            sb.Transforms.Add(new FileLastModifiedDateVersionBundleTransform());
            return sb;
        }
    }
    /// <summary>
    /// File Last Modified Data Version Bundle Transfer. 
    /// </summary>
    public class FileLastModifiedDateVersionBundleTransform : IBundleTransform
    {
        /// <summary>
        /// Gets the Relative with Last Modified date as its version
        /// </summary>
        /// <param name="rootRelativePath"></param>
        /// <returns></returns>
        private static string ToCacheBustedPathWithLastModifiedTimeTicksAsVersion(string rootRelativePath)
        {
            if (HttpRuntime.Cache[rootRelativePath] == null)
            {
                string absolutePath = HostingEnvironment.MapPath(rootRelativePath);
                var AppVersion = typeof(hpcds.MvcApplication).Assembly.GetName().Version;
                DateTime lastChangedDateTime = File.GetLastWriteTime(absolutePath);
                DateTime lastPublishedOn = Convert.ToDateTime(ConfigurationManager.AppSettings["ContentLastPublishedOn"]);
                int tDaysSinceLastPublished = new TimeSpan(lastChangedDateTime.Ticks - lastPublishedOn.Ticks).Days;
#if !DEBUG
                tDaysSinceLastPublished = 0;
#endif
                // Force the clearing of browser cache by having a query string that includes the app version M.m.build+daysSinceLastPublish of css/js files
                string versionedUrl = String.Format(@"{0}?v={1}.{2}.{3}-{5}d", rootRelativePath, AppVersion.Major, AppVersion.Minor, AppVersion.Build, AppVersion.Revision, tDaysSinceLastPublished);
                HttpRuntime.Cache.Insert(rootRelativePath, versionedUrl, new CacheDependency(absolutePath));
            }
            string returnString = HttpRuntime.Cache[rootRelativePath] as string;
            return returnString;
        }

        /// <summary>
        /// Process method for IBundleTransform
        /// </summary>
        /// <param name="context"></param>
        /// <param name="response"></param>
        public void Process(BundleContext context, BundleResponse response)
        {
            foreach (BundleFile file in response.Files)
            {
                string version = ToCacheBustedPathWithLastModifiedTimeTicksAsVersion(file.IncludedVirtualPath);
                file.IncludedVirtualPath = version;
            }
        }
    }
}

