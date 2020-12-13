//
//  SearchCell.swift
//  My Counterparty
//
//  Created by mono on 08.12.2020.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var organizationId: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .white
    }
    
    func configure(with info: OrganizationInfo) {
        self.organizationName.text = info.name
        self.organizationId.text = info.inn
    }
    
    func configure(with info: Organization) {
        self.organizationName.text = info.name
        self.organizationId.text = info.inn
        if info.isGood!.contains("Организация вызывает подозрение:") {
            self.backgroundColor = .systemYellow
        }
    }
    
}
