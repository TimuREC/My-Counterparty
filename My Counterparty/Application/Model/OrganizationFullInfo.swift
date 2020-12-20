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
            result += "Организация вызывает подозрение:"
        } else {
            return "Организация не вызывает подозрение"
        }
        
        if let _ = self.status {
            result += "\n\(self.status!)"
        }
        if let _ = self.address {
            result += "\n\(self.address!)"
        }
        if let _ = self.director {
            result += "\n\(self.director!)"
        }
        if let _ = self.owner {
            result += "\n\(self.owner!)"
        }
        if let _ = self.debt {
            result += "\n\(self.debt!)"
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
            self.address = "Сведения об адресе организации недостоверны"
        }
        
        if let dictionary = dict["СведДолжнФЛ"] as? [Any] {
            for i in dictionary {
                guard let tmp = i as? [String : Any] else { continue }
                if tmp.index(forKey: "СвНедДанДолжнФЛ") != nil {
                    self.director = "Сведения о руководителе организации недостоверны"
                }
            }
        }
        if let dictionary = dict["УчрФЛ"] as? [Any] {
            for i in dictionary {
                guard let tmp = i as? [String : Any] else { continue }
                if tmp.index(forKey: "СвНедДанУчр") != nil {
                    self.owner = "Сведения об учредителе организации недостоверны"
                }
            }
        }
        if let debt = dict["totalarrearsum"] as? Int {
            self.debt = "Задолженность по налогам составляет: \(debt) руб."
        }
    }
    
    init(_ organization: Organization) {
        self.name = organization.name!
        self.inn = organization.inn!
        self.status = organization.status!
        self.address = organization.address!
        self.director = organization.director!
        self.owner = organization.owner!
        self.debt = organization.debt!
        self.token = organization.token!
        self.pdf = organization.pdf
    }
    
    init() {
        name = "Произошла ошибка"
        inn = ""
    }
}
