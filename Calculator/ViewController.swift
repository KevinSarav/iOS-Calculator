//
//  ViewController.swift
//  Calculator
//
//  Created by Saravia, Kevin on 6/20/20.
//  Copyright © 2020 Saravia, Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scIntDouble: UISegmentedControl!
    @IBOutlet weak var txFirstNum: UITextField!
    @IBOutlet weak var txSecondNum: UITextField!
    @IBOutlet weak var txNegativeFirstNum: UILabel!
    @IBOutlet weak var txNegativeSecondNum: UILabel!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var tvOperationList: UITextView!
    
    @IBAction func btPlus(_ sender: Any) {
        // Add first and second numbers
        // If both text fields are filled:
        if bothNumbersAreInput() {
            // If both numbers have one decimal point:
            if onlyOneDecimalPoint() {
                // Calculate result and update result label and text view
                let result = Double(numbers().firstNum)! + Double(numbers().secondNum)!
                updateResultAndList("+", result)
            }
        }
    }
    
    @IBAction func btMultiply(_ sender: Any) {
        // Multiply first and second numbers
        // Same format as + button
        if bothNumbersAreInput() {
            if onlyOneDecimalPoint() {
                let result = Double(numbers().firstNum)! * Double(numbers().secondNum)!
                updateResultAndList("*", result)
            }
        }
    }
    
    @IBAction func btExponent(_ sender: Any) {
        // Raise first number to the power of second number
        // Same format as + button
        if bothNumbersAreInput() {
            if onlyOneDecimalPoint() {
                let result = pow(Double(numbers().firstNum)!, Double(numbers().secondNum)!)
                updateResultAndList("^", result)
            }
        }
    }
    
    @IBAction func btMinus(_ sender: Any) {
        // Subtract first number by second number
        // Same format as + button
        if bothNumbersAreInput() {
            if onlyOneDecimalPoint() {
                let result = Double(numbers().firstNum)! - Double(numbers().secondNum)!
                updateResultAndList("-", result)
            }
        }
    }
    
    @IBAction func btDivide(_ sender: Any) {
        // Divide first number by second number
        // Same format as + button
        if bothNumbersAreInput() {
            if onlyOneDecimalPoint() {
                let result = Double(numbers().firstNum)! / Double(numbers().secondNum)!
                updateResultAndList("/", result)
            }
        }
    }
    
    @IBAction func btModulus(_ sender: Any) {
        // Modulo first number by second number
        // Same format as + button
        if bothNumbersAreInput() {
            if onlyOneDecimalPoint() {
                // Modulus only works on integers
                // If Integer type is chosen:
                if scIntDouble.selectedSegmentIndex == 0 {
                    let result = Int(numbers().firstNum)! % Int(numbers().secondNum)!
                    updateResultAndList("%", Double(result))
                } else {
                    // Print error message for moduloing double(s)
                    lbResult.text = "Modulus needs Integer type"
                }
            }
        }
    }

    @IBAction func btFirstNumNegative(_ sender: Any) {
        // Toggle minus sign for first number
        // If first number has a -:
        if txNegativeFirstNum.text!.isEmpty {
            txNegativeFirstNum.text = "-"
        } else {
            txNegativeFirstNum.text = ""
        }
    }
    
    @IBAction func btSecondNumNegative(_ sender: Any) {
        // Toggle minus sign for second number
        // Same format as negative button for first number
        if txNegativeSecondNum.text!.isEmpty {
            txNegativeSecondNum.text = "-"
        } else {
            txNegativeSecondNum.text = ""
        }
    }
    
    @IBAction func changeKeyboard(_ sender: Any) {
        // Toggle type between Integer and Double
        // If selected type changed to Integer type:
        if scIntDouble.selectedSegmentIndex == 0 {
            // Change keyboard type to number pad
            toNumberPad()
        } else {
            // Change keyboard type to decimal pad
            toDecimalPad()
        }
        // Clear both text fields and retract soft keyboard
        clearNumbers()
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        // App loads
        // Change keyboard type to number pad and set first number text field as first responder and delegate
        super.viewDidLoad()
        toNumberPad()
        self.txFirstNum.delegate = self
        txFirstNum.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Tap the view
        // Resign first responder and retract soft keyboard
        txFirstNum.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func bothNumbersAreInput() -> Bool {
        // If both text fields are not blank:
        if txFirstNum.text != "" && txSecondNum.text != "" {
            return true
        } else {
            // Print error message for not filling text field(s)
            lbResult.text = "Fill first and second number"
            return false
        }
    }
    
    func onlyOneDecimalPoint() -> Bool {
        // If both text fields have one decimal point:
        if let _ = Double(numbers().firstNum), let _ = Double(numbers().secondNum) {
            return true
        } else {
            // Print error message for having more than one decimal point
            lbResult.text = "Only 1 decimal point allowed"
            return false
        }
    }
    
    func updateResultAndList(_ chosenOperator: String, _ result: Double) {
        // Create formatter and format variables
        var formattedResult = "", formattedFirstNum = "", formattedSecondNum = ""
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        // If selected type is Integer:
        if(scIntDouble.selectedSegmentIndex == 0) {
            // Format numbers and result as integer
            formattedFirstNum = formatter.string(from: NSNumber(value: Int(numbers().firstNum)!))!
            formattedSecondNum = formatter.string(from: NSNumber(value: Int(numbers().secondNum)!))!
            formattedResult = formatter.string(from: NSNumber(value: Int(result)))!
        } else {
            // Format numbers as double and result as double with 2 decimal places
            formattedFirstNum = formatter.string(from: NSNumber(value: Double(numbers().firstNum)!))!
            formattedSecondNum = formatter.string(from: NSNumber(value: Double(numbers().secondNum)!))!
            formatter.maximumFractionDigits = 2
            formattedResult = formatter.string(from: NSNumber(value: result))!
        }
        // Add formatted result to result label and new operation to top of text view
        let newOperation = "\(formattedFirstNum) \(chosenOperator) \(formattedSecondNum) = \(formattedResult)\n"
        lbResult.text = formattedResult
        tvOperationList.text = newOperation + tvOperationList.text
        
        // Retract soft keyboard and clear both text fields
        self.view.endEditing(true)
        clearNumbers()
    }
    
    func numbers() -> (firstNum:String, secondNum:String) {
        // Combine negative sign with number
        let firstNum = txNegativeFirstNum.text! + txFirstNum.text!
        let secondNum = txNegativeSecondNum.text! + txSecondNum.text!
        return (firstNum, secondNum)
    }
    
    func clearNumbers() {
        txFirstNum.text = ""
        txNegativeFirstNum.text = ""
        txSecondNum.text = ""
        txNegativeSecondNum.text = ""
    }
    
    func toNumberPad() {
        txFirstNum.keyboardType = UIKeyboardType.numberPad
        txSecondNum.keyboardType = UIKeyboardType.numberPad
    }
    
    func toDecimalPad() {
        txFirstNum.keyboardType = UIKeyboardType.decimalPad
        txSecondNum.keyboardType = UIKeyboardType.decimalPad
    }

}

