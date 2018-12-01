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
    
    var colorFilterName = [String]()
    var priceFilterName = [String]()
    var names = [String]()
    //populate from Firestore
    var colorFilter = [String]()
    var priceFilter = [String]()
    
    var filterDetailArr = [String]()
    
    @IBOutlet weak var filterDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(filterType)
        // Do any additional setup after loading the view.
        colorFilterName = (defaults.array(forKey: "colorFilterName") as? [String] ?? [])
        priceFilterName = (defaults.array(forKey: "priceFilterName") as? [String] ?? [])
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
        
        if filterType == "color" {
            cell.accessoryType = self.colorFilterName.contains("\(filterDetailArr[indexPath.row])") ? .checkmark : .none
        }
        if filterType == "price" {
            cell.accessoryType = self.priceFilterName.contains("\(filterDetailArr[indexPath.row])") ? .checkmark : .none
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if filterType == "color" {
            if self.colorFilterName.contains("\(filterDetailArr[indexPath.row])") {
                self.colorFilterName.removeAll { $0 == "\(filterDetailArr[indexPath.row])" }
            }
            else {
                if colorFilterName.contains("color"){
                    colorFilterName.append(filterDetailArr[indexPath.row])
                }
                else {
                    colorFilterName.insert("color", at: 0)
                    colorFilterName.append(filterDetailArr[indexPath.row])
                }
            }
        }
        if filterType == "price" {
            if self.priceFilterName.contains("\(filterDetailArr[indexPath.row])") {
                self.priceFilterName.removeAll { $0 == "\(filterDetailArr[indexPath.row])" }
            }
            else {
                if priceFilterName.contains("price"){
                    priceFilterName.append(filterDetailArr[indexPath.row])
                }
                else {
                    priceFilterName.insert("price", at: 0)
                    priceFilterName.append(filterDetailArr[indexPath.row])
                }
            }
        }
        
        
        defaults.set(priceFilterName, forKey: "priceFilterName")
        defaults.set(colorFilterName, forKey: "colorFilterName")
        
        DispatchQueue.main.async {
            self.filterDetailTableView.reloadData()
        }
    }
    
    
}
