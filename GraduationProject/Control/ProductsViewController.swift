//
//  ProductsViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 19.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ProductsViewController: UIViewController {

    var documentId: String?
    
    var imageArray = [String]()
    var productArray = [[String: Any]]()
    
    
    @IBOutlet weak var productPageCollectionView: UICollectionView!
    @IBOutlet weak var productPageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: documentId))")
        
        let newBtn = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(leftSideButtonTapped))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = newBtn
        // Do any additional setup after loading the view.
        getsubCollectionFurniture()
        getAllProduct()
    }
    

    @objc func leftSideButtonTapped()  {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    func getsubCollectionFurniture() {
        
        var ref: DocumentReference!
        ref = Firestore.firestore().document("Furniture/\(documentId ?? "")")
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let array = document["subCollection"] as? Array ?? [""]
                DispatchQueue.main.async {
                    self.imageArray.append(contentsOf: array)
                    self.productPageCollectionView.reloadData()
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getAllProduct() {
        
        let ref: CollectionReference!
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().collection("Furniture/\(documentId ?? "")/\(newId)")
        
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let name = document.data()["name"] as! String
                    let description = document.data()["description"] as! String
                    let imageUrl = document.data()["imageUrl"] as! String
                    let price = document.data()["price"] as! Int
                    let dimension = document.data()["dimension"] as! String
                    
                    let productData: [String: Any] = ["id": document.documentID, "name": name, "description": description, "imageUrl": imageUrl, "price": price, "dimension": dimension]
                    DispatchQueue.main.async {
                        self.productArray.append(productData)
                        self.productPageTableView.reloadData()
                    }
                    
                }
            }
        }
        
    }
    
    

}


extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionCell", for: indexPath) as! ProductPageCollectionViewCell
        imageDownload.getImage(withUrl: imageArray[indexPath.row]) { (image) in
            cell.productPageImageView.image = image
        }
        
        return cell
    }
    
    
    
    
}


extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableCell", for: indexPath) as! ProductPageTableViewCell
        
        var product = productArray[indexPath.row]
        
        cell.productNameLabel.text = (product["name"] as! String)
        cell.productDescriptionLabel.text = (product["description"] as! String)
        cell.productPriceLabel.text = String(product["price"] as! Int)
        cell.productDimensionLabel.text = (product["dimension"] as! String)
        
        imageDownload.getImage(withUrl: imageArray[indexPath.row]) { (image) in
            cell.producImageView.image = image
        }
        
        
        return cell
    }
    
    
    
    
    
    
}
