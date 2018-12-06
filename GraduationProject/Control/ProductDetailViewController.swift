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
        setUpLastViewed()
    }
    
    @objc func abc() {
        print("buttonTapped")
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
        let defaults = UserDefaults.standard
        
        let pathToSave = "Furniture/\(documentId ?? "")/\(newId ?? "")/\(productDetailId ?? "")"
        var lastViewed = [String]()
        lastViewed = (defaults.array(forKey: "lastViewed") as? [String] ?? [])
        lastViewed.append(pathToSave)
        defaults.set(lastViewed, forKey: "lastViewed")
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            
            
            refDoc = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
            
            refDoc!.updateData([
                "lastViewed": lastViewed
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
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
    
    
    @IBAction func addToFavouriteButton(_ sender: UIButton) {
        let refDoc: DocumentReference!
        let defaults = UserDefaults.standard
        var myFavorite = [String]()
        myFavorite = (defaults.array(forKey: "fav") as? [String] ?? [])
        
        let pathToSave = "Furniture/\(documentId ?? "")/\(newId ?? "")/\(productDetailId ?? "")"
        if myFavorite.contains(pathToSave) {
            let indexOfSavedPath = myFavorite.firstIndex(of: pathToSave)
            myFavorite.remove(at: indexOfSavedPath!)
            defaults.set(myFavorite, forKey: "fav")
        }
        else {
            myFavorite.append(pathToSave)
            defaults.set(myFavorite, forKey: "fav")
        }

        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid


            refDoc = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
            refDoc!.updateData([
                "pathToLiked": myFavorite
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        
        
        
    }
    
    
    @IBAction func shoppingCardTapped(_ sender: Any) {
        print("Shopping Card Tapped")
    }
    
    
    
    

}





