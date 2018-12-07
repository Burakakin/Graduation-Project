//
//  FavouritesViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 7.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FavouritesViewController: UIViewController {

     var favouritesDictionary = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Favourites"
        // Do any additional setup after loading the view.
       
    }
    
    @IBOutlet weak var favouriteTableView: UITableView!
    
    @IBAction func leftSideButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favouritesDictionary.removeAll()
        getFavourites()
    }
    
    func getFavourites() {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }
        var ref: DocumentReference!
        var refItem: DocumentReference!
        ref = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                if let favourites = data["pathToLiked"] as? Dictionary<String, String> {
                    for item in favourites {
                        refItem = Firestore.firestore().document("\(item.value)")
                        refItem.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let dataFavourite = document.data()!
                                let key = item.key
                                let imageUrl = dataFavourite["imageUrl"] as! String
                                let category = dataFavourite["category"] as! String
                                let name = dataFavourite["name"] as! String
                                let description = dataFavourite["description"] as! String
                                let price = dataFavourite["price"] as! String
                                let dimension = dataFavourite["dimension"] as! String
                                
                                let dataDic = ["name": name,"imageUrl": imageUrl, "description": description, "price": price, "dimension": dimension,"documentDetailId": key, "category": category ]
                                DispatchQueue.main.async {
                                    self.favouritesDictionary.append(dataDic)
                                    self.favouriteTableView.reloadData()
                                }
                            } else {
                                print("Document does not exist")
                            }
                        }
                    }
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouritesTableViewCell
        
        let index = favouritesDictionary[indexPath.row]
        
        cell.favouritesProductNameLabel.text = index["name"]
        cell.favouritesProductDescriptionLabel.text = index["description"]
        cell.favouritesProductDimensionLabel.text = index["dimension"]
        cell.favouritesProductPriceLabel.text = index["price"]! + "TL"
        imageDownload.getImage(withUrl: index["imageUrl"]!) { (image) in
            cell.favouritesProductImageView.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "favouriteDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let rowSelected = (sender as! IndexPath).row
        if segue.identifier == "favouriteDetail" {
            if let productDetailVC =  segue.destination as? ProductDetailViewController {
                productDetailVC.documentId = (favouritesDictionary[rowSelected]["category"])
                productDetailVC.productDetailId = (favouritesDictionary[rowSelected]["documentDetailId"])
            }
        }
    }
    
    
}
