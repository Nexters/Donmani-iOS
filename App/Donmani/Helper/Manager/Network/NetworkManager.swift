//
//  NetworkManager.swift
//  Donmani
//
//  Created by 문종식 on 2/13/25.
//

import Foundation
import DNetwork

final class NetworkManager {
    static var shared: NetworkManager
    
    let service: DNetworkService
    let dateManager: DateManager
    
    let userKey: String
    
    init(
        service: DNetworkService,
        dateManager: DateManager,
        key: String
    ) {
        self.service = service
        self.userKey = key
        Self.shared = self
    }
}
