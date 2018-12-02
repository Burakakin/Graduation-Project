//
//  MyAccountViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 13.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    let arr = ["Personal Info", "Change Password","My Address","My Products" ,"My Orders"]
    
    @IBAction func myAccount(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
   
    
    
    @IBAction func SignOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("LogOut")
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let signInViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignInPageViewController") as! SignInPageViewController
            appDelegate.window?.rootViewController = signInViewController
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

extension MyAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAccountCell", for: indexPath) as! MyAccountCustomTableViewCell
        cell.myAccountLabel.text = arr[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "personalInfo", sender: self)
        case 1:
            performSegue(withIdentifier: "changePassword", sender: self)
        case 2:
            performSegue(withIdentifier: "myAddress", sender: self)
        default:
            print("Merhaba")
        }
    }
    
    
    
    
    
}
