namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Add_SecurityQuestions : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.SecurityQuestions",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        Questions = c.String(nullable: false, maxLength: 100),
                    })
                .PrimaryKey(t => t.ID)
                .Index(t => t.Questions, unique: true, name: "UQ_Questions");
            
            CreateTable(
                "dbo.UserQuestions",
                c => new
                    {
                        U_ID = c.String(nullable: false, maxLength: 128),
                        Q_ID = c.Int(nullable: false),
                        Answer = c.String(nullable: false, maxLength: 100),
                        DisplayOrder = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.U_ID, t.Q_ID })
                .ForeignKey("dbo.AspNetUsers", t => t.U_ID, cascadeDelete: true)
                .ForeignKey("dbo.SecurityQuestions", t => t.Q_ID, cascadeDelete: true)
                .Index(t => t.U_ID)
                .Index(t => t.Q_ID);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.UserQuestions", "Q_ID", "dbo.SecurityQuestions");
            DropForeignKey("dbo.UserQuestions", "U_ID", "dbo.AspNetUsers");
            DropIndex("dbo.UserQuestions", new[] { "Q_ID" });
            DropIndex("dbo.UserQuestions", new[] { "U_ID" });
            DropIndex("dbo.SecurityQuestions", "UQ_Questions");
            DropTable("dbo.UserQuestions");
            DropTable("dbo.SecurityQuestions");
        }
    }
}
