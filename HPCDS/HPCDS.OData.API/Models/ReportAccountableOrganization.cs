//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HPCDS.OData.API.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class ReportAccountableOrganization
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ReportAccountableOrganization()
        {
            this.Documents = new HashSet<Document>();
        }
    
        public int ReportAccountableOrganizationId { get; set; }
        public int ReportId { get; set; }
        public int AccountableOrganizationId { get; set; }
        public string TargetAgeGroupDescription { get; set; }
        public string RequestedConfidentialFlag { get; set; }
        public string IsConfidentialFlag { get; set; }
        public string CreatedByName { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedByName { get; set; }
        public System.DateTime ModifiedDate { get; set; }
    
        public virtual CSPAOrganization CSPAOrganization { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Document> Documents { get; set; }
        public virtual Report Report { get; set; }
    }
}
