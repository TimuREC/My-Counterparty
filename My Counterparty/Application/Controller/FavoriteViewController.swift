//
//  FavoriteViewController.swift
//  My Counterparty
//
//  Created by mono on 08.12.2020.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var organizations: [Organization] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Organization> = Organization.fetchRequest()
        
        do {
            organizations = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        print("downloading info")
        // Оптимизировать передачу данных между контроллерами
        OrganizationNetworkService.getOrganizationInfo(for: OrganizationInfo(organization)) { (responce) in
            if responce.organization.name == "Произошла ошибка" {
                controller.info = OrganizationFullInfo(organization)
            } else {
                controller.info = responce.organization
            }
            controller.viewDidLoad()
        }
        
        present(controller, animated: true)
    }
    
    
}
