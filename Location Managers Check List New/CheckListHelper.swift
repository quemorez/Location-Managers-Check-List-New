//
//  CheckListHelper.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/26/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Task {
    var title = ""
}


//func createLocationSectionDictionay() {
let LocationSectionDictionary =
    ["Location Agreement Signed": false, "Location Agreement COI": false, "Location Agreement Check Request Turned In": false,"Location Agreement Check Cut": false, "Location Agreement Check Delivered": false, "Film Permit FIlled out/ Applied for": false, "Film Permit Paid in full": false, "Film Permit": false, "Additional Permits, Cal trans,Electric,Dig": false, "SPFX Permit": false, "Maps request in": false, "Prep Maps finished": false, "Shoot Maps finished": false, "VIP/Move Maps finished": false,"Neighbor Agreements collected and turned in": false,"Neighbor COI Generated": false, "Neighbor Checks Cut and handed out": false,"Site rep PO finished": false,"Site rep Invoice collected": false,"Hydrant Access requested": false,"Hydrant Access approved": false,
     
]

let HoldingSectionDictionary =
    ["Holding Agreement Signed": false, "Holding COI": false, "Holding Check Request Turned In": false,"Holding Check Cut": false, "Holding Check Delivered": false,"Base Camp Agreement Signed": false, "Base Camp COI": false, "Base Camp Check Request Turned In": false,"Base Camp Check Cut": false, "Base Camp Check Delivered": false,"Crew Parking Agreement Signed": false, "Crew Parking  COI": false, "Crew Parking  Check Request Turned In": false,"Crew Parking  Check Cut": false, "Crew Parking  Check Delivered": false,"Catering Agreement Signed": false, "Catering  COI": false, "Catering  Check Request Turned In": false,"Catering  Check Cut": false, "Catering  Check Delivered": false,
     
]

let VendorSectionDictionary =
    ["Police Ordered": false, "Police Confirmed": false,"Security Ordered": false, "Security Confirmed": false,"Catering Tents Ordered": false,"Tables and Chairs Ordered": false,"Changing Tents Ordered": false," Clothing Racks Ordered": false,"Dumpsters Ordered": false,"Traffic Control/ Barricades Ordered": false,"Layout Board Ordered": false,"Heaters/AC Ordered": false, "Portapotties Ordered": false,"Glowbugs/Light towers Ordered": false,"Water trucks Ordered": false,
     
]

let OtherSectionDictionary =
    [String : Bool]()

/*
 if error != nil {
 self.displayAlert(title: "Could not save Project", error: "Please check conection and try again")
 } else if let Location = Location {
 Location["LocationSectionCLItems"] = parsedLocationSectionCLItems
 Location["HoldingSectionCLItems"] = parsedHoldingSectionCLItems
 Location["VendorSectionCLItems"] = parsedVendorSectionCLItems
 Location["OtherSectionCLItems"] = parsedOtherSectionCLItems
 Location.saveInBackground(block: { (success, error) in
 if success == true {
 
 //stops Activity Indicator
 self.activityIndicator.stopAnimating()
 UIApplication.shared.endIgnoringInteractionEvents()
 
 self.displayAlert(title: "Location Saved", error: "Click on Locations to start checking tasks off")
 
 
 } else {
 //stops Activity Indicator
 self.activityIndicator.stopAnimating()
 UIApplication.shared.endIgnoringInteractionEvents()
 
 self.displayAlert(title: "Could not save Project", error: "Please check conection and try again")
 
 }
 
 })
 
 }
 */

