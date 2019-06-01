var RegisterJS = function () {
        
    // Tigger Change Event, so -panel collapse or show based on selected value
    var _ShowHidePanels = function () {
        $("[name=IsHpcdsOrganization][value=False]:checked").trigger("click");
        $("[name=IsHpcdsOrganization][value=True]:checked").trigger("click");
        if ($("[id$=IsSameAsMailingAddress]").is(":not(:checked)") && !$(".notSameAsMailingAddress-panel").hasClass("show"))
            $(".notSameAsMailingAddress-panel").addClass("show");
    };

    // Kendo validation on submit
    var _ClientSideFormValidation = function () {
        var pwd = "";
        $("form").kendoValidator({
            rules: {
                // ValMsg00 : kendo sample, https://docs.telerik.com/aspnet-mvc/getting-started/validation#implement-custom-attributes
                greaterdate: function (input) {
                    if (input.is("[data-val-greaterdate]") && input.val() != "") {
                        var date = kendo.parseDate(input.val()),
                            earlierDate = kendo.parseDate($("[name='" + input.attr("data-val-greaterdate-earlierdate") + "']").val());
                        return !date || !earlierDate || earlierDate.getTime() < date.getTime();
                    }

                    return true;
                },

                // ValMsg01 : for Selecting Registered Org
                isHpcdsOrgIdRequired: function (input) {
                    // K-Combobox : for Organization ID is required if 'Yes' is selected
                    if (input.is("[name=O_ID]") && $("[name=IsHpcdsOrganization]:checked").val() === "True") {
                        return input.val() != "" && input.val() != -1;
                    }
                    return true;
                },

                // ValMsg02 : for Entering New Org and Mailing Address CountryCd
                newOrgInfoRequired: function (input) {
                    var OrgCondition = $("[name=IsHpcdsOrganization]:checked").val() == undefined ? true : $("[name=IsHpcdsOrganization]:checked").val() === "False";
                    // K-Combobox : for New Organization Name is required if 'No' is selected
                    if (OrgCondition && (input.is("[name$=OrganizationName]")
                        || input.is("[name$='MailingAddress.AddressLine1']")
                        || input.is("[name$='MailingAddress.City']")
                        || input.is("[name$='MailingAddress.StateProv']")
                        || input.is("[name$='MailingAddress.CountryCd']")
                        || ($("[id$=IsSameAsMailingAddress]").is(":not(:checked)")
                            && (input.is("[name$='PhysicalAddress.AddressLine1']")
                                    || input.is("[name$='PhysicalAddress.City']")
                                    || input.is("[name$='PhysicalAddress.StateProv']")
                                    || input.is("[name$='PhysicalAddress.CountryCd']")
                               )
                           )
                        )) {
                        return input.val() != "" && input.val().length >= 2 && input.is(":not(:disabled)");
                    }
                    return true;
                },

                // ValMsg03 : prevent user from entering same security answer
                noDupSecurityAnswers: function (input) {
                    if (input.is("[name*='Answer']") && input.val() !== "")
                    {                        
                        var otherAnswers = $("[name*='Answer']").filter(":not(#" + input[0].id + ")");
                        var wSameAnswer = otherAnswers.filter(function () { return $(this).val() === input.val(); });
                        return wSameAnswer.length === 0;
                    }

                    return true;
                },

                // ValMsg04 : Compare Password and confirm Password
                isConfiremPasswordSame: function (input) {
                    if (input.is("[name=Password]")) {
                        pwd = input.val()
                    }
                    // K-Combobox : for Organization ID is required if 'Yes' is selected
                    if (input.is("[name=ConfirmPassword]") && input.val() !== pwd) {
                        return false;
                    }
                    return true;
                },
            },
            messages: {
                // ValMsg00 : kendo sample
                greaterdate: function (input) {
                    return input.attr("data-val-greaterdate");
                },

                // ValMsg01 : Require user to Search and select from registered organizations
                isHpcdsOrgIdRequired: "Required",
                // ValMsg02 : for Entering New Org
                newOrgInfoRequired: "Required",
                // ValMsg03 : prevent user from entering same security answer
                noDupSecurityAnswers: "Must be a unique value",
                isConfiremPasswordSame: "Password and Confirm Password do not match"

            }
        });
    };


    var _public = {
        ShowHidePanels: _ShowHidePanels,
        ClientSideFormValidation: _ClientSideFormValidation,
    };

    return _public;

};
