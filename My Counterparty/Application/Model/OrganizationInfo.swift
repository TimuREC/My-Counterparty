//
//  OrganizationInfo.swift
//  My Counterparty
//
//  Created by mono on 08.12.2020.
//

import Foundation

struct OrganizationInfo {
    var name: String
    var inn: String
    var token: String
    
    init?(dict: [String: Any]) {
        
        guard let name = dict["namec"] as? String,
              let inn = dict["inn"] as? String,
              let token = dict["token"] as? String
        else { return nil }
        
        self.name = name
        self.inn = inn
        self.token = token
    }
    
    init(_ organization: Organization) {
        self.init()
        if let name = organization.name,
           let inn = organization.inn,
           let token = organization.token {
            self.name = name
            self.inn = inn
            self.token = token
        }
    }
    
    init() {
        name = Errors.invalidData.rawValue
        inn = ""
        token = ""
    }
}
