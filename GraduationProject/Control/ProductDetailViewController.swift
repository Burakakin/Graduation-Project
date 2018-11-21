//
//  ProductDetailViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 19.11.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import ImageSlideshow

class ProductDetailViewController: UIViewController {

    var documentId: String?
    var newId: String?
    var productDetailId: String?
    
    var ref: CollectionReference!
    var reference: DocumentReference!
    
    @IBOutlet weak var imageSlider: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(abc))
        //self.navigationController?.view.backgroundColor = .clear
        
        setupImageSlider()
    }
    
    @objc func abc() {
        print("buttonTapped")
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    
    func setupImageSlider() {
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        imageSlider.pageIndicator = pageIndicator
        
        imageSlider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .right(padding: 10), vertical: .bottom)
        
        imageSlider.setImageInputs([ImageSource(image: UIImage(named: "sofa.jpg")!),ImageSource(image: UIImage(named: "sofa1.jpg")!),ImageSource(image: UIImage(named: "sofa2.jpg")!)])
    }
    
    
    @IBAction func addToFavouriteButton(_ sender: UIButton) {
        
        var pathToSave: String
        pathToSave = "Furniture/\(documentId ?? "")/\(newId ?? "")/\(productDetailId ?? "")"
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let name = user.displayName
            let email = user.email
            
            
            
            ref = Firestore.firestore().collection("User")
            let query = ref.whereField("userId", isEqualTo: uid)
            query.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            
                            let myFavorite: [String: Any] = ["myFavourite": [pathToSave]]
                            self.reference =  Firestore.firestore().collection("User").document(document.documentID).collection("userDetail").document("userDetailDocument")
                            
                            self.reference.setData(myFavorite) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                }
                            }
                           
                        }
                    }
            }
            
        }
        
        
        
    
        
       
        
        
        
    }
    
    
    

}
