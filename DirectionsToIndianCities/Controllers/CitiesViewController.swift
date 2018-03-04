//
//  CitiesViewController.swift
//  DirectionsToIndianCities
//
//  Created by rakshith appaiah on 3/4/18.
//  Copyright © 2018 rakshith appaiah. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CitiesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var dbHandle: DatabaseHandle?
    
    @IBOutlet weak var tableview: UITableView!
    var city = Place()
    var cities = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.logOut, style: .done, target: self, action: #selector(Logout))
        self.getCitiesDetails()
    }
    
    /// Logout button action.
    @objc func Logout() {
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        city = self.cities[indexPath.row]
        performSegue(withIdentifier: "CityDetailsSegue", sender: self)
    }
    
    /// Passing cityDetails to CityDetailsViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CityDetailsViewController {
            destination.cityDetails = self.city
            self.navigationItem.title = ""
        }
    }
}

extension CitiesViewController {
    
    /// Populating cities from FireBase.
    func getCitiesDetails() {
        HelperClass.dbReference.child(Constants.Places).observe(.childAdded, with: { (dataCity) in
            if let city = dataCity.value as? AnyObject {
                let place = Place()
                place.cityDescription = city["description"] as? String
                place.latitude = city["latitude"] as? Double
                place.longitude = city["longitude"] as? Double
                place.name = city["name"] as? String
                self.cities.append(place)
                self.tableview.reloadData()
            }
        })
    }
}
