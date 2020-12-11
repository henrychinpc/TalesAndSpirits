//
//  REST_Request.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 25/9/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import UIKit

protocol RefreshData {
    func updateUIWithRestData()
}

protocol RefreshRecipeSceneModel {
    func updateModel(_ cocktail: Cocktail)
}

class REST_Request{
    
    private var _cocktails:[Cocktail]
    private var _popularCocktails: [Cocktail]
    var delegate: RefreshData?
    
    var detailedViewDelegate: RefreshRecipeSceneModel?
    
    static let shared = REST_Request()
    
    private let session = URLSession.shared
    private let baseUrl:String = "https://www.thecocktaildb.com/api/json/v2/9973533/"
    private let listCocktails:String = "filter.php?c=Cocktail"
    private let lookupCocktailById: String = "lookup.php?i="
    private let popularCoctails: String = "popular.php"
    private let randomize:String = "random.php"
    
    var cocktails:[Cocktail]{
        get { return _cocktails}
        set(newCocktails){
            _cocktails = newCocktails
        }
    }
    
    var popularCocktails:[Cocktail]{
        get { return _popularCocktails}
        set(newCocktails){
            _popularCocktails = newCocktails
        }
    }
    
    init(){
        _cocktails = []
        _popularCocktails = []
        fetchPopularCocktails()
    }
    
    private func fetchCocktails(){
        let url = baseUrl + listCocktails
        
        if let url = URL(string: url){
            let request = URLRequest(url: url)
            getCocktailList(request)
        }
    }
    
    func fetchCocktailById(index: Int){
        let id = _cocktails[index].cocktailId
        
        let url = baseUrl + lookupCocktailById + id
        if let url = URL(string: url){
            let request = URLRequest(url: url)
            getCocktailById(request, index: index)
        }
        
    }
    
    func fetchRandomCocktail(){
        let url = baseUrl + randomize
        if let url = URL(string: url){
            let request = URLRequest(url: url)
            getRandomCocktail(request)
        }
        
    }
    
    private func fetchPopularCocktails(){
        let url = baseUrl + popularCoctails
        if let url = URL(string: url){
            let request = URLRequest(url: url)
            getPopularCocktail(request)
        }
    }
    
    private func getCocktailList(_ request: URLRequest){
        let task = session.dataTask(with: request, completionHandler: {
            data, response, fetchError in
            if let error = fetchError{
                print(error)
            }else{
                let fetchDetails: CocktailsJson = try! JSONDecoder().decode(CocktailsJson.self, from: data!)
                let allCocktails = fetchDetails.drinks
                for cocktail in allCocktails{
                    //Check if cocktail already exists
                    //If no add it to the list
                    if(self.checkIfCocktailExists(drinkId: cocktail.idDrink) == -1){
                        let newCocktail = Cocktail(cocktailId: cocktail.idDrink, cocktailName: cocktail.strDrink, imageName: cocktail.strDrinkThumb)
                        self._cocktails.append(newCocktail)
                    }
                }
                //Notify Controller Cocktail Data is retrieved and start fetching images asynchronously
                DispatchQueue.main.sync {
                    self.delegate?.updateUIWithRestData()
                    self.getCocktailImagesAsync()
                }
            }
        })
        task.resume()
    }
    
    private func getCocktailById(_ request: URLRequest, index: Int){
        let task = session.dataTask(with: request, completionHandler: {
            data, response, fetchError in
            if let error = fetchError{
                print(error)
            }else{
                let fetchDetails: CocktailsJson = try! JSONDecoder().decode(CocktailsJson.self, from: data!)
                if fetchDetails.drinks.count > 0{
                    let cocktailDetails = fetchDetails.drinks[0]
                    self.fetchDetailsFromJson(cocktailJson: cocktailDetails, index: index)
                }
                DispatchQueue.main.sync {
                    self.detailedViewDelegate?.updateModel(self.cocktails[index])
                }
            }
        })
        task.priority = 1.0
        task.resume()
    }
    
    //This function starts fetching images in the background while the user views the data
    //The priority is set to low so that other network call made by user are executed first
    private func getCocktailImagesAsync(){
        for cocktail in cocktails{
            if cocktail.image == nil{
                fetchCocktailImageAsync(cocktail)
            }
        }
    }
    
    private func fetchCocktailImageAsync(_ cocktail: Cocktail){
        let url = cocktail.imageName
        guard let imageURL = URL(string: url) else{ return }
        
        let task = session.dataTask(with: imageURL) { (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    cocktail.image = UIImage(data: data)
                }
            }
        }
        
