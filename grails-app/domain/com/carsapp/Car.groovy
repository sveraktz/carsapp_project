package com.carsapp

class Car {

    Long serialNumber

    VehicleModelYear makeModelYear

    Owner owner

    static hasOne = [licensePlate : LicensePlate]

    static constraints = {
        serialNumber nullable: false, blank: false, unique: true
        makeModelYear nullable: false
        licensePlate nullable: true
        owner nullable: true
    }
}
