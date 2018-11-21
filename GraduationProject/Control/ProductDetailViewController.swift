//
//  ProductDetailViewController.swift
//  GraduationProject
//
//  Created by Burak Akin on 19.11.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProductDetailViewController: UIViewController {

    var documentId: String?
    var newId: String?
    var productDetailId: String?
    
    @IBOutlet weak var imageSlider: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.view.backgroundColor = .clear
        
        setupImageSlider()
    }
    


    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    
    func setupImageSlider() {
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        imageSlider.pageIndicator = pageIndicator
        
        imageSlider.pageIndicatorPosition = PageIndicatorPosition(horizontal: .left(padding: 20), vertical: .bottom)
        
        imageSlider.setImageInputs([ImageSource(image: UIImage(named: "sofa.jpg")!),ImageSource(image: UIImage(named: "sofa1.jpg")!),ImageSource(image: UIImage(named: "sofa2.jpg")!)])
    }

}
