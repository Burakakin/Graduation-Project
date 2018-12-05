//
//  MyAddressViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 2.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MyAddressViewController: UIViewController {

    var addressDetail = [[String]]()
   
    @IBOutlet weak var addressDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddress))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addressDetail.removeAll()
        getAddress()
    }

    @objc func addAddress() {
        performSegue(withIdentifier: "addAddress", sender: self)
    }
    
    func deleteField(key: String) {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }
        var ref: DocumentReference!
        ref = Firestore.firestore().document("User/\(uid)")
        
        ref.updateData([
            "address.\(key)": FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
    }
    
    func getAddress(){
        
        var ref: DocumentReference!
        
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else { return }
        let userId = user.uid
        
        ref = Firestore.firestore().document("User/\(userId)")
        ref.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                if let homeAddress = dataDescription!["address"] as? Dictionary<String, String> {
                    print(homeAddress.keys)
                    var addressDetailArr = [String]()
                    for key in homeAddress.keys {
                        addressDetailArr = ["\(key)", "\(homeAddress[key] ?? "")" ]
                         self.addressDetail.append(addressDetailArr)
                    }
                    DispatchQueue.main.async {
                        self.addressDetailTableView.reloadData()
                    }
                   
                }
            } else {
                print("document doesn't exit")
            }
        }
    }

}

extension MyAddressViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! MyAddressTableViewCell
        
       let address = addressDetail[indexPath.row]
    
        cell.addressNameLabel.text = address[0]
        cell.fullAddressLabel.text = address[1]
        
       
        cell.deleteButtonTapped = { (selectedCell) -> Void in
            let path = tableView.indexPathForRow(at: selectedCell.center)!
            let selectedKey = self.addressDetail[path.row][0]
            self.deleteField(key: selectedKey)
            self.addressDetail.removeAll()
            self.getAddress()
            
        }
        
        return cell
    }
    
    
    
    
    
    
}
