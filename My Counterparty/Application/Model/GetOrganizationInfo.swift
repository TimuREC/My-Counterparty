//
//  GetOrganizationInfo.swift
//  My Counterparty
//
//  Created by mono on 10.12.2020.
//

import Foundation

struct GetOrganizationInfo {
    let organization: OrganizationFullInfo
    
    init(json: Any) throws {
        var organization: OrganizationFullInfo?
        
        if let full = json as? [String: Any] {

            if let dictionary = full["vyp"] as? [String : Any],
               let token = full["token"] as? String {
                organization = OrganizationFullInfo(dict: dictionary, token: token)
            } else if let _ = full["ERROR"] {
                print("Error: Query limit exceed")
            }

        }
        self.organization = organization ?? OrganizationFullInfo()
    }

}

