//
//  Created by Anna on 8/19/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData

class CarCell: UITableViewCell {

    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    var isExpanded = Bool()
    
    var storedCar: StoredCar! {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        guard   let storedCar = storedCar,
                let model = storedCar.car.value(forKey: "model") as? String,
                let type = storedCar.car.value(forKey: "type") as? String,
                let color = storedCar.car.value(forKey: "color") as? String else { return }
        
        modelLabel.text = model
        typeLabel.text = type
        colorLabel.text = color
        
        let owners = storedCar.owners
        for index in 0..<owners.count {
            let owner = owners[index]
            let offsetY: CGFloat = CGFloat(index) * 70
            let ownerView = OwnerView(frame: CGRect(x: 0, y: 140 + offsetY, width: UIScreen.main.bounds.width, height: 50))
            if  let name = owner.value(forKey: "name") as? String,
                let phone = owner.value(forKey: "phone") as? String {
                ownerView.nameLabel.text = name
                ownerView.phoneLabel.text = phone
            }
            self.addSubview(ownerView)
        }
    }
}
