//
//  Ingredient+CoreDataProperties.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 6/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: String?
    @NSManaged public var cocktail: CocktailEntity?

}
