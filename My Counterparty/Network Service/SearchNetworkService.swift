//
//  SearchNetworkService.swift
//  My Counterparty
//
//  Created by mono on 08.12.2020.
//

import Foundation

class SearchNetworkService {
    private init() {}
    
    static func getSearchResults(query: String, completion: @escaping(GetSearchResults) -> Void) {
        guard let url = URL(string: "https://pb.nalog.ru/search-proc.json?page=1&pageSize=10&pbCaptchaToken=&token=&mode=search-ul&queryAll=&queryUl=\(query)&okvedUl=&statusUl=&regionUl=&isMspUl=&queryIp=&okvedIp=&statusIp=&regionIp=&isMspIp=&mspIp1=1&mspIp2=2&mspIp3=3&queryUpr=&uprType1=1&uprType0=1&queryRdl=&dateRdl=&queryAddr=&regionAddr=&queryOgr=&ogrFl=1&ogrUl=1&npTypeDoc=1&ogrnUlDoc=&ogrnIpDoc=&nameUlDoc=&nameIpDoc=&formUlDoc=&formIpDoc=&ifnsDoc=&dateFromDoc=&dateToDoc=") else { return }
        
        NetworkService.shared.getData(url: url) { (json) in
            do {
                let response = try GetSearchResults(json: json)
                completion(response)
            } catch {
                print(error)
            }
        }
    }

}
