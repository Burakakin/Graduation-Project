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
        self.navigationItem.title = "All " + (documentId ?? "")
        
        
        
        let notificationButton = SSBadgeButton()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        notificationButton.setImage(UIImage(named: "shoppingCard")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 0)
        notificationButton.badge = "5"
       
        notificationButton.addTarget(self, action: #selector(shoppingCard), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(shoppingCard))
        
        // Do any additional setup after loading the view.
        getsubCollectionFurniture()
        getAllProduct()
    }
    
    @objc func shoppingCard() {
        print("brk")
    }
    
    

    @objc func leftSideButtonTapped()  {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    func getsubCollectionFurniture() {
        //homeDesk
        //print("home" + "\(self.documentId ?? "")")
        var ref: DocumentReference!
        ref = Firestore.firestore().document("Furniture/\(documentId ?? "")")
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                if let subCategory = document.data()!["subCategory"] as? Dictionary<String, AnyObject> {
                    let home = subCategory["home" + "\(self.documentId ?? "")"] as! String
                    let office = subCategory["office" + "\(self.documentId ?? "")"] as! String
                    
                    self.imageArray = [home, office]
                    DispatchQueue.main.async {
                        self.productPageCollectionView.reloadData()
                    }
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
                    let price = document.data()["price"] as! String
                    let dimension = document.data()["dimension"] as! String
                    let seller = document.data()["seller"] as! String
                    
                    let productData: [String: Any] = ["id": document.documentID, "name": name, "description": description, "imageUrl": imageUrl, "price": price, "dimension": dimension, "seller": seller]
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath)
        performSegue(withIdentifier: "productCategory", sender: indexPath)
        
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
        cell.productPriceLabel.text = "TL" + String(product["price"] as! String)
        cell.productDimensionLabel.text = (product["dimension"] as! String)
        cell.productSellerLabel.text = (product["seller"] as! String)
        
        imageDownload.getImage(withUrl: product["imageUrl"] as! String) { (image) in
            cell.producImageView.image = image
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "productDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rowSelected = (sender as! IndexPath).row
        if segue.identifier == "productDetail" {
            if let productDetailVC =  segue.destination as? ProductDetailViewController {
                let newId = "all" + (documentId ?? "")
                productDetailVC.documentId = documentId
                productDetailVC.newId = newId
                productDetailVC.productDetailId = (productArray[rowSelected]["id"] as! String)
            }
        }
        if segue.identifier == "productCategory" {
            if let productCategory = segue.destination as? ProductCategoryViewController {
                if rowSelected == 0 {
                    productCategory.subCategory = "home"
                    productCategory.documentId = documentId
                }
                else if rowSelected == 1 {
                    productCategory.subCategory = "office"
                    productCategory.documentId = documentId
                }
            }
            
        }
        
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
}
