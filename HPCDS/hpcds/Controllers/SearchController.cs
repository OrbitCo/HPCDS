using hpcds.Models;
using System;
using System.Web.Mvc;

namespace hpcds.Controllers
{
    public class SearchController : Controller
    {
        public ActionResult Index()
        {
            return View(new SearchViewModel());
        }

        public ActionResult Products()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult SaveExport(string contentType, string base64, string fileName)
        {
            var fileContents = Convert.FromBase64String(base64);

            return File(fileContents, contentType, fileName);
        }

    }
}
