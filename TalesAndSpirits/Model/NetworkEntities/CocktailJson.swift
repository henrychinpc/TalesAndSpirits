//
//  CocktailJSON.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 25/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation

struct CocktailJson: Codable{
    
    let idDrink: String, strDrink: String, strDrinkThumb: String
    let strCategory: String?, strIBA: String?, strGlass: String?, strInstructions: String?
    let strIngredient1: String?, strIngredient2: String?, strIngredient3: String?, strIngredient4: String?, strIngredient5: String?, strIngredient6: String?, strIngredient7: String?, strIngredient8: String?, strIngredient9: String?, strIngredient10: String?
    let strMeasure1: String?, strMeasure2: String?, strMeasure3: String?, strMeasure4: String?, strMeasure5: String?, strMeasure6: String?, strMeasure7: String?, strMeasure8: String?, strMeasure9: String?, strMeasure10: String?
    
}
