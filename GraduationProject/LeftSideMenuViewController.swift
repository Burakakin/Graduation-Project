//
//  LeftSideMenuViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 3.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController {

    
    @IBOutlet weak var myAccountButton: UIButton!
    
    var menuItem = ["Main Page","About"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myAccountButton.layer.cornerRadius = 4
        myAccountButton.layer.borderWidth = 1
        myAccountButton.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    


}



extension LeftSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! LeftSideCustomMenuTableViewCell
        cell.menuItemLabel.text = menuItem[indexPath.row]
        
        return cell
    }
    
    
}
