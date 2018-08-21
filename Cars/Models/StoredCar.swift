//
//  StoredCar.swift
//  Cars
//
//  Created by Anna on 8/21/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import Foundation

class StoredCar {
    
    var car: CDCar
    var owners: [CDOwner]
    var expanded = Bool()
    
    init(car: CDCar, owners: [CDOwner]) {
        self.car = car
        self.owners = owners
    }
}
