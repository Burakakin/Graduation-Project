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

        // Do any additional setup after loading the view.
        getUserInfo()
    }
    

    func getUserInfo() {
        
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else { return }
        //let email = user.email
        let userId = user.uid
        
        ref = Firestore.firestore().document("User/\(userId)")
       
        
        ref.getDocument{ (document, error) in
            if let document = document, document.exists {
                print(document.documentID)
                //print("Document data: \(dataDescription)")
            } else {
                print("document doesn't exit")
            }
        }
        
    }
   

}
