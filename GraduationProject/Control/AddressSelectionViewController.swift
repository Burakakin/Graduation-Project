//
//  AddressSelectionViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 5.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import UserNotifications

class AddressSelectionViewController: UIViewController, UNUserNotificationCenterDelegate {

    var addressDetail = [[String]]()
    var selectedAddress = [String]()
    var selectedIndex = [Int]()
    
    @IBOutlet weak var addressSelectionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

      
        navigationItem.title = "Address Selection"
        getAddressToSelect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Disappear: \(selectedAddress)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    @IBAction func completeOrder(_ sender: Any) {
       
        if !selectedIndex.isEmpty {
            if selectedIndex.count != 2 {
            var orders = [String: String]()
            
            let refDoc: DocumentReference!
            let user = Auth.auth().currentUser
            guard let uid = user?.uid else { return }
            refDoc = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
            
            refDoc.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()!
                    if let shoppingCart = data["shoppingCart"] as? Dictionary<String, String>{
                        orders = shoppingCart
                        refDoc.setData([ "order": orders ], merge: true)
                        
                        for key in shoppingCart.keys {
                            refDoc.updateData([
                                "shoppingCart.\(key)": FieldValue.delete(),
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Shopping Cart was deleted")
                                    }
                            }
                            
                        }
                    }
                    
                } else {
                    print("Document does not exist")
                }
            }
            
            //creating the notification content
            let content = UNMutableNotificationContent()
            
            //adding title, subtitle, body and badge
            content.title = "Hey this is Simplified iOS"
            content.subtitle = "iOS Development is fun"
            content.body = "We are learning about iOS Local Notification"
            content.sound = UNNotificationSound.default
            //content.badge = 1
            
            //getting the notification trigger
            //it will be called after 5 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //getting the notification request
            let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            
            //adding the notification to notification center
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            
            
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            
            
            }
            else {
                alert(with: "Address Selection", for: "Please, Select Only ONE Adreess", fromController: self)
            }
        }
        else{
            alert(with: "Address Selection", for: "Please, Select an Adreess", fromController: self)
        }
        
        
        
    }
    
    
    func alert(with title: String,for message: String, fromController controller: UIViewController ){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func getAddressToSelect(){
        
        var ref: DocumentReference!
        
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else { return }
        let userId = user.uid
        
        ref = Firestore.firestore().document("User/\(userId)")
        ref.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                if let homeAddress = dataDescription!["address"] as? Dictionary<String, String> {
                    //print(homeAddress.keys)
                    var addressDetailArr = [String]()
                    for key in homeAddress.keys {
                        addressDetailArr = ["\(key)", "\(homeAddress[key] ?? "")" ]
                        self.addressDetail.append(addressDetailArr)
                        DispatchQueue.main.async {
                            self.addressSelectionTableView.reloadData()
                        }
                    }
                    
                    
                }
            } else {
                print("document doesn't exit")
            }
        }
    }
  

}

extension AddressSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressSelectionCell", for: indexPath) as! AddressSelectionTableViewCell
        
        
        let address = addressDetail[indexPath.row]
        
        cell.addressNameLabel.text = address[0]
        cell.fullAddressLabel.text = address[1]
        
        cell.checkedButtonTapped = { (selectedCell) -> Void in
             //cell.checkedButton.isSelected = !cell.checkedButton.isSelected
            let path = tableView.indexPathForRow(at: selectedCell.center)!

            
            if self.selectedIndex.contains(path.row){
                let indexCell = self.selectedIndex.firstIndex(of: path.row)
                self.selectedIndex.remove(at: indexCell!)
                cell.checkedButton.isSelected = false

            }
            else {
                cell.checkedButton.isSelected = true
                self.selectedIndex.append(path.row)
                let selectedKey = self.addressDetail[path.row]
                self.selectedAddress = selectedKey
            }
            
           
            
           
            
            
           
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .none
        }
    }
    
    
    
    
    
}
