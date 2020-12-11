//
//  TempViewController.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 25/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {
    
    var cocktailDetails: (cocktailName: String, image: UIImage?)?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let cocktailDetails = cocktailDetails {
            nameLabel.text = cocktailDetails.cocktailName
            imageView.image = cocktailDetails.image
        }
        
        // Do any additional setup after loading the view.
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
