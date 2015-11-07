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
    let title: String
    let description: String
    let city: String
    let email: String
    let phone: String?
    let imageURL: NSURL = NSURL(string: "https://qph.is.quoracdn.net/main-qimg-31983979e389060f645ad1ad7e20dbf0?convert_to_webp=true")!
}

extension KAItem: Decodable {
    static func decode(j: JSON) -> Decoded<KAItem> {
        return curry(KAItem.init)
            <^> j <| "title"
            <*> j <| "description"
            <*> j <| "city"
            <*> j <| "email"
            <*> j <|? "telephone"
    }
}
