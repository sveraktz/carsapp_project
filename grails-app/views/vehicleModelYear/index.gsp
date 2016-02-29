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
            vmyList(1);

        })

        var maxPageNumber

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
                    method: "POST",
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
        <p><label for="makeForm">Make</label>
            <input type="text" id="makeForm" name="makeForm"/></p>

        <p><label for="modelForm">Model</label>
            <input type="text" id="modelForm" name="modelForm"/></p>

        <p><label for="yearForm">Year</label>
            <input id="yearForm" type="number" min="1800" max="9999" name="yearForm"/></p>
        <input type="submit" name="save" value="Save" onclick="saveVMY()">
    </div>
</div>

<div id="divList">
    <div id="divVMYList"></div>

    <div id="divVMYListPaging"></div>
</div>
</body>
</html>