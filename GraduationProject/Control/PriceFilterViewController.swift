//
//  PriceFilterViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 16.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class PriceFilterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var minValueTextField: UITextField!
    @IBOutlet weak var maxValueTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        minValueTextField.delegate = self
        maxValueTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

}
