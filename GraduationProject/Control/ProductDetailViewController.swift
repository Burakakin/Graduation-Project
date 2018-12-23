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
    @IBOutlet weak var productDetailSeller: UILabel!
    @IBOutlet weak var productDetailMaterialLabel: UILabel!
    @IBOutlet weak var productDetailKeyFeatureLabel: UILabel!
    @IBOutlet weak var productDetailCareInstructionsLabel: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var addToFavouritesButton: UIButton!
    
    
    
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
       
        //self.navigationController?.view.backgroundColor = .clear
        
        
      
        setUpProductDetail()
         setupImageSlider()
        setUpLastViewed()
        selectedButtons(isSelectedPath: "shoppingCart")
        selectedButtons(isSelectedPath: "pathToLiked")
        
       
    }
    
    
    @IBAction func ARKitAction(_ sender: Any) {
      performSegue(withIdentifier: "AugmentedReality", sender: self)
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func productDetailShareButton(_ sender: Any) {
        
        let name = productDetailNameLabel.text
        let price = productDetailPriceLabel.text
        
        //print(name)
       
        // If you want to put an image
        let image : UIImage = UIImage(named: "sofa.jpg")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [name!,price!,image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
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
    
    
    func setUpLastViewed() {
        let refDoc: DocumentReference!
        let db = Firestore.firestore()
        let defaults = UserDefaults.standard
        newId = "all" + documentId!
        let pathToSave = "Furniture/\(documentId ?? "")/\(newId ?? "")/\(productDetailId ?? "")"
        var lastViewed = [String]()
        lastViewed = (defaults.array(forKey: "lastViewed") as? [String] ?? [])
        lastViewed.append(pathToSave)
        defaults.set(lastViewed, forKey: "lastViewed")
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            
            refDoc = db.document("User/\(uid)/userDetail/userDetailDocument")
            
            refDoc.setData([ "lastViewed": lastViewed ], merge: true)
            
            refDoc!.updateData([
                "lastViewed": lastViewed
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
    }
    
    func setUpProductDetail() {
        
        
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().document("Furniture/\(documentId ?? "")/\(newId)/\(productDetailId ?? "")")
        print("Furniture/\(documentId ?? "")/\(newId)/\(productDetailId ?? "")")
        ref.getDocument() { (document, err) in
            if let document = document, document.exists {
                let productDetail = document.data()!
                //print(productDetail)
                var materialString = [String]()
                var careInstructionsString = [String]()
                let name = productDetail["name"] as! String
                let description = productDetail["longDescription"] as! String
                //let imageUrl = productDetail["imageUrl"] as! String
                let price = productDetail["price"] as! String
                let dimension = productDetail["dimension"] as! String
                let seller = productDetail["seller"] as! String
                let keyFeatures = productDetail["keyFeatures"] as! String
                if let material = productDetail["material"] as? [String] {
                    materialString = material
                }
                //let imageUrl = productDetail["imageUrl"] as! String
                if let careInstructions = productDetail["careInstructions"] as? [String] {
                    careInstructionsString = careInstructions
                }
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
                self.productDetailSeller.text =  "Seller: " + seller
                self.productDetailMaterialLabel.text = "\(materialString[0])\n\(materialString[1])\n\(materialString[2])"
                self.productDetailKeyFeatureLabel.text = keyFeatures
                self.productDetailCareInstructionsLabel.text = "\(careInstructionsString[0])\n\(careInstructionsString[1])\n\(careInstructionsString[2])"
               
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func selectedButtons(isSelectedPath: String) {
        let refDoc: DocumentReference!
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }
        refDoc = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
        refDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let pathToLikedandCart = data![isSelectedPath] as? Dictionary<String, String> {
                    //print(pathToLikedandCart)
                    if pathToLikedandCart.keys.contains("\(self.productDetailId ?? "")") {
                        //print("Contain")
                        if isSelectedPath == "shoppingCart" {
                            self.addToCartButton.isSelected = true
                        }
                        else {
                            self.addToFavouritesButton.isSelected = true
                        }
                    }
                    else {
                        //print("Doesn't contain")
                        if isSelectedPath == "shoppingCart" {
                            self.addToCartButton.isSelected = false
                        }
                        else {
                            self.addToFavouritesButton.isSelected = false
                        }
                    }
                }
                
            } else {
                //print("Document does not exist")
            }
        }
        
    }
    
    
    func checkFields(path: String) {
        let refDoc: DocumentReference!
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }
        refDoc = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
        let pathToSave = "Furniture/\(documentId ?? "")/\(newId ?? "")/\(productDetailId ?? "")"
        
       
        
        refDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if data![path] == nil {
                    // Update one field, creating the document if it does not exist.
                    refDoc.setData([ "\(path)": ["\(self.productDetailId ?? "")": pathToSave] ], merge: true)
                    
                }
                else {
                    if let pathToLikedandCart = data![path] as? Dictionary<String, String> {
                        //print(pathToLikedandCart)
                        if pathToLikedandCart.keys.contains("\(self.productDetailId ?? "")") {
                            print("Contain")
                            if path == "shoppingCart" {
                                self.addToCartButton.isSelected = false
                            }
                            else {
                                self.addToFavouritesButton.isSelected = false
                            }
                            refDoc.updateData([
                                "\(path).\(self.productDetailId ?? "")": FieldValue.delete(),
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully deleted")
                                    }
                            }
                        }
                        else {
                            print("Doesn't contain")
                            if path == "shoppingCart" {
                                self.addToCartButton.isSelected = true
                            }
                            else {
                                self.addToFavouritesButton.isSelected = true
                            }
                            refDoc.updateData([
                                "\(path).\(self.productDetailId ?? "")": pathToSave
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                        }
                    }
                }
                
            } else {
                print("Document does not exist")
            }
        }
        
        
    }
    
    
    @IBAction func addToCartButton(_ sender: Any) {
        let path = "shoppingCart"
        checkFields(path: path)
    }
    
    
    @IBAction func addToFavouriteButton(_ sender: UIButton) {
        let path = "pathToLiked"
        checkFields(path: path)
    }
    
    
    
    
    

}





