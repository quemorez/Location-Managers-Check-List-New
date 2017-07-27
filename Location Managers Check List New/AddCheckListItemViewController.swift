//
//  AddCheckListItemViewController.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/26/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit


class AddCheckListItemViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var categories = ["Location", "Holding", "Vendor", "Other"]
    var newItem = [String: String]()
    var selectedCategory = ""
    var CurrentLocation = ""
    var CurrentProject = ""
    
    
    @IBOutlet var nameTextfield: UITextField!
    
    @IBOutlet var choseCatLable: UILabel!
    
    @IBOutlet var catigoryPicker: UIPickerView!
    
    @IBOutlet var saveButtonOutlet: UIButton!
    
    @IBAction func saveButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "SaveChecklistItemSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catigoryPicker.delegate = self
        catigoryPicker.dataSource = self
        
        
        nameTextfield.layer.cornerRadius = 20
        nameTextfield.clipsToBounds = true
        catigoryPicker.layer.cornerRadius = 20
        catigoryPicker.clipsToBounds = true
        saveButtonOutlet.layer.cornerRadius = 20
        saveButtonOutlet.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - PickerView stuff
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.newItem = [(nameTextfield.text!):(categories[row])]
        self.selectedCategory = categories[row]
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveChecklistItemSegue"{
            print(self.selectedCategory)
            self.newItem = [(self.nameTextfield.text!): (self.selectedCategory)]
            let CheckListView = segue.destination as! CheckListViewController
            CheckListView.newItem = self.newItem
            CheckListView.CurrentLocation = self.CurrentLocation
            CheckListView.CurrentProject = self.CurrentProject
            
            print(newItem)
        }
    }
    
    
}

