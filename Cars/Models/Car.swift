//
//  Car.swift
//  Cars
//
//  Created by Anna on 8/19/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit

struct Car {
    
    var id: Int?
    var type: String?
    var model: String?
    var color: String?
    var owners: [Owner]
    
    init(dictionary: NSDictionary) {
        var owners = [Owner]()
        if  let id = dictionary["car_id"] as? Int,
            let type = dictionary["car_type"] as? String,
            let model = dictionary["car_model"] as? String,
            let color = dictionary["car_color"] as? String,
            let ownersArray = dictionary["owners"] as? NSArray {
            
                self.id = id
                self.type = type
                self.model = model
                self.color = color
                
            
                for ownerDictionary in ownersArray {
                    if let dictionary = ownerDictionary as? NSDictionary {
                        let owner = Owner(dictionary: dictionary)
                        owners.append(owner)
                    }
                }
        }
        self.owners = owners
    }
}
