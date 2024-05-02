//
//  ViewController.swift
//  LocationIdentifier
//
//  Created by FDC.Chris on 4/29/24.
//

import UIKit
import PromiseKit
import DropDown
import Alamofire


class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var showNameError: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var namePlaceholder: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var regionInput: UILabel!
    @IBOutlet weak var showRegionError: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var countryInput: UITextField!
    @IBOutlet weak var showCountryError: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    let networkManager = NetworkManager.shared
    let dropDownRegion = DropDown()
    let dropdownCountry = DropDown()
    var regionValuesArray: [String] = []
    var countryValuesArray: [String] = []
    var tempSelectedRegion: String?
//    var countryValues: [String] = []
    //global variables
    var globalName: String?
    var globalCountryName: String?
    var filteredOptions: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getRegionData()
        showNameError.isHidden = true
        showRegionError.isHidden = true
        showCountryError.isHidden = true
        dropDownMotion()
        countryDropDown()
        
    }
    
    @IBAction func regionButtonIsPressed(_ sender: UIButton) {
        dropDownRegion.dataSource = regionValuesArray
        dropDownRegion.show()
    }
    
    @IBAction func nameDidInput(_ sender: UITextField) {
        globalName = sender.text
    }
    
    @IBAction func countryFieldOnPressed(_ sender: UITextField) {

    }
    
    @IBAction func searchButtonOnPressed(_ sender: UIButton) {
        print("button pressed") // check if button is pressed
        print ("countruyValuesArray\(countryValuesArray)")
    }
    // checker for empty region data
    func regionHasData() -> Bool {
        guard let regionSelect = regionInput.text else { return false }
        return !regionSelect.isEmpty && !dropDownRegion.dataSource.isEmpty
    }
    // checker for empty name
    func nameHasData() -> Bool {
        guard let userName = nameInput.text else { return false }
        return !userName.isEmpty && isValidInput(userName)
    }
    //MARK: - checker for empty name
    func countryHasData() -> Bool {
        guard let countrySelect = countryInput.text else { return false }
        return !countrySelect.isEmpty
    }
    
    @IBAction func submitButtonOnPressed(_ sender: UIButton) {
        // Check if data is present
        if nameHasData() && regionHasData() {
            // Perform the conditional segue
            if shouldPerformSegue(withIdentifier: "displayData", sender: nil) {
                performSegue(withIdentifier: "displayData", sender: nil)
            }
        } else {
            nameHasDataChecker()
            regionHasDataChecker()
            countryHasDataChecker()
            print ("errorrrr ")
        }
        
        print ("country selected\(countryInput.text)")
    }
    // clears the data
    @IBAction func clearButtonOnPressed(_ sender: UIButton) {
        nameInput.text = ""
        regionInput.text = ""
        countryInput.text = ""
    }
    
        //MARK: - get region data
    // gets the data for the region
    func getRegionData() {
        NetworkManager.shared.fetchAPI()
            .done { response in
                if let dict = response as? [[String: Any]] {
                    let uniqueRegions = Set(dict.compactMap { $0["region"] as? String }) // Set to remove duplicates... only display unique
                    let sortedRegions = Array(uniqueRegions).sorted() // sort alphabetically in array
                    
                    self.regionValuesArray = sortedRegions
                    self.dropDownRegion.dataSource = sortedRegions
                    
                    sortedRegions.forEach { region in
                        print("Unique Region: \(region)")
                    }
                } else {
                    print("Error: Unable to parse response as JSON array")
                }
            }
            .catch { error in
                print("Error fetching region data: \(error)")
            }
    }
    

    //MARK: - get country data
    func getCountryCommonName() {
        NetworkManager.shared.fetchAPI()
            .done { response in
                if let dictArray = response as? [[String: Any]] {
                    let filteredArray = dictArray.filter { $0["region"] as? String == self.tempSelectedRegion }
                    
                    // Clear the existing array before appending new values
                    self.countryValuesArray.removeAll()
                    
                    for dict in filteredArray {
                        if let nameDict = dict["name"] as? [String: Any],
                           let namesCommon = nameDict["common"] as? String {
                            self.countryValuesArray.append(namesCommon)
                        }
                    }
                    
                    // Reload the dropdown with the updated country values
                    self.dropdownCountry.dataSource = self.countryValuesArray
                } else {
                    print("Error: Unable to parse response as JSON array")
                }
            }
            .catch { error in
                print("Error fetching region data: \(error)")
            }
    }
    
    // validating the value for the name
    func isValidInput(_ input: String) -> Bool {
        let letters = CharacterSet.letters
        return input.rangeOfCharacter(from: letters.inverted) == nil
    }
    
    func dropDownMotion(){
        dropDownRegion.anchorView = dropDownView
        dropDownRegion.dataSource = regionValuesArray
        
        dropDownRegion.bottomOffset = CGPoint(x: 0, y: (dropDownRegion.anchorView?.plainView.bounds.midY)!)
        dropDownRegion.topOffset = CGPoint(x: 0, y: -(dropDownRegion.anchorView?.plainView.bounds.maxY)!)
        dropDownRegion.direction = .bottom
        
        dropDownRegion.selectionAction = { (index: Int, item: String) in
            self.regionInput.text = item
            self.regionInput.textColor = .black
        }
        // display the selected item in the selectedRegion
        dropDownRegion.selectionAction = { [weak self] index, selectedRegion in
            self?.regionInput.text = selectedRegion
            self?.regionInput.textColor = .black
            self?.tempSelectedRegion = selectedRegion
            self?.hideRegionErrorStyle()
            
            self?.getCountryCommonName()
        }
    }
    
    //MARK: - show error for name
    func showNameErrorStyle() {
        showNameError.textColor = .red
        nameInput.layer.borderColor = UIColor.red.cgColor
        nameInput.layer.borderWidth = 1.0
        nameLabel.textColor = .red
    }
    
    //MARK: - hide error for name
    func hideNameErrorStyle() {
        showNameError.textColor = .clear
        nameInput.layer.borderColor = UIColor.clear.cgColor
        nameInput.layer.borderWidth = 0.0
        nameLabel.textColor = .black
    }
    
    //MARK: - show error for region
    func showRegionErrorStyle() {
        showRegionError.textColor = .red
        regionInput.layer.borderColor = UIColor.red.cgColor
        regionInput.layer.borderWidth = 1.0
        regionLabel.textColor = .red
    }
    
    //MARK: - hide error for region
    func hideRegionErrorStyle() {
        showRegionError.textColor = .clear
        regionInput.layer.borderColor = UIColor.clear.cgColor
        regionInput.layer.borderWidth = 0.0
        regionLabel.textColor = .black
    }
    //MARK: - show error for country
    func showCountryErrorStyle() {
        showCountryError.textColor = .red
        countryInput.layer.borderColor = UIColor.red.cgColor
        countryInput.layer.borderWidth = 1.0
        countryLabel.textColor = .red
    }
    
    //MARK: - hide error for country
    func hideCountryErrorStyle() {
        showCountryError.textColor = .clear
        countryInput.layer.borderColor = UIColor.clear.cgColor
        countryInput.layer.borderWidth = 0.0
        countryLabel.textColor = .black
    }
    func regionHasDataChecker() -> Bool {
        if !regionHasData() {
            showRegionError.isHidden = false
            showRegionError.text = "Region cannot be empty"
            showRegionErrorStyle()
            return false
        } else {
            showRegionError.text = ""
            hideRegionErrorStyle()
            return true
        }
    }
  
    func nameHasDataChecker() -> Bool {
        if let userName = nameInput.text {
            if userName.isEmpty {
                showNameError.isHidden = false
                showNameError.text = "Username cannot be empty"
                showNameErrorStyle()
                return false
            } else if !isValidInput(userName) {
                showNameError.isHidden = false
                showNameError.text = "Cannot contain special characters"
                showNameErrorStyle()
                return false
            } else {
                showNameError.text = ""
                hideNameErrorStyle()
                return true
            }
        } else {
            return false
        }
    }
    //MARK: - Country Listener
    func countryHasDataChecker() -> Bool{
        if let countryName = countryInput.text {
            if countryName.isEmpty{
                showCountryError.isHidden = false
                showCountryError.text = "Country data must not be empty"
                showCountryErrorStyle()
                return false
            } else if !regionHasData(){
                showCountryError.isHidden = false
                showCountryError.text = "Select Region first"
                showCountryErrorStyle()
                return false
            } else {
                showCountryError.text = ""
                hideCountryErrorStyle()
                return true
            }
        }else {
            return false
        }
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "displayData" {
            
            return nameHasData() && regionHasData() && countryHasData()
        }
        return true // Allow other segues
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayData" {
            if let destinationVC = segue.destination as? SummaryViewController {
                destinationVC.nameToDisplay = globalName
                destinationVC.regionToDisplay = tempSelectedRegion
                destinationVC.countryToDisplay = globalCountryName
            }
        }
    }
    
    
