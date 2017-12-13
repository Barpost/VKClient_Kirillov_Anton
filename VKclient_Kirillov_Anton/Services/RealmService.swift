//
//  RealmService.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 09.11.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    static func replaceDataInRealm<T: Object>(toNewObjects objects: [T]) {
        do {
            let realm = try Realm()
            let oldObjects = realm.objects(T.self)
            try realm.write {
                realm.delete(oldObjects)
                realm.add(objects)
            }
        } catch {
            print(error)
        }
    }
    
    static func addDataToRealm<T: Object>(objects: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(objects)
            }
        } catch {
            print(error)
        }
    }
    
    static func deleteDataFromRealm<T: Object>(objects: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print(error)
        }
    }
}
