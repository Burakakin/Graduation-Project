//
//  MainPageViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 3.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class MainPageViewController: UIViewController {

    @IBOutlet weak var mainPageCollectionView: UICollectionView!
    
    var ref: CollectionReference!
    var imageUrl = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = (view.frame.size.width) / 2
         let height = (view.frame.size.height) / 3
        let layout = mainPageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        // Do any additional setup after loading the view.
        
//        navigationController?.navigationBar.barTintColor = UIColor.black
//        navigationController?.navigationBar.tintColor = UIColor.orange
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
      
        getAllFurniture()
        
    }
    
   

    @IBAction func leftSideButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    
    func getAllFurniture() {
        
        ref = Firestore.firestore().collection("Furniture")
        
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let imageUrlString = document.data()["imageUrl"] as! String
                    let categoryId = document.data()["id"] as! String
                
                    let data: [String: String] = ["id": categoryId, "imageUrl": imageUrlString]
                    DispatchQueue.main.async {
                        self.imageUrl.append(data)
                        self.mainPageCollectionView.reloadData()
                    }
                    
                }
            }
        }
        
        
    }
    
    
    

}



extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainPageCollectionView.dequeueReusableCell(withReuseIdentifier: "mainPageCollection", for: indexPath) as! MainPageCollectionViewCell
        //cell.mainPageImageView.download(url: imageUrl[indexPath.row]["imageUrl"]!)
        imageDownload.getImage(withUrl: imageUrl[indexPath.row]["imageUrl"]!) { (image) in
            cell.mainPageImageView.image = image
        }
        //print(indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mainPage", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rowSelected = (sender as! IndexPath).row
        if segue.identifier == "mainPage" {
            if let allProductsVC =  segue.destination as? ProductsViewController {
                allProductsVC.documentId = imageUrl[rowSelected]["id"]
            }
        }
    }
    
}


