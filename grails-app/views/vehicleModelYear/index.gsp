<%--
  Created by IntelliJ IDEA.
  User: sergio
  Date: 26/02/16
  Time: 10:54
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="myMain"/>
    <title>Vehicle - Model - Year</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
    <style type="text/css">
    #divLeftPanel {
        width: 37%;
        float: left;
    }

    #divVMYFilter {
        border: 3px solid #255b17;
        margin: 4px;
    }

    #divVMYForm {
        border: 3px solid #255b17;
        margin: 4px;
    }

    p {
        margin: 3px;
    }

    p > label {
        display: inline-block;
        float: left;
        clear: left;
        width: 30%;
        text-align: right;
    }

    #divList {
        width: 60%;
        float: right;
        border: 3px solid #255b17;
        margin: 4px;
    }

    #divVMYListPaging {
        border-top: 3px solid #255b17;
    }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            clearFilter();
            maxPageNumber = 1;
            selectedPageNumber = 1;
            vmyList(selectedPageNumber);
            $("#idForm").val(null)
        })

        var maxPageNumber
        var selectedPageNumber

        var makeFilter
        var modelFilter
        var minYearFilter
        var maxYearFilter

        function clearFilter() {
            makeFilter = null
            modelFilter = null
            minYearFilter = null
            maxYearFilter = null
        }

        function vmyList(selectedPageNum) {
            if (selectedPageNum < 1 || selectedPageNum > maxPageNumber) {
                //TODO:<svera>: mostrar algun mensaje de error
            } else {

                $.ajax({
                    method: "GET",
                    url: "list",
                    data: {
                        "selectedPageNum": selectedPageNum, "makeFilter": makeFilter, "modelFilter": modelFilter,
                        "minYearFilter": minYearFilter, "maxYearFilter": maxYearFilter
                    },
                    success: function (data) {
                        maxPageNumber = data.maxPageNum

                        $("#divVMYList").html("<table><thead><th width='30%'>Make</th><th width='30%'>Model</th><th width='10%'>Year</th><th  width='15%'></th><th width='15%'></th></thead><tbody></tbody></table>")
                        var table = $("#divVMYList").children()
                        for (i in data.vmyList) {
                            var vmy = data.vmyList[i]
                            table.append("<tr id='vmy_id_" + vmy.id + "'><td>" + vmy.make + "</td><td>" + vmy.model + "</td><td>" + vmy.year + "</td>" +
                                    "<td><a href='javascript: updateVMY(" + vmy.id + ")'>Update</a></td><td><a href='javascript: deleteVMY(" + vmy.id + ")'>Delete</a></td></tr>")
                        }

                        $("#divVMYListPaging").html("<label for='pageNumber'>Page</label><input id='pageNumberSelected' " +
                                "type='number' name='pageNumber' min='1' value='" + selectedPageNum + "' max='" +
                                maxPageNumber + "' /><input id='showPageSelected' type='submit' name='show' value='Show' />" +
                                " Max Page #" + maxPageNumber + " - Page Selected #" + selectedPageNum)
                        $("#showPageSelected").click(function () {
                            if (selectedPageNum != $("#pageNumberSelected").val()) {
                                vmyList($("#pageNumberSelected").val())
                            }
                        })

                        selectedPageNumber = selectedPageNum
                    }
                })

            }
        }

        function updateVMY(id) {
            $("#makeForm").val($("#vmy_id_" + id + " td:eq(0)").text());
            $("#modelForm").val($("#vmy_id_" + id + " td:eq(1)").text());
            $("#yearForm").val($("#vmy_id_" + id + " td:eq(2)").text());
            $("#idForm").val(id);
            $("#mainFormButton").val("Edit");
            $("#divVMYForm :input[name='cancel']").show();
        }

        function cancelUpdateVMY() {
            $("#divVMYForm :input[name*='Form']").val(null);
            $("#mainFormButton").val("Save");
            $("#divVMYForm :input[name='cancel']").hide();
        }

        function deleteVMY(id) {
            if (confirm("Are you sure you want to remove the selected VehicleModelYear?")) {
                $.ajax({
                    method: "POST",
                    url: "delete",
                    data: {
                        "id": id
                    },
                    success: function (data) {
                        if (data.message == "OK") {
                            vmyList(selectedPageNumber)
                        } else {
                            //TODO: <svera>: mostrar error
                        }
                    }
                })
            }
        }

        function applyFilter() {
            $("#filterMessage").html("")
            clearFilter()

            var make = $("#makeFilter").val()
            if (make != null && make != "") {
                makeFilter = make
            }
            var model = $("#modelFilter").val()
            if (model != null && model != "") {
                modelFilter = model
            }
            var minYear = $("#minYearFilter").val()
            var maxYear = $("#maxYearFilter").val()

            if (minYear != null && minYear != "") {
                console.log("se ingreso un valor menor")
                if (minYear >= 1800) {
                    minYearFilter = minYear
                }
                if (maxYear != null && maxYear != "" && minYear > maxYear) {
                    clearFilter();
                    $("#filterMessage").text("Min Year must be greater than Max Year")
                    return
                }
            } else {
                minYearFilter = 1800
            }
            if (maxYear != null && maxYear != "") {
                console.log("se ingreso un valor mayor")
                if (maxYear <= 9999) {
                    maxYearFilter = maxYear
                }
            } else {
                maxYearFilter = 9999
            }
            vmyList(1)
        }

        function saveVMY() {
            $.ajax({
                method: "POST",
                url: "save",
                data: {
                    "make": $("#makeForm").val(),
                    "model": $("#modelForm").val(),
                    "year": $("#yearForm").val(),
                    "id": $("#idForm").val()
                },
                success: function (data) {
                    if (data.message == "OK") {
                        $("#formMessage").html("VehicleModelYear was saved successfully")
                        $("#divVMYForm :input[name*='Form']").val(null);
                        $("#mainFormButton").val("Save");
                        $("#divVMYForm :input[name='cancel']").hide();
                        vmyList(selectedPageNumber)
                    } else {
                        $("#formMessage").html("Can not be possible to save VehicleModelYear")

                        for (i in data.errors) {
                            for (j in data.errors[i])
                                var obj = data.errors[i][j].message
                            console.log(obj)
                            $("#formMessage").append("<br/>" + obj.toString())
                        }
                    }
                }
            })
        }
    </script>
