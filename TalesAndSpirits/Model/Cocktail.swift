//
//  SampleCocktail.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 24/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import UIKit

class Cocktail {
    
    private var customCocktailId = UUID()
    private var _cocktailId: String
    private var _cocktailName: String
    private var _imageName: String
    private var _image: UIImage?
    private var _ingredients: [(name: String, quantity: String)]
    private var _category: String
    private var _iBA: String
    private var _instructions: String
    private var _glassType: String
    private var _isUserDefined: Bool
    private var _personalizedNote: String
    private var _isFavorite: Bool
    
    var cocktailId: String{
        get { return _cocktailId}
        set(newId){ _cocktailId = newId}
    }
    
    var cocktailName: String {
        get { return _cocktailName }
        set(newName) {
            _cocktailName = newName
        }
    }
    
    var imageName: String {
        get { return _imageName }
        set(newImageName) {
            _imageName = newImageName
        }
    }
    
    var image: UIImage? {
        get {return _image}
        set(newImage) {
            _image = newImage
        }
    }
    
    var ingredients: [(name: String, quantity: String)] {
        get { return _ingredients}
        set(newIngredients){
            _ingredients = newIngredients
        }
    }
    
    var category: String {
        get { return _category }
        set(newcategory) {
            _category = newcategory
        }
    }
    
    var iBA: String {
        get { return _iBA }
        set(newiBA) {
            _iBA = newiBA
        }
    }
    
    var instructions: String {
        get { return _instructions }
        set(newInstructions) {
            _instructions = newInstructions
        }
    }
    
    var glassType: String {
        get { return _glassType }
        set(newGlassType) {
            _glassType = newGlassType
        }
    }
    
    var isUserDefined: Bool {
        get { return _isUserDefined }
        set(newValue) {
            _isUserDefined = newValue
        }
    }
    
    var personalizedNote: String {
        get { return _personalizedNote }
        set(newNote) {
            _personalizedNote = newNote
        }
    }
    
    var isFavorite: Bool {
        get { return _isFavorite }
        set(newValue) {
            _isFavorite = newValue
        }
    }
    
    init(cocktailId: String, cocktailName: String, imageName: String) {
        if cocktailId.isEmpty{
            self._cocktailId = customCocktailId.uuidString
        }else{
            self._cocktailId = cocktailId
        }
        self._cocktailName = cocktailName
        self._imageName = imageName
        self._ingredients = []
        self._category = ""
        self._iBA = ""
        self._glassType = ""
        self._instructions = ""
        self._isUserDefined = false
        self._personalizedNote = ""
        self._isFavorite = false
        self._image = nil
    }
    
}


