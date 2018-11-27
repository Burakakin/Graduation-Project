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

    @IBOutlet weak var productDetailNameLabel: UILabel!
    @IBOutlet weak var productDetailDescriptionLabel: UILabel!
    @IBOutlet weak var productDetailDimensionLabel: UILabel!
    @IBOutlet weak var productDetailPriceLabel: UILabel!
    
    
    
    
    var documentId: String?
    var newId: String?
    var productDetailId: String?
 
    var ref: DocumentReference!
    
    var productDetailData = [[String: Any]]()
    
    @IBOutlet weak var imageSlider: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(abc))
        //self.navigationController?.view.backgroundColor = .clear
        
       
        setUpProductDetail()
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
        pageIndicator.currentPageIndicatorTintColor = UIColor.black
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        imageSlider.pageIndicator = pageIndicator
        
        imageSlider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        
//        imageSlider.setImageInputs([ImageSource(image: UIImage(named: "sofa.jpg")!),ImageSource(image: UIImage(named: "sofa1.jpg")!),ImageSource(image: UIImage(named: "sofa2.jpg")!)])
        
//        for i in 0...2 {
//            imageDownload.getImage(withUrl: imageSliderUrlArray[i]) { (image) in
//                self.imageSlider.setImageInputs([ImageSource(image: image!)])
//            }
//
//        }
        
    }
    
    
    func setUpProductDetail() {
        
        
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().document("Furniture/\(documentId ?? "")/\(newId)/\(productDetailId ?? "")")
        print("Furniture/\(documentId ?? "")/\(newId)/\(productDetailId ?? "")")
        ref.getDocument() { (document, err) in
            if let document = document, document.exists {
                let productDetail = document.data()!
                //print(productDetail)
                let name = productDetail["name"] as! String
                let description = productDetail["longDescription"] as! String
                //let imageUrl = productDetail["imageUrl"] as! String
                let price = productDetail["price"] as! Int
                let dimension = productDetail["dimension"] as! String
                if let imageSliderUrl = productDetail["imageSlider"] as? [String] {
                    for images in imageSliderUrl {
                        imageDownload.getImage(withUrl: images) { (image) in
                            self.imageSlider.setImageInputs([ImageSource(image: image!),ImageSource(image: image!)])
                        }
                    }
                   
                }
                
                self.productDetailNameLabel.text = name
                self.productDetailDescriptionLabel.text = description
                self.productDetailDimensionLabel.text = dimension
                self.productDetailPriceLabel.text = String(price) + "TL"
               
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    @IBAction func addToFavouriteButton(_ sender: UIButton) {
        
//        var pathToSave: String
//        pathToSave = "Furniture/\(documentId ?? "")/\(newId ?? "")/\(productDetailId ?? "")"
//        let myFavorite: [String: Any] = ["myFavourite": [pathToSave]]
//
//        let user = Auth.auth().currentUser
//        if let user = user {
//            let uid = user.uid
//
//
//            ref = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
//            ref.getDocument{ (document, error) in
//                if let document = document, document.exists {
//                    let dataDescription = document.data()
//                    print("Document data: \(String(describing: dataDescription))")
//
//
//
//
//
//                } else {
//                    print("document doesn't exit")
//                }
//            }
//
//        }
//
//
        
    
        
       
        
        
        
    }
    
    
    

}





