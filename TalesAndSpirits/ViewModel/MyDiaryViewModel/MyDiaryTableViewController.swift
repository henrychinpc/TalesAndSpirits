//
//  MyDiaryTableViewController.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 24/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class MyDiaryTableViewController: UITableViewController {
    
    var viewModel: MyDiaryViewModel = MyDiaryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.count + 2)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            let myDiaryLabel = cell.viewWithTag(1000) as? UILabel
            
            if let myDiaryLabel = myDiaryLabel {
                myDiaryLabel.text = "My Diary"
            }
            
        }else if indexPath.row == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "AddButtonCell", for: indexPath)
    
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell", for: indexPath)
            
            let imageView = cell.viewWithTag(1003) as? UIImageView
            
            let cocktailNameLabel = cell.viewWithTag(1004) as? UILabel
            
            if let imageView = imageView, let cocktailNameLabel = cocktailNameLabel{
                cocktailNameLabel.text = viewModel.getCocktailName(byIndex: indexPath.row - 2)
                imageView.image = viewModel.getCocktailImage(byIndex: indexPath.row - 2)
                
                
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return 200
        }else{
            return UITableViewAutomaticDimension
        }
        
    }

    @IBAction func addCocktailButtonPressed(_ sender: Any) {
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let newDestination = segue.destination as? AddNewCocktailController{
            newDestination.delegate = self
        }
        
        guard let selectedRow = self.tableView.indexPathForSelectedRow
            else {return}

        if let newDestination = segue.destination as? RecipeSceneViewController{
            newDestination.delegate = self
            newDestination.viewModel = RecipeSceneViewModel(cocktail: viewModel.getCocktail(byIndex: (selectedRow.row - 2)))
        }
        
        
    }
}

extension MyDiaryTableViewController: FavouriteCocktailDelegate{
    func addCocktailAsFavorite(_ drinkId: String) {
        viewModel.setCocktailAsFavorite(drinkId: drinkId)
    }
    
    func removeCocktailAsFavorite(_ drinkId: String) {
        viewModel.removeCocktailFromFavorite(drinkId: drinkId)
    }
    
    func updatePersonalNote(_ drinkId: String, _ note: String) {
        viewModel.updatePersonalNote(drinkId: drinkId, note: note)
    }
        
}

extension MyDiaryTableViewController: UserDefinedCocktail{
    func addCocktail(_ cocktailDetails: [String : String], image: UIImage?) {
        viewModel.addUserDefinedCocktail(cocktailDetails, image: image)
    }
    
    
}