        task.priority = 0.0
        task.resume()
    }
    
    private func getRandomCocktail(_ request: URLRequest){
        let task = session.dataTask(with: request, completionHandler: {
            data, response, fetchError in
            if let error = fetchError{
                print(error)
            }else{
                var index = self._cocktails.count //setting default index as last of the array
                let fetchDetails: CocktailsJson = try! JSONDecoder().decode(CocktailsJson.self, from: data!)
                if fetchDetails.drinks.count > 0{
                    let cocktailDetails = fetchDetails.drinks[0]
                    //checking if cocktail already exists
                    let getCocktailIndex = self.checkIfCocktailExists(drinkId: cocktailDetails.idDrink)
                    if( getCocktailIndex != -1){
                        index = getCocktailIndex
                    }
                    self.fetchDetailsFromJson(cocktailJson: cocktailDetails, index: index)
                }
                
                DispatchQueue.main.sync {
                    self.detailedViewDelegate?.updateModel(self.cocktails[index])
                }
            }
        })
        task.priority = 1.0
        task.resume()
    }
    
    //This function is called during initialization
    //Since this is singleton class, this function is also called once
    //Once the popular cocktails are fetched, all cocktails fetch call is initiated to fetch detail in background
    private func getPopularCocktail(_ request: URLRequest){
        let task = session.dataTask(with: request, completionHandler: {
            data, response, fetchError in
            if let error = fetchError{
                print(error)
            }else{
                let fetchDetails: CocktailsJson = try! JSONDecoder().decode(CocktailsJson.self, from: data!)
                let allCocktails = fetchDetails.drinks
                for cocktail in allCocktails{
                    let index = self.checkIfCocktailExists(drinkId: cocktail.idDrink)
                    //Check if cocktail already exists
                    //If no add it to both popular and allCocktails list
                    if(index == -1){
                        let newCocktail = Cocktail(cocktailId: cocktail.idDrink, cocktailName: cocktail.strDrink, imageName: cocktail.strDrinkThumb)
                        self._cocktails.append(newCocktail)
                        self._popularCocktails.append(newCocktail)
                    }
                    //If the cocktail exists in allCocktails list, add it to the popular cocktail list
                    else{
                        self._popularCocktails.append(self._cocktails[index])
                    }
                }
                //Notify Controller, Cocktail Data is retrieved and start fetching remaining cocktails aysnchronously
                DispatchQueue.main.sync {
                    self.delegate?.updateUIWithRestData()
                    self.fetchCocktails()
                }
            }
        })
        task.resume()
    }
    
    /**
     * This function checks the _cocktails list to find if a object exists with id = drinkid
     * if found, return index of cocktail object
     * else return -1
     */
    public func checkIfCocktailExists( drinkId: String) -> Int{
        for (index, cocktail) in _cocktails.enumerated(){
            if cocktail.cocktailId == drinkId{
                return index
            }
        }
        return -1
    }
    
    private func fetchDetailsFromJson(cocktailJson: CocktailJson, index: Int) {
        
        //If index equal count of cocktails, adding new cocktail
        if index == _cocktails.count{
            let newCocktail = Cocktail(cocktailId: cocktailJson.idDrink, cocktailName: cocktailJson.strDrink, imageName: cocktailJson.strDrinkThumb)
            self._cocktails.append(newCocktail)
            
        }
        //let newCocktail = Cocktail(cocktailId: "",cocktailName: cocktailJson.strDrink, imageName: cocktailJson.strDrinkThumb)
        let cocktail = self._cocktails[index]
        
        if let category = cocktailJson.strCategory{
            cocktail.category =  category
        }
        if let glassType = cocktailJson.strGlass{
            cocktail.glassType =  glassType
        }
        if let iBA = cocktailJson.strIBA{
            cocktail.iBA =  iBA
            
        }
        if let instructions = cocktailJson.strInstructions {
            cocktail.instructions =  instructions
        }
        
        //Populating ingredients
        var ingredientsList: [(name: String, quantity: String)] = []
        var ingredient: (name: String, quantity: String)
        
        if let ingredientName = cocktailJson.strIngredient1, let quantity = cocktailJson.strMeasure1 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        if let ingredientName = cocktailJson.strIngredient2, let quantity = cocktailJson.strMeasure2 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        if let ingredientName = cocktailJson.strIngredient3, let quantity = cocktailJson.strMeasure3 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        if let ingredientName = cocktailJson.strIngredient4, let quantity = cocktailJson.strMeasure4 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        if let ingredientName = cocktailJson.strIngredient5, let quantity = cocktailJson.strMeasure5 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        if let ingredientName = cocktailJson.strIngredient6, let quantity = cocktailJson.strMeasure6 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        if let ingredientName = cocktailJson.strIngredient7, let quantity = cocktailJson.strMeasure7 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        
        if let ingredientName = cocktailJson.strIngredient8, let quantity = cocktailJson.strMeasure8 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        if let ingredientName = cocktailJson.strIngredient9, let quantity = cocktailJson.strMeasure9 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        if let ingredientName = cocktailJson.strIngredient10, let quantity = cocktailJson.strMeasure10 {
            ingredient.name = ingredientName
            ingredient.quantity = quantity
            ingredientsList.append(ingredient)
        }
        
        cocktail.ingredients = ingredientsList
    }
    
}
