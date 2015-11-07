//
//  KAItem.swift
//  bitspls
//
//  Created by Leonard Mehlig on 06/11/15.
//  Copyright © 2015 bitspls. All rights reserved.
//

import Foundation

struct KAItem {
    let identifier: String = "Tester"
    let imageURL: NSURL
    let title: String
    let description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam at tortor iaculis lorem dapibus dignissim. In fermentum, eros vel convallis egestas, enim risus dapibus ligula, id efficitur purus quam eu urna. Cras viverra egestas mauris, ut fringilla ante porta id. Curabitur tincidunt pellentesque neque a pellentesque. In hac habitasse platea dictumst. Nam egestas metus eu lorem dignissim feugiat. Donec nec bibendum metus, quis eleifend turpis. Integer vestibulum ipsum viverra pulvinar ullamcorper. Suspendisse potenti. Aenean quis sem mi."
    
    init(test: String) {
        imageURL = NSURL(string: "https://pbs.twimg.com/profile_images/638825110355341313/Slb0EoCJ.jpg")!
        title = test
    }
}
