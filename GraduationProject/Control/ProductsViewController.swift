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
        
        var ref: CollectionReference!
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().collection("Furniture/\(documentId ?? "")/\(newId)")
        
        
    }
    
    

}


extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionCell", for: indexPath) as! ProductPageCollectionViewCell
        cell.productPageImageView.download(url: imageArray[indexPath.row])
        
        return cell
    }
    
    
    
    
}


extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productTableCell", for: indexPath) as! ProductPageTableViewCell
        cell.productPageLabel.text = "burak"
        
        return cell
    }
    
    
    
    
    
    
}
