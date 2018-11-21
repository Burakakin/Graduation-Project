//
//  SignUpPageViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 4.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpPageViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
     var ref: CollectionReference? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePictureImageView.isUserInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func alert(with title: String,for message: String ){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
   
   
    @IBAction func SignUpButton(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        
        ref = Firestore.firestore().collection("User")
        let storageRef = Storage.storage().reference().child("UserProfileImg//\(email)")
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code){
                    switch errCode {
                    case .emailAlreadyInUse:
                        print("In use")
                    case .weakPassword:
                        print("Password weak")
                    default:
                        print("Hello")
                    }
                }
            }
            else {
                guard let user = authResult?.user else { return }
                let userId = user.uid
                //print("User was created")
                self.alert(with: "Info", for: "User was created")
                
                
                let uploadMetadata = StorageMetadata()
                uploadMetadata.contentType = "image/jpeg"
                let uploadImage = self.profilePictureImageView.image?.jpegData(compressionQuality: 0.8)
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
                        
                        let userData: [String: Any] = ["userId": userId,"nameSurname": username, "email": email, "password": password, "profileImageUrl": urlString]
                        self.signUpUserIntoDatabse(dataToSaveDatabase: userData)
                        
                    }
                }
                
                user.sendEmailVerification(completion: { (err) in
                    if err != nil {
                        print("Error in email verification")
                    }
                    else{
                       // print("Email was send")
                        self.alert(with: "Info", for: "Email was send")
                    }
                })
                
            }
            
            
            
        }
    }
    
    func signUpUserIntoDatabse(dataToSaveDatabase: [String: Any]){
        self.ref?.addDocument(data: dataToSaveDatabase) { err in
            if let err = err {
                print("Error adding document: \(err.localizedDescription)")
            } else {
                //print("Document added")
                self.alert(with: "Info", for: "User's info saved to db")
            }
        }
    }

}


extension SignUpPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let profileImg = UIImagePickerController()
        profileImg.delegate = self
        profileImg.allowsEditing = false
        profileImg.sourceType = .photoLibrary
        profileImg.allowsEditing = false
        present(profileImg, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedProfileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePictureImageView.contentMode = .scaleAspectFit
            profilePictureImageView.image = pickedProfileImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}


