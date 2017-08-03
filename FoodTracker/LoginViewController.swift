//
//  LoginViewController.swift
//  FoodTracker
//
//  Created by Endeavour2 on 8/1/17.
//  Copyright © 2017 SamOg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UITextInputTraits {
  
  //MARK: Properties
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
  //MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 
    textField.resignFirstResponder()
    view.endEditing(true)
    
    return true
  }
  
  //MARK: Actions
  
  @IBAction func loginButtonPressed(_ sender: UIButton) {
    let defaults = UserDefaults.standard
    guard (usernameTextField.text! as String) == (defaults.value(forKey: "username") as? String) else {
      return
    }
    
    guard (passwordTextField.text! as String) == (defaults.value(forKey: "password") as? String) else {
      return
    }
   
    
    let postData = [
      "username": usernameTextField.text ?? "",
      "password": passwordTextField.text ?? ""
    ]
    
    guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
      print("could not serialize json")
      return
    }
    let url = URL(string: "http://cloud-tracker.herokuapp.com/login")!
    let request = NSMutableURLRequest(url: url)
    request.httpBody = postJSON
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
      guard let data = data else {
        print("no data returned from server \(error?.localizedDescription)")
        return
      }
      
      guard let response = response as? HTTPURLResponse else {
        print("no response returned from server \(error)")
        return
      }
      
      guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String,Dictionary<String,String>> else {
        print("data returned is not json, or not valid")
        return
      }
      
      guard response.statusCode == 200 else {
        // handle error
        print("an error occurred \(json["error"])")
        return
      }
    
      // do something with the json object

      let defaults = UserDefaults.standard
      defaults.set(self.usernameTextField.text!, forKey: "username")
      defaults.set(self.passwordTextField.text!, forKey: "password")
//      defaults.set(rawJSON["user"], forKey: "user")
      self.dismiss(animated: true, completion: nil)
    }
    
    task.resume()
    
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
