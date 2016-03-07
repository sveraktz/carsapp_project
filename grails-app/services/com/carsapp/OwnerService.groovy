package com.carsapp

import grails.transaction.Transactional

@Transactional
class OwnerService {

    def serviceMethod() {

    }

    def findBySecurityId(Integer secId) {
        return Owner.findBySecurityId(secId)
    }
}
