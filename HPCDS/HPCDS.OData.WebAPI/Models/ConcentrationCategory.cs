//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HPCDS.OData.WebAPI.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class ConcentrationCategory
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ConcentrationCategory()
        {
            this.ReportDetails = new HashSet<ReportDetail>();
        }
    
        public int ConcentrationCategoryId { get; set; }
        public string ConcentrationCategoryName { get; set; }
        public string IsVisibleFlag { get; set; }
        public string CreatedByName { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedByName { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string VT_Concentration { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ReportDetail> ReportDetails { get; set; }
    }
}