package com.carsapp

import grails.converters.JSON

//import grails.rest.RestfulController

//class VehicleModelYearController extends RestfulController {
class VehicleModelYearController {

    static final def maxRowNum = 15

    def index() {
        render(view:"index")
    }

    def save() {
        def resp = [:]
        def vmyNew = new VehicleModelYear()
        vmyNew.make = params.make
        vmyNew.model = params.model
        vmyNew.year = params.year

        vmyNew.validate()
        if(!vmyNew.hasErrors()) {
            vmyNew.save()
            resp["message"] = "OK"
        } else {
            resp["message"] = "ERROR"
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

//    static responseFormats = ["json", "xml"]
//
//    VehicleModelYearController() {
//        super(VehicleModelYear)
//    }
}
