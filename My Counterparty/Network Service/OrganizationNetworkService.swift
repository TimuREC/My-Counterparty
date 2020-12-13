//
//  OrganizationNetworkService.swift
//  My Counterparty
//
//  Created by mono on 10.12.2020.
//

import Foundation

class OrganizationNetworkService {
    private init() {}
    
    static func getOrganizationInfo(for organization: OrganizationInfo, completion: @escaping(GetOrganizationInfo) -> Void) {
        
        guard let url = URL(string: "https://pb.nalog.ru/company-proc.json?token=\(organization.token)") else { return }
        
        NetworkService.shared.getData(url: url) { (json) in
            do {
                let response = try GetOrganizationInfo(json: json)
                completion(response)
            } catch {
                print(error)
            }
        }
    }
}
