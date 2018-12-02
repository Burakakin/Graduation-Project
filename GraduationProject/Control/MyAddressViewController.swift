//
//  MyAddressViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 2.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class MyAddressViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddress))
    }
    

    @objc func addAddress() {
        performSegue(withIdentifier: "addAddress", sender: self)
    }

}
