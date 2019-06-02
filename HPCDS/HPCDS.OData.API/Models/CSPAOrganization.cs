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
    
    public partial class CSPAOrganization
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public CSPAOrganization()
        {
            this.OrganizationRelationships = new HashSet<OrganizationRelationship>();
            this.OrganizationRelationships1 = new HashSet<OrganizationRelationship>();
            this.Reports = new HashSet<Report>();
            this.ReportAccountableOrganizations = new HashSet<ReportAccountableOrganization>();
            this.UserAccounts = new HashSet<UserAccount>();
        }
    
        public int AffiliationOrganizationId { get; set; }
        public string OrganizationPIN { get; set; }
        public string AccountablePartyFlag { get; set; }
        public string CreatedByName { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedByName { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string IsSupplierConfidentialFlag { get; set; }
        public Nullable<System.DateTime> RequestSupplierConfidentialDatetime { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<OrganizationRelationship> OrganizationRelationships { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<OrganizationRelationship> OrganizationRelationships1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Report> Reports { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ReportAccountableOrganization> ReportAccountableOrganizations { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<UserAccount> UserAccounts { get; set; }
    }
}
