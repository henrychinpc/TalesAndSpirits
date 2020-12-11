//
//  HomeViewController.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 23/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RefreshData{
    
    var viewModel: HomeViewModel = HomeViewModel()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var dataCollectionCell: DataCollectionView!
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    func updateUIWithRestData() {
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCollectionView", for: indexPath)as? DataCollectionView
            cell?.titleText.isUserInteractionEnabled = false
            return cell!
            
        }else if indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath) as? DataCollectionView
            
            if let cell = cell{
                cell.imageView.image = viewModel.getRandomizeImage()
                cell.nameLabel.text = viewModel.getRandomizeText()
            }
            return cell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath)as? DataCollectionView
            
            if let cell = cell{
                cell.imageView.image = viewModel.getCocktailImage(byIndex: (indexPath.item - 2))
                cell.nameLabel.text = viewModel.getCocktailName(byIndex: (indexPath.item - 2))
            }
            
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let position = indexPath.row
        if(position == 0){return CGSize(width: bounds.width, height: 50)}
        else{
            return CGSize(width: 201, height: 230)}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedItem = self.collectionView.indexPathsForSelectedItems?.first else {return}
        
        
        let newDestination = segue.destination as? RecipeSceneViewController
        
        if let newDestination = newDestination{
            newDestination.delegate = self
            if selectedItem.row == 1{
                viewModel.fetchRandomCocktail()
                newDestination.viewModel = RecipeSceneViewModel(cocktail: nil)
                
            }else{
                viewModel.fetchCocktailById(index: selectedItem.item - 2)
                newDestination.viewModel = RecipeSceneViewModel(cocktail: viewModel.getCocktail(byIndex: selectedItem.item - 2))
            }
        }
        
    }
}

extension HomeViewController: FavouriteCocktailDelegate{
    
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
