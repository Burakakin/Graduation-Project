//
//  SignInPageViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 10.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignInPageViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    func alert(with title: String,for message: String, fromController controller: UIViewController ){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    @IBAction func SignInButton(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                if Auth.auth().currentUser != nil {
                    // User is signed in.
                    if Auth.auth().currentUser?.isEmailVerified ?? false {
                        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        //var rootViewController = appDelegate.window?.rootViewController
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
                        let leftViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftSideMenuViewController") as! LeftSideMenuViewController
                        
                        
                        let leftSideNav = UINavigationController(rootViewController: leftViewController)
                        let centerNav = UINavigationController(rootViewController: centerViewController)
                        
                        let centerContainer: MMDrawerController = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav)
                        
                        centerContainer.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
                        centerContainer.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
                        appDelegate.centerContainer = centerContainer
                        appDelegate.window!.rootViewController = appDelegate.centerContainer
                        appDelegate.window!.makeKeyAndVisible()
                        
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        print("Succesfull")
                        //self.alert(with: "Login", for: "Succesfull", fromController: self)
                        print(user?.user.email! ?? "brk")
                    }
                    else {
                        //print("Email isnot verified")
                        self.alert(with: "E-Mail", for: "Email isnot verified", fromController: self)
                    }
                    
                   
//                    self.performSegue(withIdentifier: "MainPageSegue", sender: self)
                } else {
                    // No user is signed in.
                    // ...
                }
                
            }
            else {
                if let errCode = AuthErrorCode(rawValue: error!._code){
                    switch errCode {
                    case .wrongPassword:
                        print("Wrong Password")
                        self.alert(with: "Error", for: "Wrong Password", fromController: self)
                    case .invalidEmail:
                        print("Invalid Email")
                        self.alert(with: "E-Mail", for: "Invalid Email", fromController: self)
                    default:
                       print("Hello")
                        self.alert(with: "E-Mail", for: "Hello", fromController:self)
                    }
                }
                
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
