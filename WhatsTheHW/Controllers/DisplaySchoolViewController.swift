//
//  DisplaySchoolViewController.swift
//  WhatsTheHW
//
//  Created by 수현 on 8/4/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class DisplaySchoolViewController: UIViewController {
    @IBOutlet weak var schoolNameTextField: UITextField!
    @IBOutlet weak var schoolCityTextField: UITextField!
    @IBOutlet weak var schoolCountryTextField: UITextField!
    
    var school: School?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor(red: CGFloat(163.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.1))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        schoolNameTextField.text = ""
        schoolCityTextField.text = ""
        schoolCountryTextField.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listSchoolTableViewController = segue.destinationViewController as! ListSchoolTableViewController
        if segue.identifier == "Save" {
            print("save clicked")
            
            // create new school
            let newSchool = School()
            newSchool.schoolName = schoolNameTextField.text ?? ""
            newSchool.cityName = schoolCityTextField.text ?? ""
            newSchool.country = schoolCountryTextField.text ?? ""
            
            print("schoolNameText: " +  schoolNameTextField.text!)
            print("schoolCityText: " + newSchool.schoolName!)
            
            newSchool.addSchool(newSchool)
            
            listSchoolTableViewController.tableView.reloadData()
            print("Data reloaded")
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "Save" {
            if schoolNameTextField.text == "" {
                let alert = UIAlertView()
                alert.title = "No School Name"
                alert.message = "Please Set The Name of the School"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            } else if schoolCityTextField.text == "" {
                let alert = UIAlertView()
                alert.title = "No City Name"
                alert.message = "Please Set The Name of the City"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            } else if schoolCountryTextField.text == "" {
                let alert = UIAlertView()
                alert.title = "No Country Name"
                alert.message = "Please Set The Name of the Country"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            }
            else {
                return true
            }
        }
        // by default, transition
        return true
    }
}