//
//  OrganizationFullInfo.swift
//  My Counterparty
//
//  Created by mono on 10.12.2020.
//

import Foundation

struct OrganizationFullInfo {
    var name: String
    var inn: String
    var status: String?
    var address: String?
    var director: String?
    var owner: String?
    var debt: String?
    var token: String?
    var pdf: String?
    var isGood: String {
        var result = ""
        if self.status != nil ||
            self.address != nil ||
            self.director != nil ||
            self.owner != nil {
            result += OrgInfo.badOrg.rawValue
        } else {
            return OrgInfo.goodOrg.rawValue
        }
        
        if let status = self.status {
            result += "\n\(status)"
        }
        if let address = self.address {
            result += "\n\(address)"
        }
        if let director = self.director {
            result += "\n\(director)"
        }
        if let owner = self.owner {
            result += "\n\(owner)"
        }
        if let debt = self.debt {
            result += "\n\(debt)"
        }
        return result
    }
    
    init?(dict: [String: Any], token: String, pdf: String) {
        
        guard let name = dict["НаимЮЛСокр"] as? String,
              let inn = dict["ИНН"] as? String
        else { return nil }
        
        self.name = name
        self.inn = inn
        self.token = token
        self.pdf = pdf
        
        if let status = dict["НаимСтатусЮЛСокр"] as? String {
            self.status = status
        }
        if (dict.index(forKey: "СвНедАдресЮЛ") != nil) {
            self.address = OrgInfo.address.rawValue
        }
        
        if let dictionary = dict["СведДолжнФЛ"] as? [Any] {
            for i in dictionary {
                guard let tmp = i as? [String : Any] else { continue }
                if tmp.index(forKey: "СвНедДанДолжнФЛ") != nil {
                    self.director = OrgInfo.director.rawValue
                }
            }
        }
        if let dictionary = dict["УчрФЛ"] as? [Any] {
            for i in dictionary {
                guard let tmp = i as? [String : Any] else { continue }
                if tmp.index(forKey: "СвНедДанУчр") != nil {
                    self.owner = OrgInfo.owner.rawValue
                }
            }
        }
        if let debt = dict["totalarrearsum"] as? Int {
            self.debt = OrgInfo.debt.rawValue + "\(debt) руб."
        }
    }
    
    init(_ organization: Organization) {
        self.init()
        if let name = organization.name,
           let inn = organization.inn,
           let status = organization.status,
           let address = organization.address,
           let director = organization.director,
           let owner = organization.owner,
           let debt = organization.debt,
           let token = organization.token,
           let pdf = organization.pdf {
            self.name = name
            self.inn = inn
            self.status = status
            self.address = address
            self.director = director
            self.owner = owner
            self.debt = debt
            self.token = token
            self.pdf = pdf
        }
        
        
        
    }
    
    init() {
        name = Errors.invalidData.rawValue
        inn = ""
    }
}
