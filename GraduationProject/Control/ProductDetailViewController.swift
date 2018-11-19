//
//  ProductDetailViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 19.11.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var documentId: String?
    var newId: String?
    var productDetailId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.view.backgroundColor = .black
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    

}
