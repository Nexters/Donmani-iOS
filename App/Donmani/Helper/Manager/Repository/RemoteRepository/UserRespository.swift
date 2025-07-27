//
//  UserRespository.swift
//  Donmani
//
//  Created by 문종식 on 7/27/25.
//

import DNetwork

actor UserRespository {
    let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
}
