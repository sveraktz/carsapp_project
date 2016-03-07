package com.carsapp

import grails.converters.JSON

class CarController {

    def vehicleModelYearService

    def ownerService

    def index() {
        def makes = []
        vehicleModelYearService.getAllMakes().each {make -> makes.add(make)}
        //println(makes as JSON)
        render(view:"index", model: ["makeList" : makes as JSON])
    }

    def listModel() {
        def models = []
        vehicleModelYearService.getAllModelByMake(params.makeSelected).each {model -> models.add(model)}
        render models as JSON
    }

    def listYear() {
        def years = []
        vehicleModelYearService.getAllYearByMakeModel(params.makeSelected, params.modelSelected).each {year -> years.add(year)}
        render years as JSON
    }

    def save() {
        def resp = [:]

        def car

        println("Se intenta guardar un Car id: " + params.int("id") + " secId: " + params.int("securityId") +
                " make: " +params.makeSelected + " model: " + params.modelSelected + " year: " + params.int('yearSelected')
        + " serialNum: " + params.int('serialNumber'))

        if (params.int("id")) {
            car = Car.get(params.int("id"))
        } else {
            car = new Car()
        }

        def ownerSecId = params.int("securityId")
        if (ownerSecId) {
            def ownerFound = ownerService.findBySecurityId(ownerSecId)
            if (ownerFound) {
                println("Owner found is : " + ownerFound)
                car.owner = ownerFound
            } else {
                //TODO: informar que no se encontro el owner
            }
        }

        def vmy = vehicleModelYearService.getVMY(params.makeSelected, params.modelSelected, params.int('yearSelected'))
        println("VMY found is : " + vmy)
        car.makeModelYear = vmy

        //LicensePlate.findByCar()
        //car.licensePlate = null

        car.serialNumber = params.int('serialNumber')

        car.validate()
        if(!car.hasErrors()) {
            car.save(flush: true)
            resp["message"] = "OK"
        } else {
            resp["message"] = "ERROR"

            resp["errors"] = car.errors
        }
        render resp as JSON
    }
}
