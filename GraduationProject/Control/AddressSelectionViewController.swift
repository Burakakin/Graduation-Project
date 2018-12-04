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

class AddressSelectionViewController: UIViewController {

    var addressDetail = [[String]]()
    
    @IBOutlet weak var addressSelectionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Address Selection"
        getAddressToSelect()
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
                    print(homeAddress.keys)
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
        cell.checkedButton.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func buttonSelected(sender: UIButton) {
        print("Button")
        
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
    }
    
    
}
