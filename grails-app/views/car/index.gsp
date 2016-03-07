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
                console.log(v);
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
            })
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

        function saveOwner() {
            var make = $("#makeForm").val();
            var model = $("#modelForm").val();
            var year = $("#yearForm").val();
            var secId = $("#ownerSecId").val();
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
                            //cancelUpdate();
                            //listOwner();
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
        <p><label for="ownerSecId">Owner</label>
            <input type="number" id="ownerSecId" name="ownerSecId"
                   placeholder="<enter the security id>"/></p>
    </div>
    <input type="hidden" id="idForm" name="idForm"/>
    <input type="submit" id="mainFormButton" name="mainButton" value="Save" onclick="saveOwner()">
    <input type="submit" name="cancel" value="Cancel" style="display: none" onclick="cancelUpdate()">
</div>

</body>
</html>