//
//  CocktailsViewController.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 23/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class CocktailsViewController: UITableViewController, RefreshData, UISplitViewControllerDelegate {
    
    var cocktailViewModel: CocktailViewModel = CocktailViewModel()
    
    
    @IBOutlet var cocktailsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cocktailViewModel.delegate = self
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible

    }
    
    func updateUIWithRestData() {
        self.tableView.reloadData()
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cocktailViewModel.count+1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        //Row 0 contains the cocktail label
        //For all rows != 0, populate cell with cocktailName and image
        if indexPath.row != 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell", for: indexPath)
            
            let imageView = cell.viewWithTag(1000) as? UIImageView
            
            let cocktailNameLabel = cell.viewWithTag(1001) as? UILabel
            
            if let imageView = imageView, let cocktailNameLabel = cocktailNameLabel{
                imageView.image = cocktailViewModel.getCocktailImage(byIndex: indexPath.row - 1)
                cocktailNameLabel.text = cocktailViewModel.getCocktailName(byIndex: indexPath.row - 1)
                
            }
        }
        else{
        cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Row 0 contains the cocktail label
        //For all rows != 0, 
        if indexPath.row != 0{
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeSceneViewController") as! RecipeSceneViewController
        cocktailViewModel.fetchCocktailById(index: indexPath.row - 1)
        detailViewController.viewModel = RecipeSceneViewModel(cocktail: cocktailViewModel.getCocktail(byIndex: indexPath.row - 1))
        detailViewController.delegate = self

        splitViewController?.showDetailViewController(detailViewController, sender: self)
        }
    }
    
}

extension CocktailsViewController: FavouriteCocktailDelegate{
    func addCocktailAsFavorite(_ drinkId: String) {
        cocktailViewModel.setCocktailAsFavorite(drinkId: drinkId)
    }
    
    func removeCocktailAsFavorite(_ drinkId: String) {
        cocktailViewModel.removeCocktailFromFavorite(drinkId: drinkId)
    }
    
    func updatePersonalNote(_ drinkId: String, _ note: String) {
        cocktailViewModel.updatePersonalNote(drinkId: drinkId, note: note)
    }
    
}

