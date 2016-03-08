<%--
  Created by IntelliJ IDEA.
  User: sergio
  Date: 04/03/16
  Time: 09:40
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="myMain"/>
    <title>Cars</title>
    <style type="text/css">

    input[type=number]::-webkit-outer-spin-button,
    input[type=number]::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }

    input[type=number] {
        -moz-appearance: textfield;
    }

    #divLeftPanel {

        float: left;
        border: 3px solid #255b17;
        margin: 4px;
    }

    p {
        margin: 5px;
    }

    p > label {
        width: 25%;
        display: inline-block;
        float: left;
        clear: left;

        text-align: right;
    }

    #divList {
        width: 60%;
        float: right;
        border: 3px solid #255b17;
        margin: 4px;
    }

    #divOwnerList > table {
        display: block;
        height: 500px;
        overflow-y: scroll;
    }

    input[type=submit] {
        min-width: 80px;
        background: #abbf78;
    }

    #divOwnerForm {
        float: left;
        height: 180px;
        width: 320px;
    }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            listOwner();

            $('#filterOwnerList > input').keyup(function () {
                filter()
            });
        })

        function listOwner() {
            $.ajax({
                method: "GET",
                url: "list",
                data: {},
                success: function (data) {
                    $("#divOwnerList > table > tbody").html("");
                    var table = $("#divOwnerList").children()
                    for (i in data) {
                        var owner = data[i]
                        table.append(
                                "<tr id='owner_id_" + owner.id + "' onclick='updateOwner(" + owner.id + ")'><td>"
                                + owner.securityId + "</td><td>" + owner.firstName + "</td><td>" + owner.lastName
                                + "</td><td>" + owner.nationality + "</td></tr>")
                    }
                }
            })
        }

        function saveOwner() {
            $.ajax({
                method: "POST",
                url: "save",
                data: {
                    "firstName": $("#firstNameForm").val(),
                    "lastName": $("#lastNameForm").val(),
                    "nationality": $("#nationalityForm").val(),
                    "securityId": $("#securityIdForm").val(),
                    "id": $("#idOwnerForm").val()
                },
                success: function (data) {
                    if (data.message == "OK") {
                        $("#formMessage").html("Owner was saved successfully");
                        cancelUpdate();
                        listOwner();
                    } else {
                        $("#formMessage").html("Can not be possible to save Owner")

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

        function updateOwner(id) {
            $("#securityIdForm").val($("#owner_id_" + id + " td:eq(0)").text());
            $("#firstNameForm").val($("#owner_id_" + id + " td:eq(1)").text());
            $("#lastNameForm").val($("#owner_id_" + id + " td:eq(2)").text());
            $("#nationalityForm").val($("#owner_id_" + id + " td:eq(3)").text());
            $("#idOwnerForm").val(id);
            $("#mainFormButton").val("Edit");
            $("#divOwnerForm :input[name='cancel']").show();
            $("#divOwnerForm :input[name='delete']").show();

            $("#divList").hide();

            loadCarOwnerList(id)
        }

        function cancelUpdate() {
            $("#divOwnerForm :input[name*='Form']").val(null);
            $("#mainFormButton").val("Save");
            $("#divOwnerForm :input[name='cancel']").hide();
            $("#divOwnerForm :input[name='delete']").hide();

            $("#divCarList").hide()
            $("#divCarOwnerList > table > tbody").html("");
            $("#carAvailableList > table > tbody").html("");
            $("#carAvailable").hide();

            $("#divList").show();
        }

        function deleteOwner() {
            if (confirm("Are you sure you want to remove the selected Owner?")) {
                $.ajax({
                    method: "POST",
                    url: "delete",
                    data: {
                        "id": $("#idOwnerForm").val()
                    },
                    success: function (data) {
                        if (data.message == "OK") {
                            cancelUpdate();
                            listOwner();
                        } else {
                            //TODO: <svera>: mostrar error
                        }
                    }
                })
            }
        }

        function filter() {
            var secId = $("#securityIdFilter").val();
            var name = $("#nameFilter").val()
            var nation = $("#nationalityFilter").val()
            $("#divOwnerList > table > tbody > tr").each(function () {
                if (($(this).children().slice(0, 1).text().indexOf(secId) > -1) &&
                        ($(this).children().slice(1, 3).text().indexOf(name) > -1) &&
                        ($(this).children().slice(3, 4).text().indexOf(nation) > -1)) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }

        function loadCarOwnerList(id) {
            $.ajax({
                method: "GET",
                url: "carList",
                data: {
                    "id": id
                },
                success: function (data) {
                    $("#divCarOwnerList > table > tbody").html("");
                    var table = $("#divCarOwnerList").children()
                    for (i in data) {
                        var car = data[i]
                        var license = car.licensePlate
                        var licenseNumber = license == null ? "" : license.number;
                        var vmy = car.makeModelYear;
                        table.append(
                                "<tr id='own_car_id_" + car.id + "'><td>" + car.serialNumber + "</td><td>"
                                + vmy.make + "</td><td>" + vmy.model + "</td><td>" + vmy.year + "</td><td>"
                                + licenseNumber + "</td>" +
                                "<td><input type='button' value='Remove' onclick='removeCar(" + car.id + ")' /></td></tr>")
                    }
                }
            })

            $("#divCarList").show()
        }

        function showCarsAvailable() {
            $.ajax({
                method: "GET",
                url: "carAvailableList",
                data: {},
                success: function (data) {
                    $("#carAvailableList > table > tbody").html("");
                    var table = $("#carAvailableList").children()
                    if (data != "[]") {
                        for (i in data) {
                            var car = data[i]
                            var license = car.licensePlate
                            var licenseNumber = license == null ? "" : license.number;
                            var vmy = car.makeModelYear;
                            table.append(
                                    "<tr id='own_car_id_" + car.id + "'><td>" + car.serialNumber + "</td><td>"
                                    + vmy.make + "</td><td>" + vmy.model + "</td><td>" + vmy.year + "</td><td>"
                                    + licenseNumber + "</td>" +
                                    "<td><input type='button' value='Add' onclick='addCar(" + car.id + ")' /></td></tr>")


                        }
                        $("#carAvailable").show()
                    } else {
                        //TODO: informar no hay cars available
                    }
                }
            })
        }

        function removeCar(id) {
            if(confirm("Are you sure that you want to remove this car from this owner?")) {
                $.ajax({
                    method: "POST",
                    url: "removeCar",
                    data: {"id" : id},
                    success: function (data) {
                        console.log(data)

                        if (data.message == "OK") {
                            refreshCarList()
                        } else {
                            //TODO: <svera>: mostrar error
                        }
                    }
                })
            }
        }

        function addCar(idCar) {
            if(confirm("Are you sure that you want to add this car to this owner?")) {
                var ownerId = $("#idOwnerForm").val();
                $.ajax({
                    method: "POST",
                    url: "addCar",
                    data: {"idCar" : idCar, "idOwner": ownerId },
                    success: function (data) {
                        if (data.message == "OK") {
                            refreshCarList()
                        } else {
                            $("#formMessage").html("Can not be possible add this car to this Owner")

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

        function refreshCarList() {
            var ownerId = $("#idOwnerForm").val()
            $("#carAvailableList > table > tbody").html("");
            $("#carAvailable").hide();
            loadCarOwnerList(ownerId);
        }
    </script>
</head>

<body>
<div id="divLeftPanel">
    <div id="divOwnerForm">
        <div id="formMessage"></div>

        <p><label for="securityIdForm">Security ID</label>
            <input type="number" id="securityIdForm" name="securityIdForm"/></p>

        <p><label for="firstNameForm">First Name</label>
            <input type="text" id="firstNameForm" name="firstNameForm"/></p>

        <p><label for="lastNameForm">Last Name</label>
            <input type="text" id="lastNameForm" name="lastNameForm"/></p>

        <p><label for="nationalityForm">Nationality</label>
            <input id="nationalityForm" type="text" name="nationalityForm"/></p>

        <div style="text-align: center; margin-top: 10px">
            <input type="hidden" id="idOwnerForm" name="idOwnerForm"/>
            <input type="submit" name="delete" value="Delete" style="display: none" onclick="deleteOwner()">
            <input type="submit" id="mainFormButton" name="mainButton" value="Save" onclick="saveOwner()">
            <input type="submit" name="cancel" value="Cancel" style="display: none" onclick="cancelUpdate()">
        </div>
    </div>

    <div id="divCarList" style="display: none; float: right; width: 60%">
        <div id="divCarOwnerList">
            <table>
                <thead>
                <th width='15%'>Serial</th>
                <th width='25%'>Make</th>
                <th width='25%'>Model</th>
                <th width='10%'>Year</th>
                <th width='10%'>Lic.Plate</th>
                <th width="10%"></th>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>

        <div style="text-align: center; margin-top: 10px">
            <input type="submit" name="showCarsAvailable" value="Show Cars Available" onclick="showCarsAvailable()">
        </div>

        <div id="carAvailable" style="display: none;">
            <div id="filterCarsAvilableList">
                <label>Filters</label><br/>
                <input style="width: 15%" type="number" id="serialFilter" name="serialFilter"
                       placeholder="<serial>">
                <input style="width: 40%" type="text" id="makeFilter" name="makeFilter" placeholder="<make/model>">
                <input style="width: 10%" type="text" id="yearFilter" name="yearFilter"
                       placeholder="<year>">
                <input style="width: 20%" type="text" id="lisPlateFilter" name="lisPlateFilter"
                       placeholder="<lisence Plate>">
            </div>

            <div id="carAvailableList">
                <table>
                    <tbody>

                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="divList">
    <div id="filterOwnerList">
        <label>Filters</label><br/>
        <input style="width: 15%" type="number" id="securityIdFilter" name="securityIdFilter"
               placeholder="<securityId>">
        <input style="width: 50%" type="text" id="nameFilter" name="nameFilter" placeholder="<name>">
        <input style="width: 20%" type="text" id="nationalityFilter" name="nationalityFilter"
               placeholder="<nationality>">
    </div>

    <div id="divOwnerList">
        <table>
            <thead>
            <th width='15%'>SecurityID</th>
            <th width='40%'>First Name</th>
            <th width='25%'>Last Name</th>
            <th width='20%'>Nationality</th>
            </thead>
            <tbody>

            </tbody>
        </table>
    </div>
</div>
</body>
</html>