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

    var ref: DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(subCategory)
        getProducts()
        // Do any additional setup after loading the view.
    }
    
    var subCategory: String?
    var documentId: String?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getProducts() {
        let ref: CollectionReference!
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().collection("Furniture/\(documentId ?? "")/\(newId)")
        let query = ref.whereField("subCategory", isEqualTo: "\(subCategory ?? "")")
        
        
    }

}

extension ProductCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productPageCell", for: indexPath) as! ProductCategoryPageCollectionViewCell
        return cell
    }
    
    
    
    
    
}
