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
    var imageUrl = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = (view.frame.size.width) / 2
         let height = (view.frame.size.height) / 3
        let layout = mainPageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.orange
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
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
                    DispatchQueue.main.async {
                        self.imageUrl.append(imageUrlString)
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
        cell.mainPageImageView.download(url: imageUrl[indexPath.row])
        return cell
    }
    
    
    
    
}


