//
//  KAItem.swift
//  bitspls
//
//  Created by Leonard Mehlig on 06/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import Argo
import Curry
import RealmSwift


class KARealmItem: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var descriptionText: String = ""
    dynamic var city: String = ""
    dynamic var email: String = ""
    dynamic var phone: String = ""
    dynamic var image: String? = ""
    dynamic var timestamp: String = ""
    dynamic var categoryNumber: Int = 1

    override static func primaryKey() -> String? {
        return "id"
    }
    
    var item: KAItem {
        get {
            return KAItem(id: id, title: title, description: descriptionText, city: city, email: email, phone: phone, image: image, timestamp: timestamp, categoryNumber: categoryNumber)
        }
        set (i) {
            id = i.id
            title = i.title
            descriptionText = i.description
            city = i.city
            email = i.email
            phone = i.phone
            image = i.image
            timestamp = i.timestamp
            categoryNumber = i.categoryNumber
        }
    }
}

struct KAItem {
    let id: Int
    let title: String
    let description: String
    let city: String
    let email: String
    let phone: String
    let image: String?
    let timestamp: String
    let categoryNumber: Int
    
    var imageURL: NSURL? {
        return self.image.flatMap { NSURL(string: $0) }
    }
    
    var phoneURL: NSURL? {
        let str = phone.stringByRemovingPercentEncoding?.stringByReplacingOccurrencesOfString(" ", withString: "")
        return str.flatMap {  NSURL(string: "tel://" + $0) }
    }
    
    var category: Category {
        return Category(rawValue: categoryNumber) ?? .Sonstiges
    }
    
    private static let dateFormatter = NSDateFormatter()

    var date: NSDate {
        return KAItem.dateFormatter.dateFromString(self.timestamp) ?? NSDate()
    }
    
    enum Category: Int {
        case Elektronik = 1
        case Spielzeuge = 2
        case Kleidung = 3
        case Möbel = 4
        case Sonstiges = 5
        
        static let Strings: [String] = ["Elektronik", "Spielzeuge", "Kleidung", "Möbel", "Sonstiges"]

    }
}

extension KAItem: Decodable {
    static func decode(j: JSON) -> Decoded<KAItem> {
        let a = curry(KAItem.init)
         return a <^> j <| "id"
            <*> j <| "title"
            <*> j <| "description"
            <*> j <| "city"
            <*> j <| "email"
            <*> j <| "telephone"
            <*> j <|? "image"
            <*> j <| "create_time"
            <*> j <| "category"
        
    }
}


