//
//  MainPageViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 3.10.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet weak var mainPageCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = (view.frame.size.width) / 2
         let height = (view.frame.size.height) / 3
        let layout = mainPageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        // Do any additional setup after loading the view.
    }
    
    var imageArray: [UIImage] = [UIImage(named: "Desk")!,UIImage(named: "Desk")!,UIImage(named: "Desk")!]

    @IBAction func leftSideButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainPageCollectionView.dequeueReusableCell(withReuseIdentifier: "mainPageCollection", for: indexPath) as! MainPageCollectionViewCell
        cell.mainPageImageView.image = imageArray[indexPath.row]
        return cell
    }
    
    
    
    
}
