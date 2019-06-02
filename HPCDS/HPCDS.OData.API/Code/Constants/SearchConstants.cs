using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HPCDS.OData.API.Code.Constants
{
    public class SearchConstants
    {
        public enum StatePrograms
        {
            OR,
            VT,
            WA
        }

        public enum SearchType
        {
            All,
            Chemical,
            Company,
            Product
        }

        public enum ReportingPeriod
        {
            LastTwoYears,
            All,
            CustomRange
        }
    }
}