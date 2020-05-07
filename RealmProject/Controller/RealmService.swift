//
//  RealmService.swift
//  RealmProject
//
//  Created by Rafa Asencio on 11/03/2020.
//  Copyright © 2020 Rafa Asencio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init(){}
    static let shared = RealmService()
    var realm = try! Realm()
    
    //we can pass any subclass object of RealmSwift <T: Object>
    func create<T: Object>(object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error: error)
        }
    }
    
    func update<T: Object>(object: T, with dictionary: [String:Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error: error)
        }
    }
    
    func delete<T: Object>(object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error: error)
        }
    }
    
    //To post errors insteand of use do catch on each function
    func post(error: Error){
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    //To observe Realms Error
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController){
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
}
