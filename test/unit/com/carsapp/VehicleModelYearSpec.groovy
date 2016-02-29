package com.carsapp

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.domain.DomainClassUnitTestMixin} for usage instructions
 */
@TestFor(VehicleModelYear)
class VehicleModelYearSpec extends Specification {

    def "Saving our first vehicleModelYear to the database"() {
        given: "A brand new vehicleModelYear"
        def ford2010 = new VehicleModelYear(year : 2010, make: "Ford", model : "Fiesta")

        when: "the vehicleModelYear is saved"
        ford2010.save()

        then: "it saved successfully and can be found in the database"
        ford2010.errors.errorCount == 0
        ford2010.id != null
        VehicleModelYear.get(ford2010.id).id == ford2010.id
    }

    def "Updating a saved vehicleModelYear changes its properties"() {
        given: "An existing vehicleModelYear"
        def existingFord2010 = new VehicleModelYear(year : 2010, make: "Ford", model : "Fiesta")
        existingFord2010.save(failOnError: true)
        when: "A property is changed"
        def foundFord2010 = VehicleModelYear.get(existingFord2010.id)
        foundFord2010.model = 'Fiesta Kinectic'
        foundFord2010.save(failOnError: true)

        then: "The change is reflected in the database"
        VehicleModelYear.get(existingFord2010.id).model == 'Fiesta Kinectic'
    }

    def "Deleting an existing vehicleModelYear removes it from the database"() {
        given: "An existing vehicleModelYear"
        def existingFord2010 = new VehicleModelYear(year : 2010, make: "Ford", model : "Fiesta")
        existingFord2010.save(failOnError: true)
        when: "The vehicleModelYear is deleted"
        def foundFord2010 = VehicleModelYear.get(existingFord2010.id)
        foundFord2010.delete(flush: true)
        then: "The vehicleModelYear is removed from the database"
        !VehicleModelYear.exists(foundFord2010.id)
    }

    def "Saving a vehicleModelYear with invalid properties causes an error"() {
        given: "A vehicleModelYear which fails several field validations"
        def ford2010 = new VehicleModelYear(year : 20103, make: "Ford", model : "Fiesta")
        when: "The vehicleModelYear is validated"
        ford2010.validate()
        then:
        ford2010.hasErrors()
        "max.exceeded" == ford2010.errors.getFieldError("year").code
        //!ford2010.errors.getFieldError("make")
        //!ford2010.errors.getFieldError("model")
    }

    def "Recovering from a failed save by fixing invalid properties"() {
        given: "A vehicleModelYear that has invalid properties"
        def ford2010 = new VehicleModelYear(year : 20103, make: "Ford", model : "Fiesta")
        assert ford2010.save() == null
        assert ford2010.hasErrors()
        when: "We fix the invalid properties"
        ford2010.year = 2010
        ford2010.validate()
        then: "The vehicleModelYear saves and validates fine"
        !ford2010.hasErrors()
        ford2010.save()
    }
}
