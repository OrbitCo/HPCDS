//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HPCDS.OData.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class ProductBrick
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ProductBrick()
        {
            this.Reports = new HashSet<Report>();
        }
    
        public int ProductBrickId { get; set; }
        public string ProductBrickCode { get; set; }
        public string ProductBrickDescription { get; set; }
        public int ProductClassId { get; set; }
        public string IsVisibleFlag { get; set; }
        public string CreatedByName { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedByName { get; set; }
        public System.DateTime ModifiedDate { get; set; }
    
        public virtual ProductClass ProductClass { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Report> Reports { get; set; }
    }
}
