//
//  MyDiaryViewModel.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 9/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import UIKit

class MyDiaryViewModel: CocktailViewModel{
    
    override init() {
        super.init()
        super.copySavedCocktailsFromDBToModel()
    }
    
    override var count: Int{
        return favoriteCocktailModel.cocktails.count
    }
    
    override func getCocktailImage(byIndex index: Int) -> UIImage?{
        return UIImage(data: favoriteCocktailModel.cocktails[index].image! as Data)
    }
    
    override func getCocktailName(byIndex index: Int) -> String{
        return favoriteCocktailModel.cocktails[index].name!
    }
    
    override func getCocktail(byIndex index: Int) -> Cocktail{
        return favoriteCocktailModel.convertCocktailEntityToCocktail(byIndex: index)
    }
    
    func addUserDefinedCocktail(_ cocktailDetails: [String: String], image: UIImage?){
        
        if let name = cocktailDetails["name"]{
        let newCocktail = Cocktail(cocktailId: "", cocktailName: name, imageName: "")
            newCocktail.isUserDefined = true
            newCocktail.isFavorite = true
            newCocktail.image = image
            
            if let category = cocktailDetails["category"]{
                newCocktail.category = category
            }
            
            if let iBA = cocktailDetails["iBA"]{
                newCocktail.iBA = iBA
            }
            
            if let glassType = cocktailDetails["glass"]{
                newCocktail.glassType = glassType
            }
            
            if let recipe = cocktailDetails["recipe"]{
                newCocktail.instructions = recipe
            }
            
            if let note = cocktailDetails["note"]{
                newCocktail.personalizedNote = note
            }
            
            if let ingredient = cocktailDetails["ingredient1"], let quantity = cocktailDetails["quantity1"]{
                newCocktail.ingredients.append((name: ingredient, quantity: quantity))
            }
            
            if let ingredient = cocktailDetails["ingredient2"], let quantity = cocktailDetails["quantity2"]{
                newCocktail.ingredients.append((name: ingredient, quantity: quantity))
            }
            
            if let ingredient = cocktailDetails["ingredient3"], let quantity = cocktailDetails["quantity3"]{
                newCocktail.ingredients.append((name: ingredient, quantity: quantity))
            }
            
            if let ingredient = cocktailDetails["ingredient4"], let quantity = cocktailDetails["quantity4"]{
                newCocktail.ingredients.append((name: ingredient, quantity: quantity))
            }
            
            if let ingredient = cocktailDetails["ingredient5"], let quantity = cocktailDetails["quantity5"]{
                newCocktail.ingredients.append((name: ingredient, quantity: quantity))
            }
            
            favoriteCocktailModel.addCocktail(newCocktail)
        }
        
        
    }
}
