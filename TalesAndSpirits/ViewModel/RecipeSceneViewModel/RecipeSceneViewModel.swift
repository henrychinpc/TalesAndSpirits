//
//  RecipeSceneViewModel.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 8/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import UIKit

protocol RefreshRecipeScene {
    func updateUI()
}

class RecipeSceneViewModel: RefreshRecipeSceneModel{
    
    private var cocktail: Cocktail?
    
    var delegate: RefreshRecipeScene?
    
    init(cocktail: Cocktail?){
        if let cocktail = cocktail{
            self.cocktail = cocktail
        }
        REST_Request.shared.detailedViewDelegate = self
    }
    
    func updateModel(_ cocktail: Cocktail) {
        self.cocktail = cocktail
        delegate?.updateUI()
    }
    
    func getCocktailId() -> String?{
        return cocktail?.cocktailId
    }
    
    func getCocktailName() -> String?{
        return cocktail?.cocktailName
    }
    
    func getCocktailImage() -> UIImage?{
        //return cocktail?.image
        if let cocktail = cocktail{
            guard let image = cocktail.image else {
                let url = cocktail.imageName
                guard let imageURL = URL(string: url) else{ return nil}
                let data = try? Data(contentsOf: imageURL)
                var image: UIImage? = nil
                if let imageData = data{
                    image = UIImage(data: imageData)
                }
                cocktail.image = image
                return image
            }
            return image
        }else{
            return nil
        }
        
    }
    
    func getCocktailCategory() -> String?{
        return cocktail?.category
    }
    
    func getCocktailiBA() -> String?{
        return cocktail?.iBA
    }
    
    func getCocktailInstructions() -> String?{
        return cocktail?.instructions
    }
    
    func getCocktailGlassType() -> String?{
        return cocktail?.glassType
    }
    
    func getCocktailPersonalizedNote() -> String?{
        return cocktail?.personalizedNote
    }
    
    func getCocktailIngredients() -> [(name: String, quantity: String)]?{
        return cocktail?.ingredients
    }
    
    func getCocktailIsFavorite() ->Bool?{
        return cocktail?.isFavorite
    }
    
    func getCocktailIsUserDefined() ->Bool?{
        return cocktail?.isUserDefined
    }
    
    func setCocktailAsFavorite(value: Bool){
        cocktail?.isFavorite = value
    }
    
    func setCocktailPersonalNote(note: String){
        cocktail?.personalizedNote = note
    }
    
}
