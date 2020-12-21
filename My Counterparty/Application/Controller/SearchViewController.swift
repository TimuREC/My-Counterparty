//
//  SearchViewController.swift
//  My Counterparty
//
//  Created by mono on 08.12.2020.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var organizations = [OrganizationInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        let organization = organizations[indexPath.row]
        cell.configure(with: organization)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "InformationView") as! InformationViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        let organization = self.organizations[indexPath.row]
        
        OrganizationNetworkService.getOrganizationInfo(for: organization) { (responce) in
            controller.info = responce.organization
            self.present(controller, animated: true)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            SearchNetworkService.getSearchResults(query: query) { (response) in
                self.organizations = response.organizations
                self.tableView.reloadData()
            }
        }
    }
    
}
