<%--
  Created by IntelliJ IDEA.
  User: sergio
  Date: 02/03/16
  Time: 12:55
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="myMain"/>
    <title>Cars</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var listMake = $.parseJSON('${makeList}'.replace(/&quot;/g, '"'))
            var sel = $("#makeForm")
            sel.html($("<option>").attr('value', "").text(""))
            $(listMake).each(function () {
                sel.append($("<option>").attr('value', this).text(this));
            });

            sel.on('change', function (e) {
                var makeSelected = this.value;
                if (makeSelected != "") {
                    getModelByMake(makeSelected)
                } else {
                    clearModelList()
                }
            })

            $("#modelForm").on('change', function (e) {
                var modelSelected = this.value;
                console.log("model selected " + modelSelected)
                if (modelSelected != "") {
                    var makeSelected = $("#makeForm").val()
                    getYearByMakeModel(makeSelected, modelSelected)
                } else {
                    clearYearList()
                }
            })

            $("#hasOwner").change(function () {
                if ($(this).is(":checked")) {
                    $("#ownerId").show()
                } else {
                    $("#ownerId").hide()
                    $("#ownerId input").val(null)
                }
            });

            $("#licensePlateForm").keyup(function (e) {
                var v = this.value;
                var value
                if (v.charAt(0).match('[a-zA-Z]')) {
                    value = v.charAt(0).toUpperCase()
                    if (v.charAt(1).match('[a-zA-Z]')) {
                        value = value + v.charAt(1).toUpperCase()
                        if (v.charAt(2).match('[a-zA-Z]')) {
                            value = value + v.charAt(2).toUpperCase() + "-"
                            if (v.charAt(4).match('[0-9]')) {
                                value = value + v.charAt(4)
                                if (v.charAt(5).match('[0-9]')) {
                                    value = value + v.charAt(5)
                                    if (v.charAt(6).match('[0-9]')) {
                                        value = value + v.charAt(6)
                                    }
                                }
                            }
                        }
                    }
                    this.value = value;
                } else {
                    this.value = ""
                }
            });

            carList();
        })

        function getModelByMake(make) {
            $.ajax({
                method: "GET",
                url: "listModel",
                data: {"makeSelected": make},
                success: function (data) {
                    var sel = $("#modelForm")
                    sel.html($("<option>").attr('value', "").text(""))
                    sel.prop('disabled', false)
                    $(data).each(function () {
                        sel.append($("<option>").attr('value', this).text(this));
                    });
                }
            })
        }

        $("#modelForm").on('change', function (e) {
            var modelSelected = this.value;

            console.log("el model selected is " + modelSelected)
            if (modelSelected != "") {
                var makeSelected = $("#makeForm").val()
                getYearByMakeModel(makeSelected, modelSelected)
            } else {
                clearYearList()
            }
        })

        function clearModelList() {
            var sel = $("#modelForm");
            sel.prop('disabled', true);
            sel.find('option')
                    .remove()
                    .end();
            clearYearList()
        }

        function getYearByMakeModel(make, model) {
            $.ajax({
                method: "GET",
                url: "listYear",
                data: {"makeSelected": make, "modelSelected": model},
                success: function (data) {
                    var sel = $("#yearForm");
                    sel.prop('disabled', false)
                    $(data).each(function () {
                        sel.append($("<option>").attr('value', this).text(this));
                    });
                }
            })
        }

        function clearYearList() {
            var sel = $("#yearForm");
            sel.prop('disabled', true);
            sel.find('option')
                    .remove()
                    .end();
        }

        function saveCar() {
            var make = $("#makeForm").val();
            var model = $("#modelForm").val();
            var year = $("#yearForm").val();
            var secId = $("#ownerSecIdForm").val();
            var serial = $("#serialNumberForm").val();

            if (serial != null && make != null && make != "" && model != null && model != "" && year != null) {
                $.ajax({
                    method: "POST",
                    url: "save",
                    data: {
                        "makeSelected": make, "modelSelected": model, "yearSelected": year, "securityId": secId,
                        "serialNumber": serial, "id": $("#idForm").val()
                    },
                    success: function (data) {
                        if (data.message == "OK") {
                            $("#formMessage").html("Car was saved successfully");
                            carList();
                        } else {
                            $("#formMessage").html("Can not be possible to save Car")

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
        }

        function carList() {
            $.ajax({
                method: "GET",
                url: "list",
                data: {},
                success: function (data) {
                    $("#divCarList > table > tbody").html("");
                    var table = $("#divCarList").children()
                    for (i in data) {
                        var car = data[i]
                        var license = car.licensePlate
                        var ownerSecId = car.owner == null ? "" : car.owner.securityId;
                        var licenseNumber = license == null ? "" : license.number;
                        var vmy = car.makeModelYear;
                        table.append(
                                "<tr id='car_id_" + car.id + "' onclick='updateCar(" + car.id + ")'><td>"
                                + car.serialNumber + "</td><td>" + vmy.make + "</td><td>" + vmy.model
                                + "</td><td>" + vmy.year + "</td><td>" + licenseNumber + "</td><td>"
                                + ownerSecId + "</td></tr>")


                    }
                }
            })
        }

        function updateCar(id) {

            $("#serialNumberForm").val($("#car_id_" + id + " td:eq(0)").text());
            var make =  $("#car_id_" + id + " td:eq(1)").text()
            var model = $("#car_id_" + id + " td:eq(2)").text()
            var year = $("#car_id_" + id + " td:eq(3)").text()
            $("#makeForm").val(make);
            getModelByMake(make);
            getYearByMakeModel(make, model);

            setTimeout(function(){$("#yearForm").val(year)},200);
            setTimeout(function(){$("#modelForm").val(model)},200);
            //
            $("#licensePlateForm").val($("#car_id_" + id + " td:eq(4)").text());
            $("#ownerSecIdForm").val($("#car_id_" + id + " td:eq(5)").text());

            $("#idCarForm").val(id);
            $("#mainFormButton").val("Edit");
            $("#divCarForm :input[name='cancel']").show();
            $("#divCarForm :input[name='delete']").show();
        }

        function cancelUpdate() {
            clearModelList()
            $("#licensePlateForm").val(null);
            $("#serialNumberForm").val(null);
            $("#ownerSecIdForm").val(null);
            $("#mainFormButton").val("Save");
            $("#divCarForm :input[name='cancel']").hide();
            $("#divCarForm :input[name='delete']").hide();
        }

        function deleteCar() {
            if (confirm("Are you sure you want to remove the selected Car?")) {
                $.ajax({
                    method: "POST",
                    url: "delete",
                    data: {
                        "id": $("#idCarForm").val()
                    },
                    success: function (data) {
                        if (data.message == "OK") {
                            cancelUpdate();
                            carList();
                        } else {
                            //TODO: <svera>: mostrar error
                        }
                    }
                })
            }
        }
    </script>
    <style type="text/css">
    #divCarForm {
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

    select {
        width: 60%;
    }
    </style>
</head>

<body>

<div id="divCarForm">
    <div id="formMessage"></div>


    <p><label for="makeForm">Make</label>
        <select id="makeForm" name="makeForm">
        </select></p>

    <p><label for="modelForm">Model</label>
        <select id="modelForm" name="modelForm" disabled="true">
        </select></p>

    <p><label for="yearForm">Year</label>
        <select id="yearForm" name="yearForm" disabled="true">
        </select></p>

    <p><label for="serialNumberForm">Serial Number</label>
        <input type="number" id="serialNumberForm" name="serialNumberForm"></p>

    <p><label for="licensePlateForm">License Plate</label>
        <input type="text" id="licensePlateForm" name="licensePlateForm" placeholder="AAA-999"
               maxlength="7"/></p>

    <p><label for="hasOwner">Has owner</label>
        <input type="checkbox" id="hasOwner" name="hasOwner">

    <div id="ownerId" style="display:none">
        <p><label for="ownerSecIdForm">Owner</label>
            <input type="number" id="ownerSecIdForm" name="ownerSecIdForm"
                   placeholder="<enter the security id>"/></p>
    </div>
    <input type="hidden" id="idCarForm" name="idCarForm"/>
    <input type="submit" id="mainFormButton" name="mainButton" value="Save" onclick="saveCar()">
    <input type="submit" name="delete" value="Delete" style="display: none" onclick="deleteCar()">
    <input type="submit" name="cancel" value="Cancel" style="display: none" onclick="cancelUpdate()">
</div>

<div id="divList">
    <div id="divCarList">
        <table>
            <thead>
            <th width='15%'>Serial</th>
            <th width='25%'>Make</th>
            <th width='25%'>Model</th>
            <th width='10%'>Year</th>
            <th width='10%'>Lic.Plate</th>
            <th width="15%">Owner Sec.Id</th>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>