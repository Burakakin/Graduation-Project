//
//  ShoppingCardViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 1.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ShoppingCardViewController: UIViewController {

    
    var ref: DocumentReference!
    var refItem: DocumentReference!
   
    var shoppingCartArr = [[String: String]]()
    
    @IBOutlet weak var shoppingCartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShoppingCartPath()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func leftSideButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
   
    
    func getShoppingCartPath() {
        
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }
        ref = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let shoppingCartArr = data!["shoppingCart"] as? [String] {
                    for item in shoppingCartArr {
                        self.refItem = Firestore.firestore().document("\(item)")
                        self.refItem.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let dataDescription = document.data()
                                let imageUrl = dataDescription!["imageUrl"] as! String
                                let name = dataDescription!["name"] as! String
                                let seller = dataDescription!["seller"] as! String
                                let description = dataDescription!["description"] as! String
                                let price = dataDescription!["price"] as! String
                                //print("Document data: \(dataDescription)")
                                let shoppingCart: [String: String] = ["name": name, "imageUrl": imageUrl, "description": description, "seller": seller, "price": price]
                                DispatchQueue.main.async {
                                    
                                    self.shoppingCartArr.append(shoppingCart)
                                    self.shoppingCartTableView.reloadData()
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


extension ShoppingCardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCartArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath) as! ShoppingCardTableViewCell
        
        cell.shoppingCardProductName.text = shoppingCartArr[indexPath.row]["name"]
        cell.shoppingCardProductDescription.text = shoppingCartArr[indexPath.row]["description"]
        cell.shoppingCardProductSeller.text = shoppingCartArr[indexPath.row]["seller"]
        imageDownload.getImage(withUrl: shoppingCartArr[indexPath.row]["imageUrl"]!) { (image) in
            cell.shoppingCardProductImageView.image = image
        }
        
        cell.PlusButtonTapped = { (selectedCell) -> Void in
            let path = tableView.indexPathForRow(at: selectedCell.center)!
            let selectedItem = self.shoppingCartArr[path.row]
            print("Slm")
           
        }
        
        
        return cell
    }
    
    
}
