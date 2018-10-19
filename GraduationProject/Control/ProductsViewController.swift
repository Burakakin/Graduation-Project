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
    var ref: DocumentReference!
    
    var subCollections = [[String: Any]]()
    var imageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: documentId))")
        
        let newBtn = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(leftSideButtonTapped))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = newBtn
        // Do any additional setup after loading the view.
        getAllFurniture()
    }
    

    @objc func leftSideButtonTapped()  {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    func getAllFurniture() {
        
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

}
