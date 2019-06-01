using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using static hpcds.Code.Constants.DbConstants;

namespace hpcds.Models
{
    public class Organization
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Organization()
        {
            Addresses = new HashSet<OrganizationAddress>();
            Users = new HashSet<ApplicationUser>();
        }

        /// <summary>
        ///  List of all Address associated to the Organization
        /// </summary>
        public virtual ICollection<OrganizationAddress> Addresses { get; set; }
        //  TODO: HPCDS-16 check that there's at least one Address of MailingAddress Type!!!

        /// <summary>
        /// List of Users associated to the Organization
        /// </summary>
        public virtual ICollection<ApplicationUser> Users { get; set; }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)] // Seq: dbo.SeqOrganizationId
        public int ID { get; set; }

        // [Index("UQ_Nullable_OID", IsUnique = true, IsClustered = false, AllowNulls = true] Unique Organization ID/PIN that ignores nulls
        [StringLength(8)]
        [Display(Name ="OID, unique organization ID provided by HPCDS")]
        public string PIN { get; set; }

        // [Required] - TODO: HPCDS-16 when wanting to add an new Org this should be required
        [StringLength(255)]
        [Index("UQ_OrganizationName", IsUnique = true)]
        [Display(Name = "Organization Name")]
        public string OrganizationName { get; set; }

        public bool IsLegacy { get; set; }
        public bool IsActive { get; set; }

        [StringLength(36)]
        [Display(Name ="Legacy WA PINs")]
        public string LegacyWaPins { get; set; }
        
        [Display(Name = "same as mailing address")] 
        public bool IsSameAsMailingAddress { get; set; } = true;
        
        public Guid CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }

        public Guid ModifiedBy { get; set; }
        public DateTime ModifiedOn { get; set; }

        [UIHint("cbContactUserId")]
        [Display(Name = "Primary Contact")]
        [MaxLength(128)]
        public string ContactUserId { get; set; }
        [UIHint("cbContactUser")]
        [Display(Name = "Primary Contact")]
        public virtual ApplicationUser ContactUser { get; set; }

        [Display(Name = "DUNS Number")]
        [StringLength(9)]
        public string DUNSNumber { get; set; }
    }

    public class OrganizationAddress
    {
        public OrganizationAddress() => AddressType = AddressTypeEnum.Mailing;
        public OrganizationAddress(AddressTypeEnum addressType) => AddressType = addressType;

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)] // Seq: dbo.SeqAddressId
        public int ID { get; set; }

        [Index("UQ_OrganizationID_AddressType", IsUnique = true, Order = 1)]
        public int OrganizationID { get; set; }
        public virtual Organization Organization { get; set; }

        [Index("UQ_OrganizationID_AddressType", IsUnique = true, Order = 2)]
        public AddressTypeEnum AddressType { get; set; } = AddressTypeEnum.Mailing;

        [StringLength(150)]
        [Display(Name = "Address, Line 1")]
        public string AddressLine1 { get; set; }

        [StringLength(100)]
        [Display(Name = "Address, Line 2")]
        public string AddressLine2 { get; set; }

        [StringLength(40)]
        public string City { get; set; }

        [StringLength(70)]
        [UIHint("cbStates")]
        [Display(Name= "State /Province")]
        public string StateProv { get; set; }

        [StringLength(24)]
        [Display(Name ="Postal Code")]
        public string PostalCodeNumber { get; set; }

        [StringLength(30)]
        [UIHint("cbCountries")]
        [Display(Name = "Country")]
        public string CountryCd { get; set; } = "US";

    }
}