</head>

<body>
<div id="divLeftPanel">
    <div id="divVMYFilter">
        <div id="filterMessage"></div>

        <p><label for="makeFilter">Make</label>
            <input type="text" id="makeFilter" name="makeFilter"/></p>

        <p><label for="modelFilter">Model</label>
            <input type="text" id="modelFilter" name="modelFilter"/></p>

        <p><label for="minYearFilter">Min Year</label>
            <input id="minYearFilter" type="number" min="1800" max="9999" name="minYearFilter"/></p>

        <p><label for="maxYearFilter">Max Year</label>
            <input id="maxYearFilter" type="number" min="1800" max="9999" name="maxYearFilter"/></p>
        <input type="submit" name="filter" value="Filter" onclick="applyFilter()">
    </div>


    <div id="divVMYForm">
        <div id="formMessage"></div>

        <p><label for="makeForm">Make</label>
            <input type="text" id="makeForm" name="makeForm"/></p>

        <p><label for="modelForm">Model</label>
            <input type="text" id="modelForm" name="modelForm"/></p>

        <p><label for="yearForm">Year</label>
            <input id="yearForm" type="number" min="1800" max="9999" name="yearForm"/></p>
        <input type="hidden" id="idForm" name="idForm"/>
        <input type="submit" id="mainFormButton" name="mainButton" value="Save" onclick="saveVMY()">
        <input type="submit" name="cancel" value="Cancel" style="display: none" onclick="cancelUpdateVMY()">
    </div>
</div>

<div id="divList">
    <div id="divVMYList"></div>

    <div id="divVMYListPaging"></div>
</div>
</body>
</html>