//
//  LastViewedViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 7.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class LastViewedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Last Viewed"
        // Do any additional setup after loading the view.
        
    }
    
     var lastViewedDictionary = [[String: String]]()
    @IBOutlet weak var lastViewedTableView: UITableView!
    
    @IBAction func leftSideButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lastViewedDictionary.removeAll()
        getLastViewed()
    }
    
    func getLastViewed() {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }
        var ref: DocumentReference!
        var refItem: DocumentReference!
        ref = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                if let lastViewed = data["lastViewed"] as? [String] {
                    for item in lastViewed {
                        refItem = Firestore.firestore().document("\(item)")
                        refItem.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let dataFavourite = document.data()!
                                let imageUrl = dataFavourite["imageUrl"] as! String
                                //let category = dataFavourite["category"] as! String
                                let name = dataFavourite["name"] as! String
                                let description = dataFavourite["description"] as! String
                                let price = dataFavourite["price"] as! String
                                let dimension = dataFavourite["dimension"] as! String
                                
                                let dataDic = ["name": name,"imageUrl": imageUrl, "description": description, "price": price, "dimension": dimension ]
                                DispatchQueue.main.async {
                                    self.lastViewedDictionary.append(dataDic)
                                    self.lastViewedTableView.reloadData()
                                }
                            } else {
                                print("Document does not exist")
                            }
                        }
                    }
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    

}


extension LastViewedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastViewedDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lastViewedCell", for: indexPath) as! LastViewedTableViewCell
        
        let index = lastViewedDictionary[indexPath.row]
        
        cell.lastViewedProductName.text = index["name"]
        
        
        
        return cell
    }
    
    
    
    
    
    
}
