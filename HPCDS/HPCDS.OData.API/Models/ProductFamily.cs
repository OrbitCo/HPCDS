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
    
    public partial class ProductFamily
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ProductFamily()
        {
            this.ProductClasses = new HashSet<ProductClass>();
        }
    
        public int ProductFamilyId { get; set; }
        public string ProductFamilyCode { get; set; }
        public string ProductFamilyDescription { get; set; }
        public int ProductSegmentId { get; set; }
        public string CreatedByName { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedByName { get; set; }
        public System.DateTime ModifiedDate { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ProductClass> ProductClasses { get; set; }
        public virtual ProductSegment ProductSegment { get; set; }
    }
}
