//
//  UploadNewProductViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 3.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class UploadNewProductViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Products"
        // Do any additional setup after loading the view.
    }
    

    @IBAction func leftSideButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    

}


extension UploadNewProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uploadProductCell", for: indexPath)
        
        
        
        return cell
    }
    
    
    
    
    
}
