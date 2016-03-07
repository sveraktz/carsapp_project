package com.carsapp

import grails.transaction.Transactional

@Transactional
class CarService {

    def serviceMethod() {

    }

    def carsAvailable() {
        return Car.createCriteria().list {
            isNull('owner')
        }
    }

    def carsByOwner(Owner owner) {
        return Car.findAllByOwner(owner)
    }

    def removeOwnerFromCar(Integer carId) {
        def aCar = Car.get(carId)
        aCar.owner = null
        aCar.validate()
        if(!aCar.hasErrors()) {
            return true
        } else {
            return false
        }
    }
}
