namespace hpcds.Migrations.AuthDbContext
{
    using System;
    using System.Data.Entity.Migrations;

    public partial class RedoSecurityQuestions : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.UserQuestions", "Q_ID", "dbo.SecurityQuestions");
            // DropIndex("dbo.Organizations", "UQ_OrgId"); // AND ignore changes to Organizations.MO_ID set to NONE for SeederDbContext
            // DropPrimaryKey("dbo.Organizations");
            DropPrimaryKey("dbo.SecurityQuestions");
            // AlterColumn("dbo.Organizations", "MO_ID", c => c.Int(nullable: false));
            // AlterColumn("dbo.SecurityQuestions", "ID", c => c.Int(nullable: false));
            // AddPrimaryKey("dbo.Organizations", "MO_ID");
            // AddPrimaryKey("dbo.SecurityQuestions", "ID");
            // (HPCDS-73) RE-Create SecurityQuestions -->
            // 01 - Create new table
            DropIndex("dbo.SecurityQuestions", "UQ_Questions");
            CreateTable(
                "dbo.Questions",
                c => new
                {
                    ID = c.Int(nullable: false/*, identity: true*/),
                    Questions = c.String(nullable: false, maxLength: 100),
                })
                .PrimaryKey(t => t.ID, name: "PK_dbo.SecurityQuestions")
                .Index(t => t.Questions, unique: true, name: "UQ_Questions");
            // 02 - Setup Sequence PKey 
            Sql(@"CREATE SEQUENCE dbo.SeqQuestionId as int START WITH 1 INCREMENT BY 1");
            AlterColumn("dbo.Questions", "ID", c => c.Int(nullable: false, defaultValueSql: "NEXT VALUE FOR dbo.SeqQuestionId", name: "DF_SEQ_QuestionId"));
            // 03 - Copy data over into new table
            Sql(@"INSERT INTO [dbo].[Questions] ([ID],[Questions]) SELECT [ID],[Questions] FROM [SecurityQuestions];");
            // 04 - Drop old table and rename new table using old name
            DropTable("dbo.SecurityQuestions");
            RenameTable("Questions", "SecurityQuestions");
            // <--
            // CreateIndex("dbo.Organizations", "MO_ID", unique: true, name: "UQ_OrgId");
            AddForeignKey("dbo.UserQuestions", "Q_ID", "dbo.SecurityQuestions", "ID", cascadeDelete: true);
        }

        public override void Down()
        {
            DropForeignKey("dbo.UserQuestions", "Q_ID", "dbo.SecurityQuestions");
            // DropIndex("dbo.Organizations", "UQ_OrgId"); // IGNORE for SEEDER
            DropPrimaryKey("dbo.SecurityQuestions");
            // DropPrimaryKey("dbo.Organizations");
            AlterColumn("dbo.SecurityQuestions", "ID", c => c.Int(nullable: false, identity: true));
            // AlterColumn("dbo.Organizations", "MO_ID", c => c.Int(nullable: false));
            AddPrimaryKey("dbo.SecurityQuestions", "ID");
            // AddPrimaryKey("dbo.Organizations", "MO_ID");
            // CreateIndex("dbo.Organizations", "MO_ID", unique: true, name: "UQ_OrgId");
            AddForeignKey("dbo.UserQuestions", "Q_ID", "dbo.SecurityQuestions", "ID", cascadeDelete: true);
            // Drop Sequence (HPCDS-73) -->
            Sql(@"IF OBJECT_ID(N'dbo.SeqQuestionId', N'SO') IS NOT NULL
                    DROP SEQUENCE dbo.SeqQuestionId;");
            // <--
        }
    }
}
