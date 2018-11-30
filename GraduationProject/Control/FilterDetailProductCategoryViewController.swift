//
//  FilterDetailProductCategoryViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 30.11.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class FilterDetailProductCategoryViewController: UIViewController {

    var filterType: String?
    
    var colorFilterName = [String]()
    var priceFilterName = [String]()
    var names = [String]()
    //populate from Firestore
    var colorFilter = [String]()
    var priceFilter = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(filterType)
        // Do any additional setup after loading the view.
        getFilterDetail()
    }
    

    func getFilterDetail() {
        
    }
}


extension FilterDetailProductCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterType == "color" {
            return colorFilter.count
        }
        else {
            return priceFilter.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterDetailCell", for: indexPath)
        
        if filterType == "Color" {
            cell.textLabel?.text = colorFilter[indexPath.row]
        }
        if filterType == "Price" {
            cell.textLabel?.text = priceFilter[indexPath.row]
        }
        
        if filterType == "Color" {
            cell.accessoryType = self.colorFilterName.contains("\(colorFilter[indexPath.row])") ? .checkmark : .none
        }
        if filterType == "Price" {
            cell.accessoryType = self.priceFilterName.contains("\(priceFilter[indexPath.row])") ? .checkmark : .none
        }
        
        return cell
        
    }
    
    
    
    
    
}
