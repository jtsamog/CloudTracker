//
//  SignupViewController.swift
//  FoodTracker
//
//  Created by Endeavour2 on 8/1/17.
//  Copyright © 2017 SamOg. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

  //MARK: Properties
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var messageLabel: UILabel!
  
  
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()


    usernameTextField.delegate = self
    passwordTextField.delegate = self
    messageLabel.isHidden = true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //hide the keyboard
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    return true
  }
  
  //MARK: Actions
  @IBAction func signupButtonPressed(_ sender: UIButton) { //sign up should be valid
    guard (usernameTextField.text as String!) != nil else{
      
      self.messageLabel.isHidden = false
      return
    }
    
    guard (passwordTextField.text as String!) != nil else{
      
      self.messageLabel.isHidden = false
      return
    }
    
    guard ((passwordTextField.text!.characters.count) as Int) > 5 else {
      
      self.messageLabel.isHidden = false
      return
    }
    
    
    let postData = [
      "username": usernameTextField.text ?? "",
      "password": passwordTextField.text ?? ""
    ]
    
    let defaults = UserDefaults.standard
    let cloudTracker = CloudAPI()
    
    cloudTracker.post(data: postData as [String : AnyObject], toEndpoint: "signup", completion: {
      
      (completion:(data: Data?, error: NSError?)) in
      guard let rawJSON = try? JSONSerialization.jsonObject(with: completion.data!, options: []) as! [String:[String:String]] else {
        
        print("data returned is not json, or not valid")
        return
      }
      
      defaults.set(rawJSON["user"], forKey: "user")
      self.dismiss(animated: true, completion: nil)
    })
  }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
