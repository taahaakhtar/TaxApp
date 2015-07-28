//
//  ViewController.swift
//  TaxApp
//
//  Created by Taaha Akhtar on 7/15/15.
//  Copyright © 2015 Taaha Akhtar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var initialValueField: UITextField!
    @IBOutlet weak var salesTaxRateField: UITextField!
    @IBOutlet weak var discountRateField: UITextField!
    @IBOutlet weak var finalDisplayedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        
        initialValueField.delegate = self
        salesTaxRateField.delegate = self
        discountRateField.delegate = self
        
        //Looks for single or multiple taps. - part of hiding keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
      
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
                
                finalDisplayedLabel.text = "\(finalValue)"
                
            } // End of nested if
            
        } // End of original if
        
    } // End of setSalesTax function
   

    @IBAction func setDiscountRate(sender: UITextField) {
        
        // Calculate the final value when the user also inputs a Discount Rate 
    
            // Initial discount rate value user inputs converted to a Double
        
            let discountRateDouble: Double? = Double(discountRateField.text!)
            
            if let discountRate = discountRateDouble{
                
                let newDisRate: Double = 1 - (discountRate / 100)
                print("Success! Your discount rate multiple is \(newDisRate)")
                let preDiscountPrice = NSString(string: finalDisplayedLabel.text!).doubleValue
                finalDisplayedLabel.text = "\(newDisRate * preDiscountPrice)"
                
            } // End of if
        
    } // End of setDiscountRate function

} // End of ViewController class









