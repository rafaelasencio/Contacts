//
//  ContactViewController.swift
//  RealmProject
//
//  Created by Rafa Asencio on 11/03/2020.
//  Copyright © 2020 Rafa Asencio. All rights reserved.
//

import UIKit
import RealmSwift

class ContactViewController: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtJob: UITextField!
    @IBOutlet weak var btnAction: UIButton!
    
    var selectedContact: User?
    var imagePickedURL: String = ""
    let datamanager = DataManager()
    let picker = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileImageButtonTapped))
        profileImg.isUserInteractionEnabled = true
        profileImg.addGestureRecognizer(gesture)
        profileImg.layer.cornerRadius = profileImg.bounds.width / 2
    }
    
    @objc func profileImageButtonTapped(){
        showImagePickerControllerActionSheet()
    }
    
    func existUserToUpdate() -> Bool {
        return selectedContact != nil ? true : false
    }
    
    @IBAction func btnRegisterContact(_ sender: Any) {
        guard let name = txtName.text, let job = txtJob.text, let age = Int(txtAge.text!) else {
            let alert = UIAlertController(title: "Invalid data input", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if existUserToUpdate() {
            if selectedContact?.profileImage != imagePickedURL {
                datamanager.delete(imageName: selectedContact!.profileImage)
                datamanager.save(image: profileImg.image!, imageName: imagePickedURL)
            }
            let dict: [String:Any?] = ["name": name, "age": age, "job":job, "profileImage": imagePickedURL]
            RealmService.shared.update(object: selectedContact!, with: dict)
        } else {
            let newContact = User.init(name: name, age: age, job: job, img: imagePickedURL )
            datamanager.save(image: profileImg.image!, imageName: imagePickedURL)
            RealmService.shared.create(object: newContact)
        }
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension ContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet(){
        let alert = UIAlertController(title: "Choose your image", message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let photoCameraAction = UIAlertAction(title: "Pick from camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(photoLibraryAction)
        alert.addAction(photoCameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true //zooming..
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[.imageURL] as! URL
        let imageName = imageURL.lastPathComponent
        
        imagePickedURL = imageName
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImg.image = editedImage

        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImg.image = originalImage
        }
        //dataManager.save(image: profileImg.image!, imageName: imageName)
        dismiss(animated: true, completion: nil)
    }
    
}


