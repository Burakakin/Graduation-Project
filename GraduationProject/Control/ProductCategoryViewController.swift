//
//  ProductCategoryViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 6.09.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProductCategoryViewController: UIViewController {

    var ref: CollectionReference!
    
    var productCategoryArray = [[String: Any]]()
    
    var subCategory: String?
    var documentId: String?
    
    @IBOutlet weak var productCategoryPageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newBtn = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(leftSideButtonTapped))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = newBtn
        self.navigationItem.title = (subCategory ?? "") + (documentId ?? "")
        //print(subCategory)
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().collection("Furniture/\(documentId ?? "")/\(newId)")
        getProducts()
        // Do any additional setup after loading the view.
    }
    
    @objc func leftSideButtonTapped()  {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    
    @IBAction func unWindToProductCategoryVC (_ unwindSegue: UIStoryboardSegue){
    
        print("Welcome to Product Category Page")
    
    }
    
    
    
    
    func getProducts() {
        
      
        let query = ref.whereField("subCategory", isEqualTo: "\(subCategory ?? "")")
        query.getDocuments() { (querySnapshot, err) in
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
                        self.productCategoryArray.append(productData)
                        self.productCategoryPageCollectionView.reloadData()
                    }
                }
            }
        }
        
    }

}

extension ProductCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productPageCell", for: indexPath) as! ProductCategoryPageCollectionViewCell
        
        var product = productCategoryArray[indexPath.row]
        
        cell.productNameLabel.text = (product["name"] as! String)
        cell.productDescriptionLabel.text = (product["description"] as! String)
        cell.productPriceLabel.text = "TL" + String(product["price"] as! Int)
        cell.productDimensionLabel.text = (product["dimension"] as! String)
        
        imageDownload.getImage(withUrl: product["imageUrl"] as! String) { (image) in
            cell.productImageView.image = image
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: "productCategoryDetail", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "productCategoryDetail" {
            let rowSelected = (sender as! IndexPath).row
            if let productDetailVC =  segue.destination as? ProductDetailViewController {
                let newId = "all" + (documentId ?? "")
                productDetailVC.documentId = documentId
                productDetailVC.newId = newId
                productDetailVC.productDetailId = (productCategoryArray[rowSelected]["id"] as! String)
            }
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
        
        if segue.identifier == "filterSegue" {
            if let filterCategoryVC =  segue.destination as? FilterProductCategoryViewController {
                filterCategoryVC.documentId = documentId
            }
        }
        
       
    }
    
}
