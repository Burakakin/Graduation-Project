//
//  LastViewedViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 7.12.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class LastViewedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Last Viewed"
        // Do any additional setup after loading the view.
        getLastViewed()
    }
    

    @IBAction func leftSideButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    func getLastViewed() {
        let user = Auth.auth().currentUser
        guard let uid = user?.uid else { return }
        var ref: DocumentReference!
        ref = Firestore.firestore().document("User/\(uid)/userDetail/userDetailDocument")
    }
    

}


extension LastViewedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lastViewedCell", for: indexPath) as! LastViewedTableViewCell
        return cell
    }
    
    
    
    
    
    
}
