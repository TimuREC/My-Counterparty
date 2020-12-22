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
    @IBOutlet weak var noResultsLabel: UILabel!
    
    var organizations = [OrganizationInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.tableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        self.tableView.contentInset = contentInset
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
        searchBar.resignFirstResponder()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "InformationView") as! InformationViewController
        controller.modalPresentationStyle = .automatic
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
        self.noResultsLabel.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.noResultsLabel.isHidden = true
        SearchNetworkService.getSearchResults(query: query) { (response) in
            if response.organizations.isEmpty {
                self.organizations = []
                self.noResultsLabel.isHidden.toggle()
            } else {
                self.organizations = response.organizations
            }
            self.tableView.reloadData()
        }
    }
    
}
