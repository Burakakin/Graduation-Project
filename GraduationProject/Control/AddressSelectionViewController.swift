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
            let path = tableView.indexPathForRow(at: selectedCell.center)!
            let selectedKey = self.addressDetail[path.row]
            //print(selectedKey)
            self.selectedAddress = selectedKey
            cell.checkedButton.isSelected = !cell.checkedButton.isSelected
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
