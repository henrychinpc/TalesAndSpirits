//
//  DiaryViewController.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 24/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class MyDiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let diaryModelView = MyDiaryViewModel()

    @IBOutlet weak var myDiaryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDiaryTableView.dataSource = self
        myDiaryTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryModelView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CKCell", for: indexPath)
        
        let imageView = cell.viewWithTag(1000) as? UIImageView
        
        let cocktailNameLabel = cell.viewWithTag(1001) as? UILabel
        
        if let imageView = imageView, let cocktailNameLabel = cocktailNameLabel {
            
            //imageView.image = UIImage(named: "liit")
            //cocktailNameLabel.text = "Long Island Ice Tea"
            let currentCocktail: (cocktailName: String, image: UIImage?) = diaryModelView.getCocktail(byIndex: indexPath.row)
            
            imageView.image = currentCocktail.image
            cocktailNameLabel.text = currentCocktail.cocktailName
            
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedRow = myDiaryTableView.indexPathForSelectedRow
            else {return}
        
        let destination = segue.destination as? TempViewController
        
        if let destination = destination {
            destination.cocktailDetails = diaryModelView.getCocktail(byIndex: selectedRow.row)
        }
        
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
