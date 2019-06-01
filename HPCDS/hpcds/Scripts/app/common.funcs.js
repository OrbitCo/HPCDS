
window.common.func = (function () {
    var resultFn = {};
    /// Common Filters ----------------------------------------------------------------------
    _filter = {};
    /// for vOrganization table, to always include Name, Current and WAs Legacy PINs (HPCDS-18+)
    _filter.organizationNameOrOidOrLegacy = function (filterValue) {
        return {
            logic: "or",
            filters: [
                {
                    field: "OrganizationName",
                    operator: "contains",
                    ignoreCase: true,
                    value: filterValue
                },
                {
                    field: "PIN",
                    operator: "contains",
                    ignoreCase: true,
                    value: filterValue
                },
                {
                    field: "LegacyWaPins",
                    operator: "contains",
                    ignoreCase: true,
                    value: filterValue
                }
            ]
        };
    };

    /// Custom Filtering Events ---------------------------------------------------------
    resultFn.filtering = {};
    /// vOrganization (HPCDS-18) - combobox on Registration where a user can associate themselves with an active or legacy orgs
    resultFn.filtering.byActiveOrLegacyOrgs = function (ev) {

        var filterValue = ev.filter.value;

        // TODO: (HPCDS-18) determine if we need to wait until at least three chars are entered 
        if (filterValue.length > 1) {
            ev.preventDefault();

            var customFilter = {
                logic: "and",
                filters: [
                    // Active (w/OID) or Is a Legacy Organization
                    {
                        logic: "or",
                        filters: [
                            {
                                field: "PIN",
                                operator: "isnotnull"
                            },
                            {
                                field: "IsLegacy",
                                operator: "eq",
                                value: true
                            }
                        ]
                    },
                    // Search by Organization Name, PIN/OID or WA's PINs
                    _filter.organizationNameOrOidOrLegacy(filterValue)
                ]
            };

            this.dataSource.filter(customFilter);
        }
        else {
            ev.preventDefault();
            this.dataSource.filter("");
        }
            
    };

    /// Country (HPCDS-62) - combobox on Registration/EditProfile where a user can associate a country to an organization address
    resultFn.filtering.byCountryAndCode = function (ev) {

        var filterValue = ev.filter.value;
        if (filterValue.length > 0) {
            ev.preventDefault();

            var customFilter = {
                logic: "or",
                filters: [
                    {
                        field: "Code",
                        operator: "contains",
                        ignoreCase: true,
                        value: filterValue
                    },
                    {
                        field: "CountryName",
                        operator: "contains",
                        ignoreCase: true,
                        value: filterValue
                    }
                ]
            };

            this.dataSource.filter(customFilter);
        }
        else {
            ev.preventDefault();
            this.dataSource.filter("");
        }
    };

    /// State/Province (HPCDS-62) - combobox on Registration/EditProfile where a user can associate a state or province to an organization address
    resultFn.filtering.byStates = function (ev) {

        var filterValue = ev.filter.value;
        if (filterValue.length > 0) {
            ev.preventDefault();

            var customFilter = {

                logic: "or",
                filters: [
                    {
                        field: "AlphaCode",
                        operator: "contains",
                        ignoreCase: true,
                        value: filterValue
                    },
                    {
                        field: "StateName",
                        operator: "contains",
                        ignoreCase: true,
                        value: filterValue
                    }
                ]
            };
            this.dataSource.filter(customFilter);
        }
        else {
            ev.preventDefault();
            this.dataSource.filter("");
        }
    };

    /// State/Province (HPCDS-62) - combobox constraints
    resultFn.filtering.cbStatesConstraints = function (ev) {

        // 01 - prevent user from entering a custom value when 'US' is selected as the country
        var widget = ev.sender;
        var countryId = "#" + widget.element[0].id.replace("StateProv", "CountryCd");
        
        if (widget.value() && widget.select() === -1 && $(countryId).val() === "US") {
            //custom has been selected
            widget.value(""); //reset widget
        }
    };

    /// (HPCDS-55) tooltip for password
    $(document).ready(function () {
        $('[data-toggle="popover"]').popover({
            trigger: 'focus'
        });
    });

    /// Chemical (HPCDS-120) - combobox on Public search
    resultFn.filtering.byChemicalNameAndCASRN = function (ev) {
        var filterValue = ev.filter != undefined ? ev.filter.value : "";
        if (filterValue.length > 1) {
            ev.preventDefault();

            var customFilter = {

                logic: "or",
                filters: [
                    {
                        field: "ChemicalName",
                        operator: "contains",
                        ignoreCase: true,
                        value: filterValue
                    },
                    {
                        field: "CASNumber",
                        operator: "contains",
                        ignoreCase: true,
                        value: filterValue
                    }
                ]
            };
            this.dataSource.filter(customFilter);
        }
        else {
            ev.preventDefault();
            this.dataSource.filter("");
        }
    };

    /// ChemicalFunction (HPCDS-120) - multi-select on Public search
    resultFn.filtering.byCodeOrDescriptionForBricks = function (ev) {
        var filterValue = ev.filter != undefined? ev.filter.value : "";
        if (filterValue.length > 1) {
            ev.preventDefault();

            var customFilter = {

                logic: "or",
                filters: [
                    {
                        field: "ProductBrickDescription",
                        operator: "contains",
                        ignoreCase: true,
                        value: filterValue
                    },
                    {
                        field: "ProductBrickCode",
                        operator: "contains",
                        ignoreCase: true,
                        value: filterValue
                    }
                ]
            };
            this.dataSource.filter(customFilter);
        }
        else {
            ev.preventDefault();
            this.dataSource.filter("");
        }
    };

    return resultFn;
})();