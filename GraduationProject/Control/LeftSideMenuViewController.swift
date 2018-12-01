//
//  LeftSideMenuViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 3.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController {

    
    @IBOutlet weak var myAccountButton: UIButton!
    
    var menuItem = ["All Products","Last Viewed","My Favourite","My Products","My Card"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myAccountButton.layer.cornerRadius = 4
        myAccountButton.layer.borderWidth = 1
        myAccountButton.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.view.layoutSubviews()
    }
    
    @IBAction func myAccountPage(_ sender: Any) {
        let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @IBAction func socialMedia(_ sender: Any) {
        let fbUrlWeb = URL(string: "https://www.facebook.com/birduramamahali")
        let fbUrlId = URL(string: "fb://profile/195680347140498")
        
        if (UIApplication.shared.canOpenURL(fbUrlId!)) {
            //FB installed
            UIApplication.shared.open(fbUrlId!)
        }
        else{
            UIApplication.shared.open(fbUrlWeb!)
        }
    }
    
    
    


}



extension LeftSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! LeftSideCustomMenuTableViewCell
        cell.menuItemLabel.text = menuItem[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(indexPath.row)
        
        
        switch indexPath.row {
        case 0:
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        case 4:
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingCardViewController") as! ShoppingCardViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
       
        default:
            print("Hello")
        }
    }
    
}
