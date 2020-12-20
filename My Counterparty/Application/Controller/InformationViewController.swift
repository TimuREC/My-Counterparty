//
//  InformationViewController.swift
//  My Counterparty
//
//  Created by mono on 08.12.2020.
//

import UIKit
import CoreData

class InformationViewController: UIViewController {

    @IBOutlet weak var organizationId: UINavigationItem!
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var organizationDescription: UITextView!
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var getPdfButton: UIButton!
    
    var organization: OrganizationInfo?
    var info = OrganizationFullInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        organizationId.title = info.inn
        organizationName.text = info.name
        if info.isGood.contains("Организация вызывает подозрение:") {
            organizationDescription.textColor = .red
        }
        if info.name == "Произошла ошибка" {
            organizationDescription.text = ""
            favButton.isEnabled = false
            getPdfButton.isEnabled = false
            getPdfButton.backgroundColor = .systemGray
        } else {
            favButton.isEnabled = true
            checkInBase(organization: info)
            organizationDescription.text = info.isGood
            getPdfButton.isEnabled = info.pdf!.isEmpty ? true : false
            getPdfButton.backgroundColor = info.pdf!.isEmpty ? .systemGray : .systemBlue
        }
        UIView.animate(withDuration: 0.3) {
            self.organizationName.isHidden = false
            self.organizationDescription.isHidden = false
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func checkInBase(organization: OrganizationFullInfo) {
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Organization> = Organization.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "inn == %@", organization.inn)
        if let objects = try? context.fetch(fetchRequest), objects.count > 0 {
            favButton.image = UIImage(systemName: "star.fill")
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        if favButton.image == UIImage(systemName: "star") {
            // Сохранение в оффлайн базу
            save(an: info)
            UIView.animate(withDuration: 0.3) { [weak self] in
                self!.favButton.image = UIImage(systemName: "star.fill")
            }
        } else {
            // Удаление из базы
            remove(an: info)
            UIView.animate(withDuration: 0.3) {
                self.favButton.image = UIImage(systemName: "star")
            }
        }
        
    }
    
    @IBAction func getPdf(_ sender: Any) {
        guard let url = URL(string: info.pdf!) else { return }
        guard let doc = try? Data.init(contentsOf: url) else { return }
        let shareController = UIActivityViewController(activityItems: [doc], applicationActivities: nil)

        present(shareController, animated: true, completion: nil)
    }
    
    // Сохранение в оффлайн базу
    private func save(an organization: OrganizationFullInfo) {
        guard organization.name != "Произошла ошибка" else { return }
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Organization", in: context) else { return }
        
        let orgObject = Organization(entity: entity, insertInto: context)
        orgObject.name = organization.name
        orgObject.inn = organization.inn
        orgObject.status = organization.status
        orgObject.address = organization.address
        orgObject.director = organization.director
        orgObject.owner = organization.owner
        orgObject.debt = organization.debt
        orgObject.isGood = organization.isGood
        orgObject.token = organization.token
        
        do {
            try context.save()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoriteVC") as! FavoriteViewController
            vc.viewDidLoad()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // Удаление из базы
    private func remove(an organization: OrganizationFullInfo) {
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Organization> = Organization.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "inn == %@", organization.inn)
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }

        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
}
