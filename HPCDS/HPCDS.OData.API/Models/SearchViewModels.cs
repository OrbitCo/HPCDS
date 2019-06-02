using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using HPCDS.OData.API.Code.Constants;
namespace HPCDS.OData.API.Models
{
    public class SearchViewModel
    {
        [Display(Name ="State(s)")]
        public List<SearchConstants.StatePrograms> States { get; set; } = new List<SearchConstants.StatePrograms>() { SearchConstants.StatePrograms.OR, SearchConstants.StatePrograms.VT, SearchConstants.StatePrograms.WA };

        [Display(Name = "Type")]
        public SearchConstants.SearchType Type { get; set; } = SearchConstants.SearchType.All;

        [UIHint("msChemicals")]
        [Display(Name = "Chemical(s)")]
        public string SelectedChemical { get; set; }

        [UIHint("cbChemicalFunctions")]
        [Display(Name = "Function")]
        public int? SelectedFunction { get; set; }

        [Display(Name = "Company")]
        public string OrganizationName { get; set; }

        [UIHint("msProductBricks")]
        [Display(Name = "Product Brick(s)")]
        public string SelectedBricks { get; set; }

        [UIHint("cbComponent")]
        [Display(Name = "Component")]
        public int? SelectedComponent { get; set; }

        [Display(Name = "Date Range")]
        public SearchConstants.ReportingPeriod Period { get; set; } = SearchConstants.ReportingPeriod.LastTwoYears;

        [Display(Name = "Start")]
        public DateTime StartDate { get; set; } = DateTime.Now.AddYears(-2);

        [Display(Name = "End")]
        public DateTime EndDate { get; set; } = DateTime.Now;
    }

    //  Should match OData Model for DB-View vSearchReport
    public class SearchReportResultsViewModel
    {
        [Display(Name = "Company")]
        public string OrganizationName { get; set; }
        [Display(Name = "DUNS number")]
        public string DUNSNumber { get; set; }

        [Display(Name = "AddressLine1")]
        public string AddressLine1 { get; set; }
        [Display(Name = "AddressLine2")]
        public string AddressLine2 { get; set; }
        [Display(Name = "City")]
        public string City { get; set; }
        [Display(Name = "State province")]
        public string StateProv { get; set; }
        [Display(Name = "Postal code number")]
        public string PostalCodeNumber { get; set; }
        [Display(Name = "Country code")]
        public string CountryCd { get; set; }
        
        [Display(Name = "Email")]
        public string Email { get; set; }
        [Display(Name = "Phone number")]
        public string PhoneNumber { get; set; }
        [Display(Name = "First name")]
        public string FirstName { get; set; }
        [Display(Name = "Last name")]
        public string LastName { get; set; }
        [Display(Name = "Job title")]
        public string JobTitle { get; set; }

        [Display(Name = "Product class")]
        public string ProductClassDescription { get; set; }
        [Display(Name = "Product family")]
        public string ProductFamilyDescription { get; set; }
        [Display(Name = "Product segment")]
        public string ProductSegmentDescription { get; set; }
        [Display(Name = "Product brick")]
        public string ProductBrickDescription { get; set; }
        [Display(Name = "Inaccessible component")]
        public string InaccessibleComponent { get; set; }

        [Display(Name = "Unit sold in OR")]
        public int UnitSoldInOR { get; set; }
        [Display(Name = "Unit offered for sale")]
        public int UnitOfferedForSale { get; set; }
        [Display(Name = "Attachments")]
        public string AttachedFiles { get; set; }
        [Display(Name = "Target age group description")]
        public string TargetAgeGroupDescription { get; set; }
        [Display(Name = "Component")]
        public string ComponentName { get; set; }

        [Display(Name = "Chemical")]
        public string ChemicalName { get; set; }
        [Display(Name = "CASRN")]
        public string CASNumber { get; set; }
        [Display(Name = "Concentration range")]
        public string ConcentrationCategoryName { get; set; }
        [Display(Name = "Chemical function")]
        public string ChemicalFunctionName { get; set; }

        [Display(Name = "States")]
        public string States { get; set; }
        [Display(Name = "Period")]
        public Nullable<int> Period { get; set; }
        [Display(Name = "Report Submitted date")]
        public Nullable<System.DateTime> SubmittedDate { get; set; }
    }

    // Should match OData Model for DB-View vInventoryByOrg
    public class SearchManufProductResultsViewModel
    {
        [Display(Name = "Organization ID")]
        public int OrganizationId { get; set; }
        [Display(Name = "Organization name")]
        public string OrganizationName { get; set; }
        [Display(Name = "Count of Brands")]
        public Nullable<int> cntOfBrands { get; set; }
        public string Brands { get; set; }
    }

    // Should match OData Model for DB-View vInventoryBnPmWithChem
    public class SearchBNPMResultsViewModel
    {
        public int InventoryBNPMId { get; set; }
        [Display(Name = "Organization ID")]
        public int OrganizationId { get; set; }
        [Display(Name = "Organization name")]
        public string OrganizationName { get; set; }
        [Display(Name = "Brand")]
        public string BrandName { get; set; }
        [Display(Name = "Product Model")]
        public string ProductModel { get; set; }

        [Display(Name = "Chemicals")]
        public string ChemicalNames { get; set; }
    }

    // Should match OData Model for DB-View vInventoryBnPmByChem
    public class SearchBNPMChemResultsViewModel : SearchBNPMResultsViewModel
    {
        [Display(Name = "Chemical ID")]
        public int ChemicalId { get; set; }
        [Display(Name = "Chemical Name")]
        public string ChemicalName { get; set; }
        [Display(Name = "Count of Disclosures")]
        public Nullable<int> cntDisclosures { get; set; }
    }

    // TODO (HPCDS-126) breakdown downloads of details
    public class SearchBnpmViewModel
    {
        public List<DownloadBnpmViewModel> downloadBnpms { get; set; }

    }
    // TODO (HPCDS-126) breakdown downloads of details
    public class DownloadBnpmViewModel
    {
        public string Title
        {
            get
            {
                return String.Format("Manufacturers {0} - {1}", Start, End);
            }
        }
        public string Filename {
            get {
                return String.Format("HPCDS-ENV_CDP_BNPMData_Manufacturers_{0}-{1}.xlsx", Start, End);
            }
        }
        public string Start { get; set; } = "A";
        public string End { get; set; } = "Z";
    }
}