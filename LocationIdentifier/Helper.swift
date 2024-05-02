////
////  ViewController.swift
////  LocationIdentifier
////
////  Created by FDC.Chris on 4/29/24.
////
//
//import UIKit
//import PromiseKit
//import DropDown
//import Alamofire
//
//
//class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {
//
//    @IBOutlet weak var nameInput: UITextField!
//    @IBOutlet weak var showNameError: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
//    
//    @IBOutlet weak var dropDownView: UIView!
//    @IBOutlet weak var regionInput: UILabel!
//    @IBOutlet weak var showRegionError: UILabel!
//    @IBOutlet weak var regionLabel: UILabel!
//    @IBOutlet weak var countryInput: UITextField!
//    @IBOutlet weak var showCounrtyError: UILabel!
//    @IBOutlet weak var countryLabel: UILabel!
//    
//    let networkManager = NetworkManager.shared
//    let dropDownRegion = DropDown()
//    let dropdownCountry = DropDown()
//    var regionValuesArray: [String] = []
//    var countryValuesArray: [String] = []
//    var filteredOptions: [String] = []
//    //global variables
//    var tempSelectedRegion: String?
//    var globalName: String?
//    var globalCountryName: String?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        showNameError.isHidden = true
//        showRegionError.isHidden = true
//        showCounrtyError.isHidden = true
//        getRegionData()
//        dropDownMotion()
//        countryDropDown()
//        
//    }
//    
//    @IBAction func regionButtonIsPressed(_ sender: UIButton) {
//        dropDownRegion.dataSource = regionValuesArray
//        dropDownRegion.show()
//    }
//    
//    @IBAction func nameDidInput(_ sender: UITextField) {
//        globalName = sender.text
//    }
//        
//    @IBAction func searchButtonOnPressed(_ sender: UIButton) {
//        print("button pressed") // check if button is pressed
//        print ("countruyValuesArray\(countryValuesArray)")
//    }
//    @IBAction func submitButtonOnPressed(_ sender: UIButton) {
//        // Check if data is present
//        if nameHasData() && regionHasData() {
//            // Perform the conditional segue
//            if shouldPerformSegue(withIdentifier: "displayData", sender: nil) {
//                performSegue(withIdentifier: "displayData", sender: nil)
//            }
//        } else {
//            nameHasDataChecker()
//            regionHasDataChecker()
//            countryHasDataChecker()
//            print ("errorrrr ")
//        }
//        
//        print ("country selected\(countryInput.text)")
//    }
//    // clears the data
//    @IBAction func clearButtonOnPressed(_ sender: UIButton) {
//        nameInput.text = ""
//        regionInput.text = ""
//        countryInput.text = ""
//    }
//    
//        //MARK: - get region data
//    // gets the data for the region
//    func getRegionData() {
//        NetworkManager.shared.fetchAPI()
//            .done { response in
//                if let dict = response as? [[String: Any]] {
//                    let uniqueRegions = Set(dict.compactMap { $0["region"] as? String }) // Set to remove duplicates... only display unique
//                    let sortedRegions = Array(uniqueRegions).sorted() // sort alphabetically in array
//                    
//                    self.regionValuesArray = sortedRegions
//                    self.dropDownRegion.dataSource = sortedRegions
//                    
//                    sortedRegions.forEach { region in
//                        print("Unique Region: \(region)")
//                    }
//                } else {
//                    print("Error: Unable to parse response as JSON array")
//                }
//            }
//            .catch { error in
//                print("Error fetching region data: \(error)")
//            }
//    }
//    
//    //original
////    func getCountryCommonName() {
////        NetworkManager.shared.fetchAPI()
////            .done { response in
////                if let dictArray = response as? [[String: Any]] {
////                    // Filter responses based on selected region
////                    let filteredArray = dictArray.filter { $0["region"] as? String == self.tempSelectedRegion }
////                    print(filteredArray)
////                    let dataNum = filteredArray.count
////                    print("Data num: \(dataNum)")
////                    for dict in filteredArray {
////                        // Check if the dictionary contains the "name" key then get their values
////                        if let nameDict = dict["name"] as? [String: Any],
////                           let namesCommon = nameDict["common"] as? String {
////                            self.countryValues.append(namesCommon)
////                            print("Common value: \(namesCommon)")
//////                            self.dropdownCountry.dataSource = self.countryValues
////                        }
////                    }
////                } else {
////                    print("Error: Unable to parse response as JSON array")
////                }
////            }
////            .catch { error in
////                print("Error fetching region data: \(error)")
////            }
////    }
//    //MARK: - get country data
//    func getCountryCommonName() {
//        NetworkManager.shared.fetchAPI()
//            .done { response in
//                if let dictArray = response as? [[String: Any]] {
//                    let filteredArray = dictArray.filter { $0["region"] as? String == self.tempSelectedRegion }
//                    
//                    // Clear the existing array before appending new values
//                    self.countryValuesArray.removeAll()
//                    
//                    for dict in filteredArray {
//                        if let nameDict = dict["name"] as? [String: Any],
//                           let namesCommon = nameDict["common"] as? String {
//                            self.countryValuesArray.append(namesCommon)
//                        }
//                    }
//                    
//                    // Reload the dropdown with the updated country values
//                    self.dropdownCountry.dataSource = self.countryValuesArray
//                } else {
//                    print("Error: Unable to parse response as JSON array")
//                }
//            }
//            .catch { error in
//                print("Error fetching region data: \(error)")
//            }
//    }
//    
//    // validating the value for the name
//    func isValidInput(_ input: String) -> Bool {
//        let letters = CharacterSet.letters
//        return input.rangeOfCharacter(from: letters.inverted) == nil
//    }
//    
//    func dropDownMotion(){
//        dropDownRegion.anchorView = dropDownView
//        dropDownRegion.dataSource = regionValuesArray
//        
//        dropDownRegion.bottomOffset = CGPoint(x: 0, y: (dropDownRegion.anchorView?.plainView.bounds.midY)!)
//        dropDownRegion.topOffset = CGPoint(x: 0, y: -(dropDownRegion.anchorView?.plainView.bounds.maxY)!)
//        dropDownRegion.direction = .bottom
//        
//        dropDownRegion.selectionAction = { (index: Int, item: String) in
//            self.regionInput.text = item
//            self.regionInput.textColor = .black
//        }
//        // display the selected item in the selectedRegion
//        dropDownRegion.selectionAction = { [weak self] index, selectedRegion in
//            self?.regionInput.text = selectedRegion
//            self?.regionInput.textColor = .black
//            self?.tempSelectedRegion = selectedRegion
//            self?.hideRegionErrorStyle()
//            
//            self?.getCountryCommonName()
//        }
//    }
//    
//    
//    //MARK: - show error for name
//    func showNameErrorStyle() {
//        showNameError.textColor = .red
//        nameInput.layer.borderColor = UIColor.red.cgColor
//        nameInput.layer.borderWidth = 1.0
//        nameLabel.textColor = .red
//    }
//    
//    //MARK: - hide error for name
//    func hideNameErrorStyle() {
//        showNameError.textColor = .clear
//        nameInput.layer.borderColor = UIColor.clear.cgColor
//        nameInput.layer.borderWidth = 0.0
//        nameLabel.textColor = .black
//    }
//    
//    //MARK: - show error for region
//    func showRegionErrorStyle() {
//        showRegionError.textColor = .red
//        regionInput.layer.borderColor = UIColor.red.cgColor
//        regionInput.layer.borderWidth = 1.0
//        regionLabel.textColor = .red
//    }
//    
//    //MARK: - hide error for region
//    func hideRegionErrorStyle() {
//        showRegionError.textColor = .clear
//        regionInput.layer.borderColor = UIColor.clear.cgColor
//        regionInput.layer.borderWidth = 0.0
//        regionLabel.textColor = .black
//    }
//    //MARK: - show error for country
//    func showCountryErrorStyle() {
//        showCounrtyError.textColor = .red
//        countryInput.layer.borderColor = UIColor.red.cgColor
//        countryInput.layer.borderWidth = 1.0
//        countryLabel.textColor = .red
//    }
//    
//    //MARK: - hide error for country
//    func hideCountryErrorStyle() {
//        showCounrtyError.textColor = .clear
//        countryInput.layer.borderColor = UIColor.clear.cgColor
//        countryInput.layer.borderWidth = 0.0
//        countryLabel.textColor = .black
//    }
//    
//    
//        //MARK: - checker for empty region data
//    func regionHasData() -> Bool {
//        guard let regionSelect = regionInput.text else { return false }
//        return !regionSelect.isEmpty && !dropDownRegion.dataSource.isEmpty
//    }
//    //MARK: - checker for empty name
//    func nameHasData() -> Bool {
//        guard let userName = nameInput.text else { return false }
//        return !userName.isEmpty && isValidInput(userName)
//    }
//    
//    //MARK: - checker for empty name
//    func countryHasData() -> Bool {
//        guard let countrySelect = countryInput.text else { return false }
//        return !countrySelect.isEmpty
//    }
//    
//    //MARK: - Region Listener
//    func regionHasDataChecker() -> Bool {
//        if !regionHasData() {
//            showRegionError.isHidden = false
//            showRegionError.text = "Region cannot be empty"
//            showRegionErrorStyle()
//            return false
//        } else {
//            showRegionError.text = ""
//            hideRegionErrorStyle()
//            return true
//        }
//    }
//  //MARK: - Name Listener
//    func nameHasDataChecker() -> Bool {
//        if let userName = nameInput.text {
//            if userName.isEmpty {
//                showNameError.isHidden = false
//                showNameError.text = "Username cannot be empty"
//                showNameErrorStyle()
//                return false
//            } else if !isValidInput(userName) {
//                showNameError.isHidden = false
//                showNameError.text = "Cannot contain special characters"
//                showNameErrorStyle()
//                return false
//            } else {
//                showNameError.text = ""
//                hideNameErrorStyle()
//                return true
//            }
//        } else {
//            return false
//        }
//    }
//    //MARK: - Country Listener
//    func countryHasDataChecker() -> Bool{
//        if let countryName = countryInput.text {
//            if countryName.isEmpty{
//                showCounrtyError.isHidden = false
//                showCounrtyError.text = "Country data must not be empty"
//                showCountryErrorStyle()
//                return false
//            } else if !regionHasData(){
//                showCounrtyError.isHidden = false
//                showCounrtyError.text = "Select Region first"
//                showCountryErrorStyle()
//                return false
//            } else {
//                showCounrtyError.text = ""
//                hideCountryErrorStyle()
//                return true
//            }
//        }else {
//            return false
//        }
//    }
//    
//
//    //    func regionHasDataChecker() {
//    //        guard let regionSelect = regionInput.text else {
//    //            return
//    //        }
//    //
//    //        if regionSelect.isEmpty {
//    //            showRegionError.isHidden = false
//    //            showRegionError.text = "Region cannot be empty"
//    //            showRegionErrorStyle()
//    //        }else if dropDown.dataSource.isEmpty{
//    //            showRegionError.isHidden = false
//    //            showRegionError.text = "Region cannot be empty"
//    //            showRegionErrorStyle()
//    //        } else {
//    //            showRegionError.text = ""
//    //            hideRegionErrorStyle()
//    //            // If input is valid, navigate to the next view controller
//    //            //            performSegue(withIdentifier: "showNextViewController", sender: self)
//    //        }
//    //    }
//    //
//    //    func nameHasDataChecker(){
//    //        guard let userName = nameInput.text else {
//    //            return
//    //        }
//    //
//    //        if userName.isEmpty {
//    //            showNameError.text = "Username cannot be empty"
//    //        } else if !isValidInput(userName) {
//    //            showNameError.isHidden = false
//    //            showNameError.text = "Cannot contain alphanumeric characters"
//    //            showNameErrorStyle()
//    //        } else {
//    //            showNameError.text = ""
//    //            hideNameErrorStyle()
//    //            // If input is valid, navigate to the next view controller
//    //            //            performSegue(withIdentifier: "showNextViewController", sender: self)
//    //        }
//    //    }
//    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if identifier == "displayData" {
//            
//            return nameHasData() && regionHasData() && countryHasData()
//        }
//        return true // Allow other segues
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "displayData" {
//            if let destinationVC = segue.destination as? SummaryViewController {
//                destinationVC.nameToDisplay = globalName
//                destinationVC.regionToDisplay = tempSelectedRegion
//                destinationVC.countryToDisplay = globalCountryName
//            }
//        }
//    }
//    
//    
////MARK: - countryDropdown
//    
////    func countryDropDown(){
////        // Set up the dropdown
////        dropdownCountry.anchorView = countryInput
////        dropdownCountry.dataSource = countryValuesArray
////        dropdownCountry.bottomOffset = CGPoint(x: 0, y: (dropDownRegion.anchorView?.plainView.bounds.midY)!)
////        dropdownCountry.topOffset = CGPoint(x: 0, y: -(dropDownRegion.anchorView?.plainView.bounds.maxY)!)
////        dropdownCountry.direction = .bottom
////        // Set up selection action
////        dropdownCountry.selectionAction = { [unowned self] (index: Int, item: String) in
////            self.countryInput.text = item
////            self.dropdownCountry.hide()
////        }
////
////        // Set up text field
////        countryInput.delegate = self
////
////        // Customize appearance (optional)
////        dropdownCountry.textColor = .black
////        dropdownCountry.backgroundColor = .white
////    }
//    func countryDropDown(){
//        // Set up the dropdown
//        dropdownCountry.anchorView = countryInput
//        dropdownCountry.dataSource = countryValuesArray // Use countryValuesArray for dropdown
//        
//        dropdownCountry.bottomOffset = CGPoint(x: 0, y: (dropDownRegion.anchorView?.plainView.bounds.midY)!)
//        dropdownCountry.topOffset = CGPoint(x: 0, y: -(dropDownRegion.anchorView?.plainView.bounds.maxY)!)
//        dropdownCountry.direction = .bottom
//        
//        // Set up selection action
//        dropdownCountry.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.countryInput.text = item
//            self.dropdownCountry.hide()
//            
//            self.globalCountryName = item
//        }
//        
//        // Set up text field
//        countryInput.delegate = self
//        
//        // Customize appearance (optional)
//        dropdownCountry.textColor = .black
//        dropdownCountry.backgroundColor = .white
//    }
//    
//    
//    // MARK: - textfield checkings
//    
//    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
//        showNameError.text = ""
//        hideNameErrorStyle()
//        
//        if textField == countryInput {
//            dropdownCountry.show()
//        }
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//        filterDropdownOptions(searchText)
//        
//        //addded this so when the user is typing, it hides the error display
//        if textField == nameInput {
//            hideNameErrorStyle()
//        }
//        
//        return true
//    }
//    // MARK: - Helper Methods
//    func filterDropdownOptions(_ searchText: String) {
//        if searchText.isEmpty {
//            filteredOptions = countryValuesArray
//        } else {
//            filteredOptions = countryValuesArray.filter { $0.lowercased().contains(searchText.lowercased()) }
//        }
//        dropdownCountry.dataSource = filteredOptions
//        dropdownCountry.show()
//    }
//    
////    func filterDropdownOptions(_ searchText: String) {
////        if searchText.isEmpty {
////            filteredOptions = countryValuesArray
////        } else {
////            filteredOptions = countryValuesArray.filter { $0.lowercased().contains(searchText.lowercased()) }
////        }
////        dropdownCountry.dataSource = filteredOptions
////        dropdownCountry.show()
////    }
//    
////    func setupSearchController() {
////        searchController = UISearchController(searchResultsController: nil)
////        searchController.delegate = self
////        searchController.searchResultsUpdater = self
////        searchController.obscuresBackgroundDuringPresentation = false
////        searchController.searchBar.placeholder = "Search Country"
////        searchController.searchBar.delegate = self
////        searchController.searchBar.autocapitalizationType = .none // Optionally, disable autocapitalization
////
////        // Add the search bar to your UI
////        countryInput.inputAccessoryView = searchController.searchBar
////    }
////
////    func updateSuggestions(for searchText: String) {
////        // Update suggestions based on the searchText and the selected region
////        guard let selectedRegion = tempSelectedRegion else {
////            // Handle case where no region is selected
////            return
////        }
////
////        // Clear previous suggestions
////        suggestions.removeAll()
////
////        // Filter countryValues based on searchText and selectedRegion
////        suggestions = countryValues.filter { country in
////            let lowercasedCountry = country.lowercased()
////            return lowercasedCountry.contains(searchText.lowercased()) && lowercasedCountry.contains(selectedRegion.lowercased())
////        }
////
////        // Optionally, limit the number of suggestions if needed
////        // suggestions = Array(suggestions.prefix(5))
////
////        // Reload the search results if the search controller is active
////        if searchController.isActive {
////            searchController.searchResultsController?.tabBarController
////        }
////    }
////}
////
////// MARK: - UISearchResultsUpdating
////
////extension ViewController: UISearchResultsUpdating {
////    func updateSearchResults(for searchController: UISearchController) {
////        // Update the search results based on the suggestions
////        tableViewData.reloadData()
////    }
////}
////
////// MARK: - UITableViewDataSource
////
////extension ViewController: UITableViewDataSource {
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return suggestions.count
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
////        cell.textLabel?.text = suggestions[indexPath.row]
////        return cell
////    }
////}
////
////// MARK: - UITableViewDelegate
////
////extension ViewController: UITableViewDelegate {
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        // Handle selection of a suggestion
////        let selectedSuggestion = suggestions[indexPath.row]
////        print("Selected suggestion: \(selectedSuggestion)")
////        // Optionally, dismiss the search controller or perform other actions
////    }
//}
