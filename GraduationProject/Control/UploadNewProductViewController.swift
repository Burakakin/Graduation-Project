//
//  UploadNewProductViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 3.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UploadNewProductViewController: UIViewController {

    var ref: CollectionReference!
    var refDoc: DocumentReference!
    var productArray = [[String: String]]()
    
    @IBOutlet weak var uploadProductTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Products"
        // Do any additional setup after loading the view.
        
        
       getAllSellerProduct()
       
    }
    
    func getAllSellerProduct() {
        
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else { return }
        let userId = user.uid
        
        
        
        
        refDoc = Firestore.firestore().document("User/\(userId)")
        refDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let name = data!["nameSurname"] as! String
                
                self.ref = Firestore.firestore().collection("Furniture/Desk/allDesk")
                var query = self.ref.whereField("seller", isEqualTo: name)
                self.getMyProduct(query: query)
                self.ref = Firestore.firestore().collection("Furniture/Desk/allDesk")
                query = self.ref.whereField("seller", isEqualTo: name)
                self.getMyProduct(query: query)
                
            } else {
                print("Document does not exist")
            }
        }
    }

    @IBAction func leftSideButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    

    func getMyProduct(query: Query) {
        
       
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let name = document.data()["name"] as! String
                    let description = document.data()["description"] as! String
                    let imageUrl = document.data()["imageUrl"] as! String
                    let price = document.data()["price"] as! String
                    let dimension = document.data()["dimension"] as! String
                    let seller = document.data()["seller"] as! String
                    
                    
                    let productData: [String: String] = ["id": document.documentID, "name": name, "description": description, "imageUrl": imageUrl, "price": price, "dimension": dimension, "seller": seller]
                    DispatchQueue.main.async {
                        self.productArray.append(productData)
                        self.uploadProductTableView.reloadData()
                    }
                    
                    
                }
            }
        }
        
       
    }
    
}


extension UploadNewProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uploadProductCell", for: indexPath) as! AddProductTableViewCell
        
        var product = productArray[indexPath.row]
        
        cell.productNameLabel.text = product["name"]
        cell.productDescriptionLabel.text = product["description"]
        cell.productPriceLabel.text =  product["price"]! + " TL" 
        cell.productSellerLabel.text = "Seller: " + product["seller"]!
        imageDownload.getImage(withUrl: product["imageUrl"]!) { (image) in
            cell.productImageView.image = image
        }
        
        
        return cell
    }
    
    
    
    
    
}
