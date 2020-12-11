//
//  MyDiaryViewModel.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 24/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import UIKit

class CocktailViewModel {
    
    //Reference to model
    private var _model = REST_Request.shared
    //Reference to core data model
    private var _favoriteCocktailModel = CocktailDBManager.shared
    
    var delegate: RefreshData?{
        get{ return _model.delegate}
        set(value){
            _model.delegate = value
        }
    }
    
    var count: Int{
        return _model.cocktails.count
    }
    
    //variables used by child classes to access model
    var model: REST_Request{
        return _model
    }
    
    //variables used by child classes to access model
    var favoriteCocktailModel: CocktailDBManager{
        return _favoriteCocktailModel
    }
    
    //Check if Cocktail details are already fetched
    //If No, fetch details from API
    func fetchCocktailById(index: Int){
        if(_model.cocktails[index].category.isEmpty){
            _model.fetchCocktailById(index: index)
        }
    }
    
    func getCocktailName(byIndex index: Int) -> String{
        return _model.cocktails[index].cocktailName
    }
    
    func getCocktailImage(byIndex index: Int) -> UIImage?{
        //Check if model contains image, else fetch image from network
        guard let image = _model.cocktails[index].image else {
            let url = _model.cocktails[index].imageName
            guard let imageURL = URL(string: url) else{ return nil}
            let data = try? Data(contentsOf: imageURL)
            var image: UIImage? = nil
            if let imageData = data{
                image = UIImage(data: imageData)
            }
            _model.cocktails[index].image = image
            return image
        }
        return image
    }
    
    //Add cocktail to database
    func setCocktailAsFavorite(drinkId: String){
        let index = fetchIndexByDrinkId(drinkId)
        if index != -1{
            _model.cocktails[index].isFavorite = true
            favoriteCocktailModel.addCocktail(model.cocktails[index])
        }
    }
    
    //Delete cocktail from database
    func removeCocktailFromFavorite(drinkId: String){
        let index = fetchIndexByDrinkId(drinkId)
        if index != -1{
            _model.cocktails[index].isFavorite = false
            _model.cocktails[index].personalizedNote = ""
        }
        favoriteCocktailModel.deleteCocktail(drinkId)
    }
    
    //Update Personal Note into database
    func updatePersonalNote(drinkId: String, note: String){
        let index = fetchIndexByDrinkId(drinkId)
        if index != -1{
            _model.cocktails[index].personalizedNote = note
        }
        favoriteCocktailModel.updateCocktailWithNote(drinkId, note)
    }
    
    func getCocktail(byIndex index: Int) -> Cocktail{
        return _model.cocktails[index]
    }
    
    
    func fetchIndexByDrinkId(_ drinkId: String) -> Int{
        return _model.checkIfCocktailExists(drinkId: drinkId)
    }
    
    func copySavedCocktailsFromDBToModel(){
        for (index,cocktailEntity) in favoriteCocktailModel.cocktails.enumerated(){
            //Check if the cocktail is created by user
            //If No add it to rest of the cocktails
            //This done so that already existing cocktails are not fetched from the network
            if !cocktailEntity.isUserDefined{
                let cocktail = favoriteCocktailModel.convertCocktailEntityToCocktail(byIndex: index)
                
                //check if cocktail is already fetched from network
                //if yes override it
                //else add it to the list
                let cocktailIndex = _model.checkIfCocktailExists(drinkId: cocktail.cocktailId)
                if cocktailIndex == -1{
                    _model.cocktails.append(cocktail)
                }else{
                    _model.cocktails[cocktailIndex] = cocktail
                }
            }
        }
        
    }
    
}
