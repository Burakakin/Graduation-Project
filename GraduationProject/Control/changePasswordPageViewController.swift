//
//  changePasswordPageViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 23.11.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class changePasswordPageViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func updatePasswordButton(_ sender: Any) {
        
        
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let oldPassword = oldPasswordTextField.text, !oldPassword.isEmpty else { return }
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else { return }
        
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else { return }
        let userId = user.uid
        
        var credential: AuthCredential
        credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        user.reauthenticateAndRetrieveData(with: credential, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                guard let result = result else { return }
                print(result)
            }
            
        })
        
        user.updatePassword(to: newPassword, completion: { (error) in
            if let error = error {
                // An error happened.
                print(error.localizedDescription)
            } else {
                // password updated.
                self.ref = Firestore.firestore().document("User/\(userId)")
                self.ref?.updateData([
                    "password": newPassword
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Password and document successfully updated")
                    }
                }
                
            }
        })
        
        
    }
    
   

  

}
