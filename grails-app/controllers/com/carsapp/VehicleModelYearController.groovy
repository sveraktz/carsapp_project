package com.carsapp

import grails.converters.JSON

import java.sql.SQLException

class VehicleModelYearController {

    static final def maxRowNum = 15

    def index() {
        render(view:"index")
    }

    def save() {
        def resp = [:]

        def vmy

        if (params.int("id")) {
            vmy = VehicleModelYear.get(params.int("id"))
        } else {
            vmy = new VehicleModelYear()
        }
        vmy.make = params.make
        vmy.model = params.model
        vmy.year = params.int("year")

        vmy.validate()
        if(!vmy.hasErrors()) {
            vmy.save(flush: true)
            resp["message"] = "OK"
        } else {
            resp["message"] = "ERROR"

            resp["errors"] = vmy.errors
        }
        render resp as JSON
    }

    def list() {
        def resp = [:]
        def selectedPageNum = params.int('selectedPageNum')
        def makeFilter = params.makeFilter
        def modelFilter = params.modelFilter
        def minYearFilter = params.int("minYearFilter")
        def maxYearFilter = params.int("maxYearFilter")

        def offset = (selectedPageNum - 1) * maxRowNum
        println("min year value: " + minYearFilter + " max : " + maxYearFilter)
        def maxPageNum = (VehicleModelYear.where {
            if (makeFilter) {
                make =~ "%${makeFilter}%"
            }
            if (modelFilter) {
                model =~ "%${modelFilter}%"
            }
            if (minYearFilter && maxYearFilter) {
                year in minYearFilter .. maxYearFilter
            }
        }.count().intdiv(maxRowNum)) + 1
        def vehicleModelYearList = VehicleModelYear.where {
            if (makeFilter) {
                make =~ "%${makeFilter}%"
            }
            if (modelFilter) {
                model =~ "%${modelFilter}%"
            }
            if (minYearFilter && maxYearFilter) {
                year in minYearFilter .. maxYearFilter
            }
        }.list(max: maxRowNum, offset: offset, sort: "make", order: "asc")

        resp["maxPageNum"] = maxPageNum
        resp["vmyList"] = vehicleModelYearList

        render resp as JSON
    }

    def delete() {
        println("se entro para borrar el VMY con id: "+ params.int("id"))
        def resp = [:]
        def vmy = VehicleModelYear.get(params.int("id"))
        if (vmy) {
            try {
                vmy.delete(flush:true)
                resp["message"] = "OK"
            }catch (SQLException e) {
                resp["message"] = "ERROR"
            }
        } else {
            resp["message"] = "ERROR"
        }
        render resp as JSON
    }
}
