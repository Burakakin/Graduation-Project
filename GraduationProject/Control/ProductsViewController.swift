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
