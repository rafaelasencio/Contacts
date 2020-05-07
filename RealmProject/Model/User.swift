//
//  Cat.swift
//  RealmProject
//
//  Created by Rafa Asencio on 10/03/2020.
//  Copyright © 2020 Rafa Asencio. All rights reserved.
//

import UIKit
import RealmSwift

class User: Object {
    
    @objc dynamic var profileImage: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var job: String = ""
    
    convenience init(name: String, age: Int, job: String, img: String) {
        self.init()
        self.name = name
        self.age = age
        self.job = job
        self.profileImage = img
    }
    
    
}
