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
import FirebaseStorage

class AddProductViewController: UIViewController, UITextFieldDelegate {

    var ref: CollectionReference!
    var refDoc: DocumentReference!
    var refDb: CollectionReference!
    
    var category = [String]()
    var subCategory = [String]()
 
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var subCategoryTextField: UITextField!
    @IBOutlet weak var sellerName: UITextField!
    @IBOutlet weak var sellerEmail: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextField: UITextField!
    @IBOutlet weak var productDimensionTextField: UITextField!
    @IBOutlet weak var productColorTextField: UITextField!
    @IBOutlet weak var productLongDescriptionTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    
    var selectedCategory: String?
     var selectedSubCategory: String?
    var newId: String?
    
    let categoryPicker = UIPickerView()
    let subcategoryPicker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.delegate = self
        subCategoryTextField.delegate = self
        sellerName.delegate = self
        sellerEmail.delegate = self
        productNameTextField.delegate = self
        productDescriptionTextField.delegate = self
        productDimensionTextField.delegate = self
        productColorTextField.delegate = self
        productLongDescriptionTextField.delegate = self
        productPriceTextField.delegate = self
        
        
        
        productImageView.layer.cornerRadius = productImageView.frame.height / 2
        productImageView.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addProductImageTapped(tapGestureRecognizer:)))
        productImageView.isUserInteractionEnabled = true
        productImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        categoryPicker.delegate = self
        categoryTextField.inputView = categoryPicker
        
        subcategoryPicker.delegate = self
        subCategoryTextField.inputView = subcategoryPicker
        createToolbar()
        getCategories()
        getUserInfo()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
    
    func saveToDatabase() {
        
        
        print("Furniture/\(selectedCategory ?? "")/\(newId ?? "")")
        
        guard let productName = productNameTextField.text, !productName.isEmpty else { return }
        guard let productDescription = productDescriptionTextField.text, !productDescription.isEmpty else { return }
        guard let productDimension = productDimensionTextField.text, !productDimension.isEmpty else { return }
        guard let productColor = productColorTextField.text, !productColor.isEmpty else { return }
        guard let productLongDescription = productLongDescriptionTextField.text, !productLongDescription.isEmpty else { return }
        guard let productPrice = productPriceTextField.text, !productPrice.isEmpty else { return }
        
       
        let storageRef = Storage.storage().reference().child("AllCategories/\(selectedCategory ?? "")/\(selectedSubCategory ?? "")/")
        
        
        
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        let uploadImage = self.productImageView.image?.jpegData(compressionQuality: 0.8)
        // Upload the file to the path "images/rivers.jpg"
        storageRef.putData(uploadImage!, metadata: uploadMetadata) { (metadata, error) in
            guard let metadata = metadata else { return }
            // Metadata contains file metadata such as size, content-type.
            if error != nil {
                print("Error! \(String(describing: error?.localizedDescription))")
            }
            else{
                print("Upload Complete! \(String(describing: metadata))")
            }
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                let urlString = downloadURL.absoluteString
                print("image url: \(urlString)")
                
//                let userData: [String: Any] = ["userId": userId,"nameSurname": username, "email": email, "password": password, "profileImageUrl": urlString]
                let productData: [String: Any] = ["name": productName, "description": productDescription, "dimension": productDimension, "longDescription": productLongDescription, "seller": self.sellerName.text!, "subCategory": self.selectedSubCategory!, "color": productColor, "price": productPrice, "imageUrl": urlString, "priceInt": Int(productPrice)!]
                self.passDataToDatabase(productInfo: productData)
                
            }
        }
        
        
        
        
        
    }
    
    
    func passDataToDatabase(productInfo: [String: Any]){
        
         refDb = Firestore.firestore().collection("Furniture/\(selectedCategory ?? "")/\(newId ?? "")")
        refDb.addDocument(data: productInfo) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    @IBAction func saveToDatabase(_ sender: Any) {
        saveToDatabase()
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

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func addProductImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let profileImg = UIImagePickerController()
        profileImg.delegate = self
        profileImg.allowsEditing = false
        profileImg.sourceType = .photoLibrary
        profileImg.allowsEditing = false
        present(profileImg, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedProfileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            productImageView.contentMode = .scaleAspectFit
            productImageView.image = pickedProfileImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
