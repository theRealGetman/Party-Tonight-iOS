//
//  PageItemController.swift
//  Paging_Swift
//
//  Created by olxios on 26/10/14.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
    
    // MARK: - Variables
    var itemIndex: Int = 0
//    var imageName: String = "" {
//        
//        didSet {
//            
//            if let imageView = contentImageView {
//                imageView.image = UIImage(named: imageName)
//                
//            }
//            
//        }
//    }
    
    var imageUrl: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                if let url = URL(string: imageUrl){
                    imageView.sd_setImage(with: url)
                }
                
            }
            
        }
    }
    
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: imageUrl){
            contentImageView!.sd_setImage(with: url)
        }
        
        //contentImageView!.image = UIImage(named: imageName)
    }
}
