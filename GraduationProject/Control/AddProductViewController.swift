//
//  AddProductViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 3.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddProductViewController: UIViewController {

    var ref: CollectionReference!
    var refDoc: DocumentReference!
    
    var category = [String]()
    var subCategory = [String]()
 
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var subCategoryTextField: UITextField!
    @IBOutlet weak var sellerName: UITextField!
    @IBOutlet weak var sellerEmail: UITextField!
    
    
    var selectedCategory: String?
     var selectedSubCategory: String?
    var newId: String?
    
    let categoryPicker = UIPickerView()
    let subcategoryPicker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.delegate = self
        categoryTextField.inputView = categoryPicker
        
        subcategoryPicker.delegate = self
        subCategoryTextField.inputView = subcategoryPicker
        createToolbar()
        getCategories()
        getUserInfo()
        
        // Do any additional setup after loading the view.
    }
    
    func getUserInfo()  {
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else { return }
        let userId = user.uid
        refDoc = Firestore.firestore().document("User/\(userId)")
        refDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let name = data!["nameSurname"] as! String
                let email = data!["email"] as! String
                
                self.sellerName.text = name
                self.sellerEmail.text = email
                
            } else {
                print("Document does not exist")
            }
        }
       
        
        
    }
  
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolbar
        subCategoryTextField.inputAccessoryView = toolbar
        
    }
    
    func getCategories() {
        ref = Firestore.firestore().collection("Furniture")
    
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID)")
                    DispatchQueue.main.async {
                       self.category.append("\(document.documentID)")
                    }
                    
                }
            }
        }
    }
    
    func getSubCategories() {
        refDoc = Firestore.firestore().document("Furniture/\(selectedCategory ?? "")")
        refDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                if let subCategory = document.data()!["subCategory"] as? Dictionary<String,String> {
                    print(subCategory.keys)
                    for key in subCategory.keys {
                        self.subCategory.append(key)
                    }
                    
                }
               
            } else {
                print("Document does not exist")
            }
        }
        
        
        
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


extension AddProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return category.count
        }
        if pickerView == subcategoryPicker {
            return subCategory.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == categoryPicker {
            return category[row]
        }
        if pickerView == subcategoryPicker {
            return subCategory[row]
        }
        else{
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == categoryPicker {
            selectedCategory = category[row]
            categoryTextField.text = selectedCategory
            newId = "all" + selectedCategory!
            getSubCategories()
            
        }
        else if pickerView == subcategoryPicker {
            selectedSubCategory = subCategory[row]
            subCategoryTextField.text = selectedSubCategory
            
        }
        
       
    }
    
    
    
}
