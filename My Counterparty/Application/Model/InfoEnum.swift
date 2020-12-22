//
//  InfoEnum.swift
//  My Counterparty
//
//  Created by Timur Begishev on 22.12.2020.
//

import Foundation

enum OrgInfo: String {
    case goodOrg = "Организация не вызывает подозрение"
    case badOrg = "Организация вызывает подозрение:"
    case address = "Сведения об адресе организации недостоверны"
    case director = "Сведения о руководителеsорганизации недостоверны"
    case owner = "Сведения об учредителе организации недостоверны"
    case debt = "Задолженность по налогам составляет: "
}
