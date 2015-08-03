//
//  ViewController.swift
//  TaxApp
//
//  Created by Taaha Akhtar on 7/15/15.
//  Copyright © 2015 Taaha Akhtar. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var initialValueField: UITextField!
    @IBOutlet weak var salesTaxRateField: UITextField!
    @IBOutlet weak var discountRateField: UITextField!
    @IBOutlet weak var finalDisplayedLabel: UILabel!
    @IBOutlet weak var clearValues: UIButton!
    
    @IBOutlet weak var refreshTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        
        initialValueField.delegate = self
        salesTaxRateField.delegate = self
        discountRateField.delegate = self
        
        // Remove the separator lines from table view pull to refresh 
        refreshTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Make background color transparent to see the other images.
        refreshTableView.backgroundColor = UIColor.clearColor()
        
        //Looks for single or multiple taps. - part of hiding keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Pull to Refresh Action 1/2
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        refreshTableView.addSubview(refreshControl)
        
    }
    
    // Pull to Refresh Action 2/2
    
    func refresh(refreshControl: UIRefreshControl) {
       
        // Do your job, when done:
       
        finalDisplayedLabel.text = "0.00" // Reset final display to zero
        initialValueField.text = "" // Clear all the values
        salesTaxRateField.text = "" // Clear all the values
        discountRateField.text = "" // Clear all the values
        
        print("The values have been cleared!")
        
        refreshControl.endRefreshing()
    }
    
    // Calls this function when the tap is recognized. Hides keyboard!
    
    func DismissKeyboard(){
        
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    // Limit the number of digits entered into the UITextField
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        
        // Sets range of characters allowed in each field
        
        let newLengthInitialValue = (textField.text!.characters.count) + (string.characters.count) - range.length
        
        let newLengthSalesTax = (salesTaxRateField.text!.characters.count) + (string.characters.count) - range.length
        
        let newLengthDiscountRate = (discountRateField.text!.characters.count) + (string.characters.count) - range.length
        
        // Limits decimal to one decimal point
        
        let countDots = textField.text!.componentsSeparatedByString(".").count - 1
        
        if countDots > 0 && string == "."
        {
            return false
        }
        
        // Limits digits after decimal to two digits
        
        if textField.text!.rangeOfString(".") != nil {
            if textField.text!.componentsSeparatedByString(".")[1].characters.count + string.characters.count > 2 {
                return false
            }
        }
        
        // Returns true and returns maximum length allowed in text fields
        
        return true && newLengthInitialValue <= 10 && newLengthSalesTax <= 5 && newLengthDiscountRate <= 5 // Bool
        
    }
    
    // MARK: Actions
    
    @IBAction func setInitialValue(sender: UITextField) {
        
        
        if initialValueField.text == "" || initialValueField.text == nil {
            finalDisplayedLabel.text = "0.00"
        }
        else {
            finalDisplayedLabel.text = initialValueField.text
        }
        
        
    }
    
    @IBAction func setSalesTax(sender: UITextField){
        
        // Calculate the final value when user only inputs a Sales Tax Rate
        
        if finalDisplayedLabel.text == initialValueField.text || initialValueField.text == ""{
            
            // Initial value user inputs converted to a Double
            
            let initialValueDouble: Double? = Double(initialValueField.text!)
            
            // Sales Tax number user inputs converted to multiple
            
            let salesTaxDouble: Double? = Double(salesTaxRateField.text!)
            
            if let salesTax = salesTaxDouble{
                
                let newSalesTax = (salesTax / 100) + 1 // Calculation to get the multiple
                print("Success! Your sales tax multiple is \(newSalesTax)") // Shows the multiple being used
                
                let finalValue = initialValueDouble! * newSalesTax // What the final value calculation will be
                
                print("Success! Your new final value should be \(finalValue)") // Tests to see what actual price is compared to the label value
                
                finalDisplayedLabel.text = "\(round((finalValue) * 100) / 100)" // round final value to 2 decimal places
                
            } // End of nested if
            
        } // End of original if
        
        if salesTaxRateField.text == "" || salesTaxRateField.text == nil{ // if the sales tax field is empty
            
            finalDisplayedLabel.text = initialValueField.text
            
        } // If user decides to manually clear sales tax rate, the final value will only display the initial value.
        
        // Initial Value times the discount rate
        
        let discountRateDouble: Double? = Double(discountRateField.text!)
        
        let initialValue = NSString(string: initialValueField.text!).doubleValue
        let salesTaxValue = NSString(string: salesTaxRateField.text!).doubleValue
        let salesTax = salesTaxRateField.text!
        
        if salesTaxValue == 0.00 || salesTax == "" {
            
            if let discountRate = discountRateDouble{
                
                let newDisRateTwo: Double = 1 - (discountRate / 100)
                print("Success! Your discount rate multiple is \(newDisRateTwo)")
                
                print("Your final value should be \(initialValue * newDisRateTwo)")
                finalDisplayedLabel.text = "\((initialValue * newDisRateTwo) * 100 / 100)"
                
            }
        } // End of if statement that says if sales tax field is empty, then just multiply initial value by discount
        
    } // End of setSalesTax function
    
    
    @IBAction func setDiscountRate(sender: UITextField) {
        
        // Initial value times the sales tax rate if user deletes the discount rate
        
        let salesTaxDouble: Double? = Double(salesTaxRateField.text!)
       
        let initialValue = NSString(string: initialValueField.text!).doubleValue
        let discountRateValue = NSString(string: salesTaxRateField.text!).doubleValue
        let disRateValue = discountRateField.text!
        
        if discountRateValue == 0.00 || disRateValue == "" {
            
            if let salesTax = salesTaxDouble{
                
                let newSalesTax = (salesTax / 100) + 1 // Calculation to get the multiple
                print("Success! Your sales tax multiple is \(newSalesTax)") // Shows the multiple being used
                
                let finalValue = initialValue * newSalesTax // What the final value calculation will be
                
                print("Success! Your new final value should be \(finalValue)") // Tests to see what actual price is compared to the label value
                
                finalDisplayedLabel.text = "\(round((finalValue) * 100) / 100)" // round final value to 2 decimal places
                
            } // End of nested if

        } // End of original if
        
        // Calculate the final value when the user also inputs a Discount Rate
        
        // Initial discount rate value user inputs converted to a Double
        
        let discountRateDouble: Double? = Double(discountRateField.text!)
        let preDiscountPrice = NSString(string: finalDisplayedLabel.text!).doubleValue
        
        if let discountRate = discountRateDouble{
            
            let newDisRate: Double = 1 - (discountRate / 100)
            print("Success! Your discount rate multiple is \(newDisRate)") // Lets you know the correct discount rate value
            
            print("Success! Your new final value should be \(newDisRate * preDiscountPrice)") // Tests to see what the actual price is compared to the label value
            
            finalDisplayedLabel.text = "\(round((newDisRate * preDiscountPrice) * 100) / 100)" // round final value to 2 decimal places
            
            if discountRateField.text == "" || discountRateField.text == nil{
                
                finalDisplayedLabel.text = "\(preDiscountPrice)"
                
            } // If user decides to manually clear discount rate, the final value will update
            
        } // End of original if
        
        
       // If you delete both the sales tax rate and the discount rate, update the value.
        if salesTaxDouble == 0.00 && discountRateDouble == 0.00 {
            
            finalDisplayedLabel.text = initialValueField.text
        }
        
    } // End of setDiscountRate function
    
    @IBAction func clearAllValues(sender: UIButton) {
        
        finalDisplayedLabel.text = "0.00" // Reset final display to zero
        initialValueField.text = "" // Clear all the values
        salesTaxRateField.text = "" // Clear all the values
        discountRateField.text = "" // Clear all the values
        
        print("The values have been cleared!")
        
    } // End of clearAllValues function
    
} // End of ViewController class
