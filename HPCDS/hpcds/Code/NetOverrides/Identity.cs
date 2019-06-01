using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace hpcds.Code.NetOverrides
{
    public class IdentityOverrides
    {
        public class PgrmIdentityMessage : IdentityMessage
        {
            //Extend/Add-on
            public string ToStringEmail()
            {
                
                return string.Format(
                    @"<div class='email'>
                        <h5>Email Sent</h5>
                        <table>
                        <tr><th style='width:15%'>To:</th><td style='width:85%'>{0}</td></tr>
                        <tr><th>Subject:</th><td>{1}</td></tr>
                        <tr><th>Body:</th><td>{2}</td></tr>
                        </table>
                    </div>"
                    , this.Destination,this.Subject,this.Body);
            }
        }
    }
}