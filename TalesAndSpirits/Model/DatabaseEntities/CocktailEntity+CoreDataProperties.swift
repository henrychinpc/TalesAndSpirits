//
//  CocktailEntity+CoreDataProperties.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 6/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//
//

import Foundation
import CoreData


extension CocktailEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CocktailEntity> {
        return NSFetchRequest<CocktailEntity>(entityName: "CocktailEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var category: String?
    @NSManaged public var iba: String?
    @NSManaged public var instructions: String?
    @NSManaged public var glassType: String?
    @NSManaged public var isUserDefined: Bool
    @NSManaged public var personalizedNote: String?
    @NSManaged public var ingredients: NSSet?

}

// MARK: Generated accessors for ingredients
extension CocktailEntity {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}
