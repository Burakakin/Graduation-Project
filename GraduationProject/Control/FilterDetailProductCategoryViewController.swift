//
//  FilterDetailProductCategoryViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 30.11.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FilterDetailProductCategoryViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    var filterType: String?
    var documentId: String?
    var selectedColor: String?
    var filterDetailArr = [String]()
    
    @IBOutlet weak var filterDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFilterDetail()
    }
    

    func getFilterDetail() {
        
        var ref: DocumentReference!
        ref = Firestore.firestore().document("Furniture/\(documentId ?? "")")
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                if let filterTypeData = data["filter"] as? Dictionary<String, Any> {
                    //print(filterTypeData.keys)
                    for key in filterTypeData.keys {
                        if self.filterType == key {
                            if let filterDetail = filterTypeData["\(key)"] as? [String] {
                                self.filterDetailArr = filterDetail
                                DispatchQueue.main.async {
                                    self.filterDetailTableView.reloadData()
                                }
                            }
                        }
//                        else {
//                            print("There is no match")
//                        }
                    }
                    
                }
            } else {
                print("Document does not exist")
            }
        }
        
        
    }
}


extension FilterDetailProductCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDetailArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterDetailCell", for: indexPath)
        cell.textLabel?.text = filterDetailArr[indexPath.row]
        cell.textLabel!.font = UIFont(name:"Futura-Medium", size:22)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedColor = filterDetailArr[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .none
        }
    }
    
}
