//
//  DataManager.swift
//  RealmProject
//
//  Created by Rafa Asencio on 12/03/2020.
//  Copyright © 2020 Rafa Asencio. All rights reserved.
//

import Foundation
import UIKit

class DataManager {

var imageFile: String {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path.appending("/images")
}
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func save(image: UIImage, imageName: String) {
        let fileURL = documentsUrl.appendingPathComponent(imageName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
           try? imageData.write(to: fileURL, options: .atomic)
        } else {
            print("Error saving image")
        }
    }
    
    func load(imageName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(imageName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    func delete(imageName: String) {
        let fileURL = documentsUrl.appendingPathComponent(imageName)
        let filemanager = FileManager.default
        do {
            try filemanager.removeItem(at: fileURL)
        } catch  {
            print("Error deleting image")
        }
    }
    
}
