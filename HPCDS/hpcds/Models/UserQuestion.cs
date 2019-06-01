namespace hpcds.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class UserQuestion
    {
        [Key]
        [Column(Order = 0)] [ForeignKey("ApplicationUser")]
        public string U_ID { get; set; }

        [Key]
        [Column(Order = 1)] [ForeignKey("SecurityQuestion")]
        public int Q_ID { get; set; }

        [Required]
        [StringLength(100)]
        public string Answer { get; set; }

        public int DisplayOrder { get; set; }

        public virtual ApplicationUser ApplicationUser { get; set; }

        public virtual SecurityQuestion SecurityQuestion { get; set; }
    }
}
