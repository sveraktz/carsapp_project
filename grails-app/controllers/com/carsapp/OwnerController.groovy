package com.carsapp

import grails.converters.JSON

import java.sql.SQLException

class OwnerController {

    def carService

    def index() {
        render(view:"index")
    }

    def list() {
        render Owner.list() as JSON
    }

    def save() {
        def resp = [:]

        def owner

        if (params.int("id")) {
            owner = Owner.get(params.int("id"))
        } else {
            owner = new Owner()
        }

        owner.firstName = params.firstName
        owner.lastName = params.lastName
        owner.nationality = params.nationality
        owner.securityId = params.int("securityId")

        owner.validate()
        if(!owner.hasErrors()) {
            owner.save(flush: true)
            resp["message"] = "OK"
        } else {
            resp["message"] = "ERROR"

            resp["errors"] = owner.errors
        }
        render resp as JSON
    }

    def delete() {
        def resp = [:]
        def owner = Owner.get(params.int("id"))
        if (owner) {
            try {
                owner.delete(flush:true)
                resp["message"] = "OK"
            }catch (SQLException e) {
                resp["message"] = "ERROR"
            }
        } else {
            resp["message"] = "ERROR"
        }
        render resp as JSON
    }

    def carList() {
        def owner = Owner.get(params.int("id"))
        JSON.use('deep') {
            render carService.carsByOwner(owner) as JSON
        }
    }

    def carAvailableList() {
        JSON.use('deep') {
            render carService.carsAvailable() as JSON
        }
    }

    def removeCar() {
        def resp = [:]
        if(carService.removeOwnerFromCar(params.int("id"))) {
            resp["message"] = "OK"
        } else {
            resp["message"] = "ERROR"
        }
        render resp as JSON
    }

    def addCar() {
        def resp = [:]
        def owner = Owner.get(params.int("idOwner"));
        def car = Car.get(params.int("idCar"));
        owner.cars.add(car);
        car.owner = owner
        owner.validate()
        if(!owner.hasErrors()) {
            owner.save(flush: true)
            resp["message"] = "OK"
        } else {
            resp["message"] = "ERROR"

            resp["errors"] = owner.errors
        }
        render resp as JSON
    }
}
