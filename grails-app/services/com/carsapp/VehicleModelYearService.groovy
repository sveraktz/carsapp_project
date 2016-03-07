package com.carsapp

import grails.transaction.Transactional

@Transactional
class VehicleModelYearService {


    def getAllMakes() {
        def result = VehicleModelYear.createCriteria().list {
            projections {
                distinct('make')
            }
        }

        return result
    }

    def getAllModelByMake(String aMaker) {
        def result = VehicleModelYear.createCriteria().list {
            eq('make', aMaker)
            projections {
                distinct('model')
            }
        }
        return result
    }

    def getAllYearByMakeModel(String aMaker, String aModel) {
        def result = VehicleModelYear.createCriteria().list {
            eq('make', aMaker)
            eq('model', aModel)
            projections {
                property('year')
            }
        }
        return result
    }

    def getVMY(String aMaker, String aModel, Integer aYear ) {
        def result = VehicleModelYear.findByMakeAndModelAndYear(aMaker, aModel, aYear)
        return result
    }
}
