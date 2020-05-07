//
//  ViewController.swift
//  RealmProject
//
//  Created by Rafa Asencio on 10/03/2020.
//  Copyright © 2020 Rafa Asencio. All rights reserved.
//

import UIKit
import RealmSwift

class ContactListViewController: UITableViewController {

    var users: Results<User>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        let realm = RealmService.shared.realm
        users = realm.objects(User.self)
        
        notificationToken = realm.observe { (notification, realm) in
            self.tableView.reloadData() //refresh data on any changes in Realm DB
        }
        
        RealmService.shared.observeRealmErrors(in: self) { (error) in
            print(error ?? "No erros detected")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate() //not reaload every time is leaving the controller
        RealmService.shared.stopObservingErrors(in: self)
    }
    
    @IBAction func addUser(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewContactViewController")
        self.present(vc, animated: true, completion: nil)
    }


}

extension ContactListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        cell.textLabel?.text = users![indexPath.row].name
        cell.detailTextLabel?.text = "\(users![indexPath.row].age)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contact = users[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewContactViewController") as! ContactViewController
        DispatchQueue.main.async {
            vc.txtName.text = contact.name
            vc.txtAge.text = String(contact.age)
            vc.txtJob.text = contact.job
            vc.btnAction.setTitle("Update", for: .normal)
            let datamanager = DataManager()
            
            vc.profileImg.load(url: datamanager.documentsUrl.appendingPathComponent(contact.profileImage))
            print(URL(fileURLWithPath: "\(datamanager.documentsUrl)\(contact.profileImage)"))
            print(datamanager.documentsUrl)
            print(datamanager.documentsUrl.absoluteString)
            print(datamanager.documentsUrl.absoluteURL)
            print(datamanager.documentsUrl.appendingPathComponent(contact.profileImage))
            vc.selectedContact = contact
        }
        
        self.present(vc, animated: true, completion: nil)
        vc.btnAction.setTitle("Register", for: .normal)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        let contact = users[indexPath.row]
        let datamanager = DataManager()
        datamanager.delete(imageName: contact.profileImage)
        RealmService.shared.delete(object: contact)
    }
}

extension UIImageView {
    func load(url: URL){
        DispatchQueue.global().async {[weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}




