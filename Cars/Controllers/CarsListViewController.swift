//
//  Created by Anna on 8/19/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import UIKit
import CoreData

class CarsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var storedCars = [StoredCar]()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()

        storedCars = CDPersistence.fetchRecords()
        if storedCars.count == 0 {
            fetchCars()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    
    func fetchCars() {
        
        if let path = Bundle.main.path(forResource: "cars", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                activityIndicator.stopAnimating()
                if let jsonResult = jsonResult as? NSArray {
                    for json in jsonResult {
                        guard let json = json as? NSDictionary else { return }
                        let car = Car(dictionary: json)
                        CDPersistence.save(car: car)
                    }
                    storedCars = CDPersistence.fetchRecords()
                    tableView.reloadData()
                }
            } catch {
                activityIndicator.stopAnimating()
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }

    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }


    @IBAction func refresh(_ sender: Any) {
        activityIndicator.startAnimating()
        CDPersistence.deleteAllRecords()
        fetchCars()
    }
   
}

extension CarsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell") as! CarCell
        let car = storedCars[indexPath.row]
        cell.storedCar = car
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        storedCars[indexPath.row].expanded = !storedCars[indexPath.row].expanded
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let car = storedCars[indexPath.row]
        let expandedHeight = CellHeight.shrinked.rawValue + CellHeight.carInfoHeight.rawValue + CellHeight.ownerInfoHeight.rawValue * CGFloat(car.owners.count)
        return car.expanded ? expandedHeight : CellHeight.shrinked.rawValue
    }
}

enum CellHeight: CGFloat {
    case shrinked = 60
    case expanded = 200
    case carInfoHeight = 80
    case ownerInfoHeight = 70
    
}
