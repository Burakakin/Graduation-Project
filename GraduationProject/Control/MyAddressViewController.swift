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
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        
       let address = addressDetail[indexPath.row]
    
        cell.textLabel?.text = address[0]
        cell.detailTextLabel?.text = address[1]
        
       
        
        return cell
    }
    
    
    
    
    
    
}
