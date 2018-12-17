//
//  SortFilterViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 17.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase

class SortFilterViewController: UIViewController {

    var sortArray = ["Lowest to Highest", "Highest to Lowest", "From A to Z", "From Z to A"]
    var ref: CollectionReference!
    var sortQuery: Query?
    var documentId: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}

extension SortFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath)
        cell.textLabel?.text = sortArray[indexPath.row]
        cell.textLabel!.font = UIFont(name:"Futura-Medium", size:22)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        let newId = "all" + (documentId ?? "")
        ref = Firestore.firestore().collection("Furniture/\(documentId ?? "")/\(newId)")
        
        if indexPath.row == 0 {
            sortQuery = ref.order(by: "priceInt", descending: false)
        }
        else if indexPath.row == 1 {
            sortQuery = ref.order(by: "priceInt", descending: true)
        }
        else if indexPath.row == 2 {
            sortQuery = ref.order(by: "name", descending: false)
        }
        else if indexPath.row == 3 {
            sortQuery = ref.order(by: "name", descending: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .none
        }
    }
    
    
    
    
}
