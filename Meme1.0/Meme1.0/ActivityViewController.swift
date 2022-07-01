//
//  ActivityViewController.swift
//  Meme1.0
//
//  Created by minhdat on 30/06/2022.
//

import Foundation
import UIKit
class ActivityViewController  : UIViewController {
    
    @IBOutlet weak var memedImage: UIImageView!
    
    var receivedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memedImage.image = receivedImage
        
    }
    
    
    
    
    
    
}
