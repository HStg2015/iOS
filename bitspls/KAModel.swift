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
import RealmSwift

struct KAModel {
    
    private struct URL {
        static let Base = "https://morning-waters-8909.herokuapp.com/"
        static let SimpleOffer = "simple_offer/"
    }
    
    static func loadItems(completion: (items: [(KAItem.Category, [KAItem])], add: Bool) -> Void, error: (ErrorType?) -> Void) {
        let lastItems = (try? Realm().objects(KARealmItem))?.map { $0.item }
        let sortedItmes = lastItems?.reduce([]) {
            return sortInCategories($1, categories: $0 ?? [])
            }.map {
                ($0.0, $0.1.sort {
                    $0.date.earlierDate($1.date) == $0.date
                    })
        }
        if let i = sortedItmes {
            completion(items: i, add: false)
        }
        let latest = lastItems?.reduce(lastItems?.first) {
            let last = $1.date
            
            guard let first = $0?.date where first.earlierDate(last) == last else { return $0 }
            return $1
            
        }
        
        Alamofire.request(.GET, URL.Base + URL.SimpleOffer, parameters: latest.map { ["ts" : $0.timestamp] })
            .responseJSON { response in
                switch response.result {
                case .Failure(let e): error(e)
                case .Success(let json):
                    let decodedItems: Decoded<[KAItem]> = decode(json)
                    switch decodedItems {
                    case .Failure(let e):
                        error(e)
                    case .Success(let items):
                        let realmItems: [KARealmItem] = items.map {
                            let r = KARealmItem()
                            r.item = $0
                            return r
                        }
                        let realm = try? Realm()
                        let _ = try? realm?.write {
                            realm?.add(realmItems)
                        }
                        let sorted = items.reduce([]) {
                            return sortInCategories($1, categories: $0 ?? [])
                            }.map {
                                ($0.0, $0.1.sort {
                                    $0.date.earlierDate($1.date) == $0.date
                                    })
                        }
                        
                        completion(items: sorted, add: true)
                    }
                }
        }
    }
    
    static func saveItem(title: String, description: String, category: Int, location: String, phone: String, mail: String, image: UIImage?, completion: (error: ErrorType?) -> Void) {
        Alamofire.upload(
            .POST,
            URL.Base + URL.SimpleOffer,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: title.dataUsingEncoding(NSUTF8StringEncoding)!, name: "title")
                multipartFormData.appendBodyPart(data: description.dataUsingEncoding(NSUTF8StringEncoding)!, name: "description")
                multipartFormData.appendBodyPart(data: "\(category)".dataUsingEncoding(NSUTF8StringEncoding)!, name: "category")
                multipartFormData.appendBodyPart(data: location.dataUsingEncoding(NSUTF8StringEncoding)!, name: "city")
                multipartFormData.appendBodyPart(data: phone.dataUsingEncoding(NSUTF8StringEncoding)!, name: "telephone")
                multipartFormData.appendBodyPart(data: mail.dataUsingEncoding(NSUTF8StringEncoding)!, name: "email")
                if let i = image {
                    multipartFormData.appendBodyPart(data: UIImagePNGRepresentation(i)!, name: "image", fileName: "temp_image.png", mimeType: "image/png")
                } else {
                    multipartFormData.appendBodyPart(data: "".dataUsingEncoding(NSUTF8StringEncoding)!, name: "image")
                }
                
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        debugPrint(response)
                        completion(error: response.response?.statusCode == 400 ? NSError(domain: "400", code: 400, userInfo: nil) : nil)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    completion(error: encodingError)
                }
        })
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