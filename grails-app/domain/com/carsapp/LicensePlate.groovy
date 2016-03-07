package com.carsapp

class LicensePlate {

    String number

    static belongsTo = [car : Car]

    static constraints = {
        number maxSize: 6, nullable: false, blank: false, unique: true, matches: '[A-Z]{3}[0-9]{3}'
    }
}
