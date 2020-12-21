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
        
        OrganizationNetworkService.getOrganizationInfo(for: OrganizationInfo(organization)) { (responce) in
            if responce.organization.name == "Произошла ошибка" {
                controller.info = OrganizationFullInfo(organization)
            } else {
                controller.info = responce.organization
            }
            self.present(controller, animated: true)
        }
        
    }
    
    // Удаление из избранного по свайпу
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let remove = removeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [remove])
    }
    
    private func removeAction(at indexPath: IndexPath) -> UIContextualAction {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let organization = self.organizations[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let fetchRequest: NSFetchRequest<Organization> = Organization.fetchRequest()
            
            guard let inn = organization.inn else { return }
            fetchRequest.predicate = NSPredicate(format: "inn == %@", inn)
            
            if let objects = try? context.fetch(fetchRequest) {
                for object in objects {
                    context.delete(object)
                }
            }
            
            do {
                try context.save()
                self.organizations.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            completion(true)
        }
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: "delete.left")
        return action
    }
    
}
