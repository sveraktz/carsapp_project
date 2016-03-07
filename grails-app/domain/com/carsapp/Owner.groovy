package com.carsapp

class Owner {

    Integer securityId
    String firstName
    String lastName
    String nationality

    static hasMany = [ cars : Car]

    static constraints = {
        securityId nullable: false, blank: false, unique: true
        firstName nullable: false, blank: false
        lastName nullable: false, blank: false
        nationality nullable: false, blank: false
    }

    static mapping = {
        nationality DefaultValue: "'Argentinian'"
    }
}
