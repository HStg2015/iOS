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
    
    static func loadItems(completion: (items: [(KAItem.Category, [KAItem])]) -> Void, error: (ErrorType?) -> Void) {
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
                        let sorted = items.reduce([]) {
                            return sortInCategories($1, categories: $0 ?? [])
                            }.map {
                                ($0.0, $0.1.sort {
                                    $0.date.laterDate($1.date) == $0.date
                                    })
                        }
                        
                        completion(items: sorted)
                    }
                }
        }
    }
    
    
    static func sortInCategories(item: KAItem, categories: [(KAItem.Category, [KAItem])]) -> [(KAItem.Category, [KAItem])] {
        let s: ([(KAItem.Category, [KAItem])], Bool) = categories.reduce(([], false)) {
            let t = $0
            let n = $1
            if $1.0 == item.category {
                return (t.0 + [(n.0, n.1 + [item])], true)
            } else {
                return (t.0 + [n], t.1)
            }
        }
        if !s.1 {
            return s.0 + [(item.category, [item])]
        } else {
            return s.0
        }
    }
}