//
//  CocktailDBManager.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 6/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CocktailDBManager{
    
    static let shared = CocktailDBManager()
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let managedContext: NSManagedObjectContext
    
    private (set) var cocktails: [CocktailEntity]
    
    //Add to database
    func addCocktail( _ cocktail: Cocktail){
        
        let nsCocktail = createNSCocktail(cocktail)
        cocktails.append(nsCocktail)
        
        do {
            try managedContext.save()
        }catch let error as NSError{
            print("Unable to save data to core data:  \(error), \(error.userInfo)")
        }
        
    }
    
    //Delete from database
    func deleteCocktail(_ drinkId: String){
        
        let index = fetchIndexByDrinkId(drinkId)
        
        if index != -1 {
            let cocktailToRemove = cocktails.remove(at: index)
            //Delete data from context
            managedContext.delete(cocktailToRemove)
            
            // save the context to remove the data
            do{
                try managedContext.save()
            }catch let error as NSError{
                print("Unable to remove data from core data:  \(error), \(error.userInfo)")
            }
        }
        
    }
    
    //Update entry in database
    func updateCocktailWithNote(_ drinkId: String,_ note: String){
        
        let index = fetchIndexByDrinkId(drinkId)
        
        if index != -1 {
            let nsCocktail = cocktails[index]
            nsCocktail.setValue(note, forKeyPath: "personalizedNote")
            do {
                try managedContext.save()
            }catch let error as NSError{
                print("Unable to save data to core data:  \(error), \(error.userInfo)")
            }
        }
    }
    
    
    private func fetchIndexByDrinkId(_ drinkId: String) -> Int{
        for (index, cocktail) in cocktails.enumerated(){
            if cocktail.id == drinkId{
                return index
            }
        }
        return -1
    }
    
    //Read from database, executed once during app start-up
    private func loadCocktails(){
        do{
            let result = try managedContext.fetch(CocktailEntity.fetchRequest())
            cocktails = result as! [CocktailEntity]
        }catch let error as NSError{
            print("Unable to load data from core data: \(error), \(error.userInfo)")
        }
    }
    
    
    
    private func createNSIngredient(_ name: String, _ quantity: String) -> Ingredient{
        
        let ingredientEntity = NSEntityDescription.entity(forEntityName: "Ingredient", in: managedContext)!
        
        let nsIngredient = NSManagedObject(entity: ingredientEntity, insertInto: managedContext) as! Ingredient
        
        nsIngredient.setValue(name, forKeyPath: "name")
        nsIngredient.setValue(quantity, forKeyPath: "quantity")
        
        return nsIngredient
    }
    
    private func createNSCocktail(_ cocktail: Cocktail) -> CocktailEntity{
        let cocktailEntity = NSEntityDescription.entity(forEntityName: "CocktailEntity", in: managedContext)!
        
        let nsCocktail = NSManagedObject(entity: cocktailEntity, insertInto: managedContext) as! CocktailEntity
        
        nsCocktail.setValue(cocktail.cocktailId, forKeyPath: "id")
        nsCocktail.setValue(cocktail.cocktailName, forKeyPath: "name")
        nsCocktail.setValue(cocktail.category, forKeyPath: "category")
        nsCocktail.setValue(cocktail.iBA, forKeyPath: "iba")
        nsCocktail.setValue(cocktail.instructions, forKeyPath: "instructions")
        nsCocktail.setValue(cocktail.glassType, forKeyPath: "glassType")
        nsCocktail.setValue(cocktail.personalizedNote, forKeyPath: "personalizedNote")
        nsCocktail.setValue(cocktail.isUserDefined, forKeyPath: "isUserDefined")
        
        if let image = cocktail.image{
            let imageData = UIImageJPEGRepresentation(image, 0.8) as NSData?
            nsCocktail.image = imageData
        }
        
        for ingredient in cocktail.ingredients{
            let nsIngredient = createNSIngredient(ingredient.name, ingredient.quantity)
            nsCocktail.addToIngredients(nsIngredient)
        }
        
        return nsCocktail
        
    }
    
    func convertCocktailEntityToCocktail(byIndex index: Int) -> Cocktail{
        let cocktailEntity = cocktails[index]
        let cocktail = Cocktail(cocktailId: cocktailEntity.id!, cocktailName: cocktailEntity.name!, imageName: "")
        
        cocktail.isUserDefined = cocktailEntity.isUserDefined
        cocktail.isFavorite = true
        
        if let category = cocktailEntity.category{
            cocktail.category =  category
        }
        if let glassType = cocktailEntity.glassType{
            cocktail.glassType =  glassType
        }
        if let iBA = cocktailEntity.iba{
            cocktail.iBA =  iBA
            
        }
        if let image = cocktailEntity.image{
            cocktail.image = UIImage(data: image as Data)
        }
        if let instructions = cocktailEntity.instructions{
            cocktail.instructions =  instructions
            
        }
        if let personalizedNote = cocktailEntity.personalizedNote{
            cocktail.personalizedNote =  personalizedNote
            
        }
        
        if let ingredients = cocktailEntity.ingredients{
            for ingredient in ingredients{
                if let ingredient = ingredient as? Ingredient{
                    cocktail.ingredients.append((name: ingredient.name!, quantity: ingredient.quantity!))
                }
            }
        }
        
        return cocktail
    }
    
    private init(){
        managedContext = appDelegate.persistentContainer.viewContext
        cocktails = []
        loadCocktails()
    }
    
    
    
}
