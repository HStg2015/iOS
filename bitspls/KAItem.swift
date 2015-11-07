//
//  KAItem.swift
//  bitspls
//
//  Created by Leonard Mehlig on 06/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import Argo
import Curry



struct KAItem {
    let id: Int
    let title: String
    let description: String
    let city: String
    let email: String
    let phone: String?
    let image: String?
    let timestamp: String
    
    var imageURL: NSURL? {
        return self.image.flatMap { NSURL(string: $0) }
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
            <*> j <|? "telephone"
            <*> j <|? "image"
            <*> j <| "create_time"
        
    }
}


