var SearchJS = function (urls) {
    var _urls = urls;

    var _StartDateChange = function () {
        var endId = "#EndDate";
        var end = $(endId).data("kendoDatePicker");
        var startDate = $("#StartDate").data("kendoDatePicker").value();
        var endDate = end.value();

        if (startDate) {
            startDate = new Date(startDate);
            startDate.setDate(startDate.getDate());
            end.min(startDate);
            end.max(new Date(startDate.getFullYear() + 10, startDate.getMonth(), startDate.getDay()));
        } else if (endDate) {
            this.max(new Date(endDate));
        } else {
            endDate = new Date();
            this.max(endDate);
            end.min(endDate);
        }
    };

    var _EndDateChange = function () {

        var startId = "#StartDate";
        var start = $(startId).data("kendoDatePicker");

        var endDate = $("#EndDate").data("kendoDatePicker").value(),
            startDate = start.value();

        if (endDate) {
            endDate = new Date(endDate);
            endDate.setDate(endDate.getDate());
            start.max(endDate);
            start.min(new Date(endDate.getFullYear() - 10, endDate.getMonth(), endDate.getDay())); //4 years back
        } else if (startDate) {
            this.min(new Date(startDate));
        } else {
            endDate = new Date();
            start.max(endDate);
            this.min(endDate);
        }
    };

    // Trigger Enable/Disable of All Periods Option as follows except for Site/State Admins
    var _AllEnableDisableRadioOption = function () {
        if ($("[name=Type][value='All']").is(":checked")) {
            $("[name=Period][value='All']").attr('disabled', true);
            $("input[type='radio']:disabled").parent('label').addClass("color-disabled");
        } else if ($("[name=Type][value=Chemical]").is(":checked")) {
            $("input[type='radio']:disabled").parent('label').removeClass("color-disabled");
            $("[name=Period][value='All']").attr('disabled', false);
        } else if ($("[name=Type][value=Company]").is(":checked")) {
            $("input[type='radio']:disabled").parent('label').removeClass("color-disabled");
            $("[name=Period][value='All']").attr('disabled', false);
        } else { // $("[name=Type][value=Product]").is(":checked")) 
            $("input[type='radio']:disabled").parent('label').removeClass("color-disabled");
            $("[name=Period][value='All']").attr('disabled', false);
        }
    };


    // Tigger Change Event, so -panel collapse or show based on selected value  TODO: (HPCDS-124) use Bootstrap's Collapse/Show and not jQuery show/hide since it uses style attribute
    var _ShowHideTypes = function () {
        if ($("[name=Type][value='All']").is(":checked")) {
            $("#ChemicalSection").collapse('hide');
            $("#ProductsSection").collapse('hide');
            $("#CompanySection").collapse('hide');
        } else if ($("[name=Type][value=Chemical]").is(":checked")) {
            $("#ChemicalSection").collapse('show');
            $("#ProductsSection").collapse('hide');
            $("#CompanySection").collapse('hide');
        } else if ($("[name=Type][value=Company]").is(":checked")) {
            $("#CompanySection").collapse('show');
            $("#ProductsSection").collapse('hide');
            $("#ChemicalSection").collapse('hide');
        } else { // $("[name=Type][value=Product]").is(":checked")) 
            $("#ProductsSection").collapse('show');
            $("#ChemicalSection").collapse('hide');
            $("#CompanySection").collapse('hide');
        }

        // Display Action link on VT checkbox and Product radio selection
        if ($("[name=Type][value=Product]").is(":checked") && $("[name=States][value=VT]").is(":checked")) {
            $("#VTLink").collapse('show');
        }
        else {
            $("#VTLink").collapse('hide');
        }
    };

    var _ShowHidePeriods = function () {
        if ($("[name=Period][value='LastTwoYears']").is(":checked") || $("[name=Period][value=All]").is(":checked")) {
            $("#DateRangeSection").collapse('hide');
        } else {
            $("#DateRangeSection").collapse('show');
        }
    };

    // Custom Filter Optios for Concentration (HPCDS-155)
    var _ConcentrationFilterOrder = function (e) {
        if (e.field === "ConcentrationCategoryName") {
            var filterMultiCheck = e.container.find(".k-filterable").data("kendoFilterMultiCheck");
            if (filterMultiCheck !== undefined) {
                filterMultiCheck.container.empty();
                filterMultiCheck.checkSource.data([
                    { ConcentrationCategoryName: "PQL less than 100 ppm" }, { ConcentrationCategoryName: "Equal to or greater than 100 but less than 500 ppm" },
                    { ConcentrationCategoryName: "Equal to or greater than 500 but less than 1,000 ppm" }, { ConcentrationCategoryName: "Equal to or greater than 1,000 but less than 5,000 ppm" },
                    { ConcentrationCategoryName: "Equal to or greater than 5,000 but less than 10,000 ppm" }, { ConcentrationCategoryName: "Equal to or greater than 10,000 ppm" }
                ]);
                filterMultiCheck.createCheckBoxes();
            }
        }
    };

    // Kendo validation on submit
    var _ClientSideFormValidation = function () {
        var chemValidate, prodValidate, stateVTValidate, stateORValidate = true;
        $("form").kendoValidator({
            rules: {
                // ValMsg01 : for Selecting Chemical
                isChemicalRequired: function (input) {
                    // K-Combobox : for Chemical and function is required if 'Chemical' is selected
                    if (input.is("[name=Chemicals]") && $("[name=Type]:checked").val() === "Chemical") {
                        chemValidate = input.val() !== "" && input.val() !== -1 && input.val().length !== 0;
                    }
                    if (input.is("[name=SelectedFunction]") && $("[name=Type]:checked").val() === "Chemical") {
                        return chemValidate || (input.val() !== "" && input.val() !== -1);
                    }
                    return true;
                },

                // ValMsg02 : for Selecting Company
                isCompanyRequired: function (input) {
                    // K-Combobox : for Company is required if 'Company' is selected
                    if (input.is("[name=OrganizationName]") && $("[name=Type]:checked").val() === "Company") {
                        return input.val() !== "" && input.val() !== -1;
                    }
                    return true;
                },

                // ValMsg03 : for Selecting ProductBricks
                isProductRequired: function (input) {
                    // K-Combobox : for ProductBricks and Component is required if 'Chemical' is selected
                    if (input.is("[name=ProductBricks]") && $("[name=Type]:checked").val() === "Product") {
                        prodValidate = input.val() !== "" && input.val() !== -1 && input.val().length !== 0;
                    }
                    if (input.is("[name=SelectedComponent]") && $("[name=Type]:checked").val() === "Product") {
                        return prodValidate || (input.val() !== "" && input.val() !== -1);
                    }
                    return true;
                },

                 // ValMsg04 : for Selecting States
                isStateRequired: function (input) {
                    // checkbox : for states is required 
                    if (input.is("[name=States]"))
                        return $("[name=States]:checked").length > 0;
                    return true;
                },

                // ValMsg05 : for Selecting Dates
                isDateRequired: function (input) {
                    // datepicker : for states is required 
                    if (input.is("[name=StartDate]") && $("[name=Period]:checked").val() === "CustomRange") {
                        return new Date($("[name=EndDate]").val()) > new Date($("[name=StartDate]").val());
                    } 
                    return true;
                },

                maxDateRange: function (input) {
                    // datepicker : for states is required 
                    if (input.is("[name=StartDate]") && $("[name=Period]:checked").val() === "CustomRange") {
                        var edt = new Date($("[name=EndDate]").val());
                        var sdt = new Date($("[name=StartDate]").val());
                        return edt > sdt && ((edt - sdt) < 126316800000); // 4 years 1 day=> 126316800000 miliseconds;
                    }
                    return true;
                },
            },
            messages: {
                isChemicalRequired: "Chemical or Function selection is required",
                isCompanyRequired: "Company selection is required",
                isProductRequired: "Product Brick(s) or Component selection is required",
                isStateRequired: "Select at least one State",
                isDateRequired: "must be before End Date",
                maxDateRange: "Maximum date range is 4 years"
            }
        });
    };

    jQuery.expr[':'].hasValue = function (el, index, match) {
        return el.value !== "";
    };

    // Ensures that a filter option exist for a Kendo Datasources
    var _IntializeKFilter = function (options) {
        
        if (options.filter === null || options.filter === undefined) {
            options.filter = {
                logic: "and",
                filters: []
            };
        }
        else if (options.filter !== null && options.filter.logic !== null && options.filter.logic === "or") {
            var columnFilter = options.filter;
            options.filter = {
                logic: "and",
                filters: []
            };
            options.filter.filters.push(columnFilter);
        }
    };

    // Set Baseline Filter from Search Form (HPCDS-125)
    // Collect and Prep Filter JSON for kendo.datasource.read()
    var _GetFormFilters = function (options) {
        console.log({
            all: $(this).serializeArray(),
            visible: $('#SearchForm :input:not(:hidden):hasValue').serializeArray(),
        });

        // 01 - setup master form filter for kendo grids
        _IntializeKFilter(options);

        // 02 - parse and add to master filter, k-multiselect like Chemical(s) and Brick(s)
        // 02a - used to parse k-mulitselect Controllers
        var forMultiselect = function(i) {
            var selected = $(this).data("kendoMultiSelect").value().map(m => {
                return {
                    field: $(this).attr("name"),
                    operator: "eq",
                    value: m
                };
            });
            options.filter.filters.push({
                logic: "or",
                filters: selected
            });
        };
        // 02b - add to master filter, all visible k-mulitselect
        $(".k-multiselect:visible select:hasValue").each(forMultiselect);

        // 03 - add to master filter, States checkboxes
        var selectedStates = $("[name=States]:checked").map(function() {
            return {
                field: this.name,
                operator: "eq",
                value: this.value
            };
        }).toArray();

        options.filter.filters.push({
            logic: "or",
            filters: selectedStates
        });

        // 04 - parse and add to master filter, k-combobox like Component and Function
        var forComboboxes = function (i) {
            var val = parseInt(
                $(this).val().replace(/,/g, ".")
            );
            if (isNaN(val)) { val = $(this).val(); } // if the val is not an int then just use as-is

            options.filter.filters.push({ field: $(this).attr("name"), operator: "eq", value: val });
        };
        $(".k-combobox:visible input:hidden:hasValue").each(forComboboxes);


        // 05 - add to master filter, Period Dates // TODO: (HPCDS-125) use dates instead of year...
        // 05a - parse start/end dates into k-filter
        var setPeriodRange = function (startDt, endDt) {
            options.filter.filters.push({ field: "Period", operator: "gte", value: startDt });
            options.filter.filters.push({ field: "Period", operator: "lte", value: endDt });
        };
        // 05b - get dates from inputs or assumptions
        if ($("[name=Period][value='LastTwoYears']").is(":checked")) {
            var now = new Date();
            var nowYr = now.getFullYear();
            setPeriodRange(nowYr - 2, nowYr);
        }
        else if ( $("[name=Period][value=CustomRange]").is(":checked")) {
            var startDate = $("#StartDate").data("kendoDatePicker").value(),
                endDate = $("#EndDate").data("kendoDatePicker").value();
            setPeriodRange(startDate.getFullYear(), endDate.getFullYear());
        }

        //06 - Company textbox filter
        var selectedCompany = function (orgName) {
            options.filter.filters.push({ field: "OrganizationName", operator: "contains", value: orgName });
        };
        if ($("[name=OrganizationName]") && $("[name=Type]:checked").val() === "Company") {
            selectedCompany($("[name=OrganizationName]").val());
        }

        // QA - check master filter
        console.log(options.filter);
        console.log(JSON.stringify(options.filter));
        return options;

    };

    // Set Baseline Filter from parent grid (HPCDS-69)
    var _ApplyParentOrgId = function (options, OrganizationId) {
        
        // 01 - setup master form filter for kendo grids
        _IntializeKFilter(options);

        // 02 - set base line filter
        options.filter.filters.push({ field: "OrganizationId", operator: "eq", value: OrganizationId });

        // 03 - return
        // QA - check master filter
        // console.log(options.filter);
        // console.log(JSON.stringify(options.filter));
        return options;
    };

    // Reload, k-grid with updated base-line filter (HPCDS-125)
    var _SubmitFiltersToGrid = function (event) {
        event.preventDefault();
        $("#msg").collapse('show');
        var grid = $("#vmReportResults").data("kendoGrid");
        
        // reset grid filter and sorting 
        if (grid.dataSource.filter() !== undefined) grid.dataSource.filter({});
        if (grid.dataSource.sort() !== undefined) grid.dataSource.sort({});

        grid.dataSource.read();
        var elmnt = document.getElementById("Period"); // or "results" but this way we can see some the searched from
        elmnt.scrollIntoView();
    };

    // Export, BNPM data 1,000,000 records at a time (HPCDS-126)
    // Interium version TODO: will move to server side
    // src: https://docs.telerik.com/kendo-ui/framework/excel/extract-datasoruce
    var _ExportBNPM = function (Start,End,AtoZsection) {
        var ds = new kendo.data.DataSource({

            type: "odata-v4",
            transport: {
                read: _urls.odataUrl_vInvChems
            },
            // page: e.SelectedPage || 1,
            pageSize: 300000, // set limit to 100,000 TODO: HPCDS-126 for server side page size to 1,000,000
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true,
            schema: {
                model: {
                    fields: {
                        OrganizationId: { type: "number" },
                        OrganizationName: { type: "string" },
                        BrandName: { type: "string" },
                        ProductModel: { type: "string" },
                        ChemicalNames: { type: "string" }
                    }
                }
            },
            sort: [
                { field: "OrganizationName", dir: "asc" },
                { field: "BrandName", dir: "asc" },
                { field: "ProductModel", dir: "asc" },
            ],
            filter: {
                logic: "and", filters: [{ field: "rownum", operator: "ge", value: Start || 0 }, { field: "rownum", operator: "le", value: End || 50 }]}
        });

        var rows = [{
            cells: [
                { value: "OrganizationId" },
                { value: "OrganizationName" },
                { value: "BrandName" },
                { value: "ProductModel" },
                { value: "ChemicalNames" }
            ]
        }];

        // Use fetch so that you can process the data when the request is successfully completed.
        ds.fetch(function () {
            var data = this.data();
            for (var i = 0; i < data.length; i++) {
                // Push single row for every record.
                rows.push({
                    cells: [
                        { value: data[i].OrganizationId },
                        { value: data[i].OrganizationName },
                        { value: data[i].BrandName },
                        { value: data[i].ProductModel },
                        { value: data[i].ChemicalNames.replace(new RegExp("<br>", 'g') ,"") }
                    ]
                });
            }
            var workbook = new kendo.ooxml.Workbook({
                sheets: [
                    {
                        columns: [
                            { autoWidth: true },
                            { autoWidth: true },
                            { autoWidth: true },
                            { autoWidth: true },
                            { autoWidth: true }
                        ],
                        title: "Products",
                        rows: rows
                    }
                ]
            });
            // Save the file as an Excel file with the xlsx extension.
            kendo.saveAs({ dataURI: workbook.toDataURL(), fileName: "Results of Products " + AtoZsection + ".xlsx", proxyURL: _urls.saveExport, forceProxy: true });
        });
    };

    var _public = {
        StartDateChange: _StartDateChange,
        EndDateChange: _EndDateChange,
        ShowHideTypes: _ShowHideTypes,
        ShowHidePeriods: _ShowHidePeriods,
        ConcentrationFilterOrder: _ConcentrationFilterOrder,
        ClientSideFormValidation: _ClientSideFormValidation,
        AllEnableDisableRadioOption: _AllEnableDisableRadioOption,
        GetFormFilters: _GetFormFilters,
        SubmitFiltersToGrid: _SubmitFiltersToGrid,
        ApplyParentOrgId: _ApplyParentOrgId,
        ExportBNPM: _ExportBNPM,
    };

    return _public;

};

