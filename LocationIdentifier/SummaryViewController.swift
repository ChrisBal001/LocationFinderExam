//
//  SummaryViewController.swift
//  LocationIdentifier
//
//  Created by FDC.Chris on 5/1/24.
//

import Foundation
import UIKit

class SummaryViewController: UIViewController, UITextFieldDelegate {
    
    var nameToDisplay: String?
    var regionToDisplay: String?
    var countryToDisplay: String?
    
    @IBOutlet weak var nameInputLabel: UILabel!
    @IBOutlet weak var regionInputLabel: UILabel!
    @IBOutlet weak var countryInputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayName()
        displayRegion()
        displayCountry()
        
        
    }
    
    func displayName(){
        if let name = nameToDisplay {
            print ("name sent\(nameToDisplay)")
            nameInputLabel.text = ("Hi \(name)")
        }
    }
    
    func displayRegion(){
        if let region = regionToDisplay {
            print ("name sent\(regionToDisplay)")
            regionInputLabel.text = ("Your region is \(region)")
        }
    }
    func displayCountry(){
        if let country = countryToDisplay {
            print ("name sent\(countryToDisplay)")
            countryInputLabel.text = ("\(country)")
        }
    }
    
}
