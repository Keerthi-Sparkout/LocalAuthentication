//
//  ViewController.swift
//  OwnerAuthentication
//
//  Created by Apple on 30/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    var isBiometrics = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func fingerprintAction(_ sender: UIButton) {
        isBiometrics = true
        authenticationWithTouchID()
    }
    
    @IBAction func unlockAction(_ sender: UIButton) {
       isBiometrics = false
        authenticationWithTouchID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoWelcome()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

extension ViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        if isBiometrics
        {
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    //TODO: User authenticated successfully, take appropriate action
                    DispatchQueue.main.async {
                        // Update UI
                   
                    self.gotoWelcome()
                    }
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    self.showErrorMessage(evaluateError: evaluateError)
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            let alert = UIAlertController(title: "Alert", message: self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
        }
        else{
            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                
                localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
                    
                    if success {
                        
                        //TODO: User authenticated successfully, take appropriate action
                        DispatchQueue.main.async {
                            // Update UI
                            self.gotoWelcome()
                        }
                        
                    } else {
                        //TODO: User did not authenticate successfully, look at error and take appropriate action
                        guard let error = evaluateError else {
                            return
                        }
                        
                        let alert = UIAlertController(title: "Alert", message: self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code), preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                        
                        //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                        
                    }
                }
            } else {
                
                guard let error = authError else {
                    return
                }
                //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
               
                let alert = UIAlertController(title: "Alert", message: self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
            }
        }
    }
    
    func showErrorMessage(evaluateError: Error?) {
        guard let error = evaluateError else {
            return
        }
        
        let alert = UIAlertController(title: "Alert", message: self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
        
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}


