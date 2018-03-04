//
//  HelperClass.swift
//  DirectionsToIndianCities
//
//  Created by rakshith appaiah on 3/4/18.
//  Copyright © 2018 rakshith appaiah. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HelperClass: NSObject {
    
    static var dbHandle: DatabaseHandle?
    static var dbReference: DatabaseReference = Database.database().reference(fromURL: "https://directionstoindiancities.firebaseio.com/")

}
