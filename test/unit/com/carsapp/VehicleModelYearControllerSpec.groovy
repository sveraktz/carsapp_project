package com.carsapp

import grails.test.mixin.TestFor
import spock.lang.Specification
//import grails.plugin.springsecurity.SpringSecurityService
import grails.test.mixin.Mock

/**
 * See the API for {@link grails.test.mixin.web.ControllerUnitTestMixin} for usage instructions
 */
@TestFor(VehicleModelYearController)
@Mock (VehicleModelYear)
class VehicleModelYearControllerSpec extends Specification {

    void setupSpec() {
        //defineBeans {
            //Ensures springSecurityService bean is injected into User domain instances
            //springSecurityService(SpringSecurityService)
        //}
    }

    void "GET a list of vehicleModelYear as JSON"() {
        given: "A set of vehicleModelYear"
        initialiseVehicleModelYear()
        when: "I invoke the index action "
        controller.index()
        then: "I get the expected vehicleModelYear list as a JSON list"
        //Checks JSON response, where json property is map that replicates structure of JSON data
        response.json*.model.sort() == [
                "Fiesta",
                "Fiesta",
                "Fiesta",
                "Scirocco",
                "Trucker",
                "Trucker",
                "Trucker",
                "Vento",
                "Vento"]
    }

    void "GET a list of vehicleModelYear as XML"() {
        given: "A set of vehicleModelYear"
        initialiseVehicleModelYear()
        when: "I invoke the show action without an ID and requesting XML"
        response.format = "xml"
        controller.index()
        //Requests XML response (works with withFormat() method)
        then: "I get the expected vehicleModelYear as an XML document"
        //Checks XML response, using GPath syntax
        response.xml.vehicleModelYear.model*.text().sort() == [
                "Fiesta",
                "Fiesta",
                "Fiesta",
                "Scirocco",
                "Trucker",
                "Trucker",
                "Trucker",
                "Vento",
                "Vento"]
    }

    void "POST a single vehicleModelYear as JSON"() {
        given: "A set of existing vehicleModelYear"
        initialiseVehicleModelYear()
        when: "I invoke the save action with a JSON packet"
        //Passes JSON string as request content
        request.json = '{"year":"2016","make":"Ford","model":"A new Model"}'
               // + ',"id":' vehicleModelYearId + '}'
        controller.save()
        then: "I get a 201 JSON response with the ID of the new vehicleModelYear"
        //Tests HTTP status code of response; 201 indicates successful POST
        response.status == 201
        response.json.id != null
    }

    private static initialiseVehicleModelYear() {
        def ford2010 = new VehicleModelYear(year : 2010, make: "Ford", model : "Fiesta")
        def ford2011 = new VehicleModelYear(year : 2011, make: "Ford", model : "Fiesta")
        def ford2012 = new VehicleModelYear(year : 2012, make: "Ford", model : "Fiesta")
        def Chevy2010 = new VehicleModelYear(year : 2010, make: "Chevrolet", model : "Trucker")
        def Chevy2011 = new VehicleModelYear(year : 2011, make: "Chevrolet", model : "Trucker")
        def Chevy2012 = new VehicleModelYear(year : 2012, make: "Chevrolet", model : "Trucker")
        def VW2010 = new VehicleModelYear(year : 2010, make: "Volkswagen", model : "Vento")
        def VW2011 = new VehicleModelYear(year : 2011, make: "Volkswagen", model : "Vento")
        def VW2012 = new VehicleModelYear(year : 2012, make: "Volkswagen", model : "Scirocco")

        ford2010.save(failOnError: true)
        ford2011.save(failOnError: true)
        ford2012.save(failOnError: true)
        Chevy2010.save(failOnError: true)
        Chevy2011.save(failOnError: true)
        Chevy2012.save(failOnError: true)
        VW2010.save(failOnError: true)
        VW2011.save(failOnError: true)
        VW2012.save(failOnError: true, flush: true)
    }
}
