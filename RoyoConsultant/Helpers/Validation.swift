//
//  Validation.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit


//MARK:- Alert messages to be appeared on failure
enum AlertMessage: String {
    case EMPTY_EMAIL
    case INVALID_EMAIL
    
    case EMPTY_PHONE
    case INVALID_PHONE
    
    case EMPTY_PASSWORD
    case INVALID_PASSWORD
    
    case EMPTY_NAME
    case INVALID_NAME
    
    case EMPTY_DOB
    case INVALID_DOB
    
    case EMPTY_RE_ENTER_PASSWORD
    case PASSWORD_NOT_MATCHED
    
    case EMPTY_BIO
    case INVALID_BIO
    
    case EMPTY_ADDRESS
    case INVALID_ADDRESS
    
    case EMPTY_STATE
    case INVALID_STATE
    
    case EMPTY_CITY
    case INVALID_CITY
    
    case EMPTY_ZIP
    case INVALID_ZIP
    
    case EMPTY_OLD_PSW
    case EMPTY_NEW_PSW
    case EMPTY_CONNFIRM_PSW
    
    case EMPTY_REALATION
    case EMPTY_MEDICAL_ALLERGY
    case SELECT_CHRONIC_DISESE_ALERT
    case EMPTY_MEDICATION_NAME
    
    case EMPTY_WEIGHT
    case EMPTY_HEIGHT
    
    case NO_DOC_UPLOAD
    case EMPTY_INSURANCE_NUMBER
    case EMPTY_INSURANCE_EXPIRY
    case EMPTY_BANK_NAME
    case EMPTY_IBAN
    
    var localized: String {
        return NSLocalizedString(self.rawValue, tableName: Configuration.getValue(for: .PROJECT_LOCALIZABLE), comment: "")
    }
}

//MARK:- Check validation failed or not
enum Valid {
    case success
    case failure(AlertType, AlertMessage)
}

//MARK:- RegExes used to validate various things
enum RegEx: String {
    case EMAIL = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case PASSWORD = "^.{8,100}$" // Password length 8-100
    case NAME = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case PHONE_NO = "(?!0{5,15})^[0-9]{5,15}" // PhoneNo 5-15 Digits
    case All = "ANY_TEXT"
}

//MARK:- Validation Type Enum to be used with value that is to be validated when calling validate function of this class
enum ValidationType {
    case EMAIL
    case PHONE
    case NAME
    case PASSWORD
    case DOB
    case ReEnterPassword
    case BIO
    case ADDRESS
    case STATE
    case CITY
    case ZIP
    case OLD_PSW
    case NEW_PSW
    case CONFIRM_PSW
    case RELATION
    case MEDICAL_ALLERGY
    case HEIGHT
    case WEIGHT
    case IMAGE_DOC
    case INSURANCE_NUMBER
    case INSURANCE_EXPIRY
    case BANK_NAME
    case IBAN
}

class Validation {
    //MARK:- Shared Instance
    static let shared = Validation()
    
    func validate(values: (type: ValidationType, input: String)...) -> Valid {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .EMAIL:
                if let tempValue = isValidString((valueToBeChecked.input, .EMAIL, .EMPTY_EMAIL, .INVALID_EMAIL)) {
                    return tempValue
                }
            case .PHONE:
                if let tempValue = isValidString((valueToBeChecked.input, .PHONE_NO, .EMPTY_PHONE, .INVALID_PHONE)) {
                    return tempValue
                }
            case .NAME:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_NAME, .INVALID_NAME)) {
                    return tempValue
                }
            case .PASSWORD:
                if let tempValue = isValidString((valueToBeChecked.input, .PASSWORD, .EMPTY_PASSWORD, .INVALID_PASSWORD)) {
                    return tempValue
                }
            case .DOB:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_DOB, .INVALID_DOB)) {
                    return tempValue
                }
            case .ReEnterPassword:
                if let tempValue = isValidString((valueToBeChecked.input, .PASSWORD, .EMPTY_RE_ENTER_PASSWORD, .INVALID_PASSWORD)) {
                    return tempValue
                }
            case .BIO:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_BIO, .INVALID_BIO)) {
                    return tempValue
                }
            case .ADDRESS:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_ADDRESS, .INVALID_ADDRESS)) {
                    return tempValue
                }
            case .STATE:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_STATE, .INVALID_STATE)) {
                    return tempValue
                }
            case .CITY:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_CITY, .INVALID_CITY)) {
                    return tempValue
                }
            case .ZIP:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_ZIP, .INVALID_ZIP)) {
                    return tempValue
                }
            case .OLD_PSW:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_OLD_PSW, .EMPTY_OLD_PSW)) {
                    return tempValue
                }
            case .NEW_PSW:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_NEW_PSW, .EMPTY_NEW_PSW)) {
                    return tempValue
                }
            case .CONFIRM_PSW:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_CONNFIRM_PSW, .EMPTY_CONNFIRM_PSW)) {
                    return tempValue
                }
            case .RELATION:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_REALATION, .EMPTY_REALATION)) {
                    return tempValue
                }
            case .MEDICAL_ALLERGY:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_MEDICAL_ALLERGY, .EMPTY_MEDICAL_ALLERGY)) {
                    return tempValue
                }
            case .HEIGHT:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_HEIGHT, .EMPTY_HEIGHT)) {
                    return tempValue
                }
            case .WEIGHT:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_WEIGHT, .EMPTY_WEIGHT)) {
                    return tempValue
                }
            case .IMAGE_DOC:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .NO_DOC_UPLOAD, .NO_DOC_UPLOAD)) {
                    return tempValue
                }
            case .INSURANCE_NUMBER:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_INSURANCE_NUMBER, .EMPTY_INSURANCE_NUMBER)) {
                    return tempValue
                }
            case .INSURANCE_EXPIRY:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_INSURANCE_EXPIRY, .EMPTY_INSURANCE_EXPIRY)) {
                    return tempValue
                }
            case .BANK_NAME:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_BANK_NAME, .EMPTY_BANK_NAME)) {
                    return tempValue
                }
            case .IBAN:
                if let tempValue = isValidString((valueToBeChecked.input, .All, .EMPTY_IBAN, .EMPTY_IBAN)) {
                    return tempValue
                }
            }
        }
        return .success
    }
    
    private func isValidString(_ input: (text: String, regex: RegEx, emptyAlert: AlertMessage, invalidAlert: AlertMessage)) -> Valid? {
        if (input.regex == .PHONE_NO) && (input.text.trimmingCharacters(in: .whitespacesAndNewlines) != "") && Int(input.text) == 0 {
            return .failure(.validationFailure, AlertMessage.INVALID_PHONE)
        }
        
        if /input.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return .failure(.validationFailure, input.emptyAlert)
        } else if isValidRegEx(input.text.trimmingCharacters(in: .whitespacesAndNewlines), input.regex) != true {
            return .failure(.validationFailure, input.invalidAlert)
        }
        return nil
    }
    //MARK:- Validating input value with RegEx
    private func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        if regex == .All {
            return true
        } else if regex == .EMAIL {
            return !((/testStr).first == ".") && result
        } else {
            return result
        }
    }
    //MARK:- Special method to validate email and phone number in one field
    private func validateForEmailOrPhoneNumber(_ stringToTest: String, emailRegEx: RegEx, phoneRegEx: RegEx) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx.rawValue)
        let phoneText = NSPredicate(format:"SELF MATCHES %@", phoneRegEx.rawValue)
        return ((emailTest.evaluate(with: stringToTest)) && !((/stringToTest).first == ".")) || phoneText.evaluate(with: stringToTest)
    }
}