//MARK: - countryDropdown

    func countryDropDown(){
        // Set up the dropdown
        dropdownCountry.anchorView = countryInput
        dropdownCountry.dataSource = countryValuesArray // Use countryValuesArray for dropdown
        
        dropdownCountry.bottomOffset = CGPoint(x: 0, y: (dropDownRegion.anchorView?.plainView.bounds.midY)!)
        dropdownCountry.topOffset = CGPoint(x: 0, y: -(dropDownRegion.anchorView?.plainView.bounds.maxY)!)
        dropdownCountry.direction = .bottom
        
        // Set up selection action
        dropdownCountry.selectionAction = { [unowned self] (index: Int, item: String) in
            self.countryInput.text = item
            self.dropdownCountry.hide()
            
            self.globalCountryName = item
        }
        
        // Set up text field
        countryInput.delegate = self
        
        // Customize appearance (optional)
        dropdownCountry.textColor = .black
        dropdownCountry.backgroundColor = .white
    }
    
    
    // MARK: - textfield checkings
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        showNameError.text = ""
        hideNameErrorStyle()
        
        if textField == countryInput {
            dropdownCountry.show()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        filterDropdownOptions(searchText)
        
        //addded this so when the user is typing, it hides the error display
        if textField == nameInput {
            hideNameErrorStyle()
        }
        
        return true
    }
    // MARK: - Helper Methods
    func filterDropdownOptions(_ searchText: String) {
        if searchText.isEmpty {
            filteredOptions = countryValuesArray
        } else {
            filteredOptions = countryValuesArray.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        dropdownCountry.dataSource = filteredOptions
        dropdownCountry.show()
    }
}
