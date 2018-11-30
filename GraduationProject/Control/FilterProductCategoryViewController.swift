//
//  FilterProductCategoryViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 26.11.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class FilterProductCategoryViewController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    let defaults = UserDefaults.standard
    
   
    var filterTypeArr = [String]()
    
    
    
    
    var colorFilterName = [String]()
    var priceFilterName = [String]()
    
    var documentId: String?
    var newId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getFilterType()
    }
    
   
    func getFilterType() {
        var ref: DocumentReference!
        ref = Firestore.firestore().collection("Furniture").document("\(documentId ?? "")")
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                if let filterType = data["filter"] as? Dictionary<String, Any> {
                    for i in filterType.keys {
                        self.filterTypeArr.append(i)
                        DispatchQueue.main.async {
                            self.filterTableView.reloadData()
                        }
                    }
                    
                }
            } else {
                print("Document does not exist")
            }
        }

    }
    
    @IBAction func unWindToFilterProductCategory(_ unwindSegue: UIStoryboardSegue){
        print("Welcome to Filter Product Category Page")
        print("Welcome to Product Category Page")
        colorFilterName = (defaults.array(forKey: "colorFilterName") as? [String] ?? [])
        priceFilterName = (defaults.array(forKey: "priceFilterName") as? [String] ?? [])
        
        
        print(colorFilterName)
        print(priceFilterName)
    }
    
}


extension FilterProductCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterTypeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
        cell.textLabel?.text = filterTypeArr[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailFilter", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailFilter" {
            let rowSelected = (sender as! IndexPath).row
            if let filterDetailVC =  segue.destination as? FilterDetailProductCategoryViewController {
                filterDetailVC.filterType = filterTypeArr[rowSelected]
                filterDetailVC.documentId = documentId
            }
        }
    }
    
}
