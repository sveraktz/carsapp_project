package com.carsapp

class VehicleModelYear {
    Integer id
    Integer year
    String make
    String model

    static constraints = {
        year blank:false, nullable:false, min:1800, max:9999, unique: ['make', 'model']
        model blank:false, nullable:false, maxSize:50
        make maxSize:50
    }

    static mapping = {
        table "VehicleModelYear"
        version false
    }
}
