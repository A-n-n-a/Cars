//
//  Owner.swift
//  Cars
//
//  Created by Anna on 8/20/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import Foundation

class Owner {
    var id: Int?
    var name: String?
    var phone: String?
    
    init(dictionary: NSDictionary) {
        if  let id = dictionary["owner_id"] as? Int,
            let name = dictionary["owner_name"] as? String,
            let phone = dictionary["owner_phone"] as? String {
            
            self.id = id
            self.name = name
            self.phone = phone
        }
    }
}
