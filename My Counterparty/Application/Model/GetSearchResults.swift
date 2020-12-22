//
//  GetSearchResults.swift
//  My Counterparty
//
//  Created by mono on 08.12.2020.
//

import Foundation

struct GetSearchResults {
    let organizations: [OrganizationInfo]
    
    init(json: Any) throws {
        var organizations = [OrganizationInfo]()
        
        if let full = json as? [String: Any] {
            if let infoDict = full["ul"] as? [String: Any] {
                if let data = infoDict["data"] as? [[String: Any]] {
                    for dictionary in data {
                        guard let organization = OrganizationInfo(dict: dictionary) else { continue }
                        organizations.append(organization)
                    }
                }
            } else if let _ = full["ERROR"] {
                print("Error: \(Errors.queryLimit.rawValue)")
            }
        }

        self.organizations = organizations
    }
}
