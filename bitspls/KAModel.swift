//
//  KAModel.swift
//  bitspls
//
//  Created by Leonard Mehlig on 07/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import Foundation
import Alamofire
import Argo

struct KAModel {
    
    private struct URL {
        static let Base = "https://morning-waters-8909.herokuapp.com/"
        static let SimpleOffer = "simple_offer/"
    }
    
    static func loadItems(completion: (items: [KAItem]) -> Void, error: (ErrorType?) -> Void) {
        Alamofire.request(.GET, URL.Base + URL.SimpleOffer)
            .responseJSON { response in
                switch response.result {
                case .Failure(let e): error(e)
                case .Success(let json):
                    let decodedItems: Decoded<[KAItem]> = decode(json)
                    switch decodedItems {
                    case .Failure(let e):
                        error(e)
                    case .Success(let items):
                        completion(items: items)
                    }
                }
        }
    }
}