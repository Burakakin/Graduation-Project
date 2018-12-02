//
//  PersonalInfoViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 22.11.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PersonalInfoViewController: UIViewController {

    var ref: DocumentReference!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        // Do any additional setup after loading the view.
        getUserInfo()
    }
    

    func getUserInfo() {
        
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else { return }
        let userId = user.uid
        
        ref = Firestore.firestore().document("User/\(userId)")
        ref.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                //print("Document data: \(String(describing: dataDescription))")
                self.nameSurnameLabel.text = (dataDescription?["nameSurname"] as! String)
                self.emailLabel.text = (dataDescription?["email"] as! String)
                let imageUrl = (dataDescription?["profileImageUrl"] as! String)
                if let homeAddress = dataDescription!["address"] as? Dictionary<String, String> {
                    let home = (homeAddress["addressHome"] as! String)
                    self.addressLabel.text = home
                }
                
                imageDownload.getImage(withUrl: imageUrl, completion: { (image) in
                    self.profileImageView.image = image
                })
                
            } else {
                print("document doesn't exit")
            }
        }
        
    }
   

}
