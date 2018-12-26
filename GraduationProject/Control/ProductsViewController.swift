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
    
    var ref: CollectionReference!
    var imageArray = [String]()
    var productArray = [[String: Any]]()
     var priceFilter1 = [[String: Any]]()
     var priceFilter2 = [[String: Any]]()
    
    var priceFilterSet1 = [String]()
    var priceFilterSet2 = [String]()
    
    var output = [String]()
    var labelSubCategory = [String]()
    
    
    @IBOutlet weak var productPageCollectionView: UICollectionView!
    @IBOutlet weak var productPageTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: documentId))")
        
        let newBtn =  UIBarButtonItem(image: UIImage(named: "menu.png"), style: .plain, target: self, action: #selector(leftSideButtonTapped))
       
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = newBtn
        self.navigationItem.title = "All " + (documentId ?? "")
        
        
        let icon = UIImage(named: "sort")!
        sortButton.setImage(icon, for: .normal)
        sortButton.imageView?.contentMode = .scaleAspectFit
        sortButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        
        let iconf = UIImage(named: "filter")!
        filterButton.setImage(iconf, for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        let notificationButton = SSBadgeButton()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        notificationButton.setImage(UIImage(named: "shoppingCard")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 0)
        //notificationButton.badge = "5"
       
        notificationButton.addTarget(self, action: #selector(shoppingCard), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(shoppingCard))
        
        // Do any additional setup after loading the view.
        
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().collection("Furniture/\(documentId ?? "")/\(newId)")
        let query = ref
        getsubCollectionFurniture()
        getAllProduct(queryFirestore: query!)
    }
    
    @objc func shoppingCard() {
        
        let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingCardViewController") as! ShoppingCardViewController
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController
    }
    
    func findIntersection (firstArray : [String], secondArray : [String]) -> [String]
    {
        return [String](Set<String>(firstArray).intersection(secondArray))
    }

    

    @objc func leftSideButtonTapped()  {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @IBAction func unWindToProductVC (_ sender: UIStoryboardSegue){
        
        guard let priceFilterVC = sender.source as? PriceFilterViewController else { return }
        let minValue = Int(priceFilterVC.minValueTextField.text!)
        let maxValue = Int(priceFilterVC.maxValueTextField.text!)
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().collection("Furniture/\(documentId ?? "")/\(newId)")
       
        priceFilterSet2.removeAll()
        priceFilterSet1.removeAll()
        priceFilter1.removeAll()
        priceFilter2.removeAll()
        productArray.removeAll()
        
        if minValue == nil && maxValue == nil {
            print("Hello")
        }
        else if minValue == nil {
            let isLessThanQuery = ref.whereField("priceInt", isLessThanOrEqualTo: maxValue!)
            
            getAllProduct(queryFirestore: isLessThanQuery)
        }
        else if maxValue == nil {
            let isGreaterThanQuery = ref.whereField("priceInt", isGreaterThanOrEqualTo: minValue!)
           
            getAllProduct(queryFirestore: isGreaterThanQuery)
        }
        else if minValue != nil && maxValue != nil {
             let isLessThanQuery = ref.whereField("priceInt", isLessThanOrEqualTo: maxValue!)
            let isGreaterThanQuery = ref.whereField("priceInt", isGreaterThanOrEqualTo: minValue!)
      
            isLessThanQuery.getDocuments() { (querySnapshot, err) in
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
                            self.priceFilter1.append(productData)
                           self.priceFilterSet1.append("\(document.documentID)")
                            self.output =  self.findIntersection(firstArray: self.priceFilterSet1, secondArray: self.priceFilterSet2)
                            for item in self.output {
                                if productData["id"] as? String == item {
                                    self.productArray.append(productData)
                                }
                                self.productPageTableView.reloadData()
                            }
                            
                        }
                        
                    }
                }
            }
            isGreaterThanQuery.getDocuments() { (querySnapshot, err) in
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
                            self.priceFilter2.append(productData)
                            self.priceFilterSet2.append("\(document.documentID)")
                            self.output =  self.findIntersection(firstArray: self.priceFilterSet1, secondArray: self.priceFilterSet2)
                            for item in self.output {
                                if productData["id"] as? String == item {
                                    self.productArray.append(productData)
                                }
                            }
                            self.productPageTableView.reloadData()
                        }
                        
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func unWindToColorProductVC (_ sender: UIStoryboardSegue){
        guard let filterDetailVC = sender.source as? FilterDetailProductCategoryViewController else { return }
        let selectedColorQuery =  filterDetailVC.selectedColor
        productArray.removeAll()
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().collection("Furniture/\(documentId ?? "")/\(newId)")
        let colorFilterQuery = ref.whereField("color", isEqualTo: selectedColorQuery!)
        getAllProduct(queryFirestore: colorFilterQuery)
    }
    
    @IBAction func unWindSorttoProductVC (_ sender: UIStoryboardSegue){
        guard let sortFilterVC = sender.source as? SortFilterViewController else { return }
        let sortQuery =  sortFilterVC.sortQuery
        if sortQuery == nil {
            print("Hello")
        }
        else {
            productArray.removeAll()
            getAllProduct(queryFirestore: sortQuery!)
        }
        
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
                    self.labelSubCategory = ["Home","Office"]
                    DispatchQueue.main.async {
                        self.productPageCollectionView.reloadData()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getAllProduct(queryFirestore: Query) {
    
        queryFirestore.getDocuments() { (querySnapshot, err) in
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
        
        cell.productPageLabel.text = labelSubCategory[indexPath.row]
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
        cell.productPriceLabel.text =  String(product["price"] as! String) + " TL" 
        cell.productDimensionLabel.text = (product["dimension"] as! String)
        cell.productSellerLabel.text = "Seller: " + (product["seller"] as! String)
        
        imageDownload.getImage(withUrl: product["imageUrl"] as! String) { (image) in
            cell.producImageView.image = image
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "productDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "filterSegue" {
            if let filterCategoryVC =  segue.destination as? FilterProductCategoryViewController {
                filterCategoryVC.documentId = documentId
            }
        }
        
        if segue.identifier == "sortSegue" {
            if let sortFilterVC =  segue.destination as? SortFilterViewController {
                sortFilterVC.documentId = documentId
            }
        }
        
        if segue.identifier == "productDetail" {
            let rowSelected = (sender as! IndexPath).row
            if let productDetailVC =  segue.destination as? ProductDetailViewController {
                let newId = "all" + (documentId ?? "")
                productDetailVC.documentId = documentId
                productDetailVC.newId = newId
                productDetailVC.productDetailId = (productArray[rowSelected]["id"] as! String)
            }
        }
        if segue.identifier == "productCategory" {
            let rowSelected = (sender as! IndexPath).row
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
