//
//  HomeViewModel.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 9/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import Foundation
import UIKit

class HomeViewModel: CocktailViewModel{
    
    private let randomizeImageName: String = "random-dice"
    private let randomizeText: String = "Surprise Me"
    
    override var count: Int{
        return model.popularCocktails.count
    }
    
    func getRandomizeImage() -> UIImage?{
        return UIImage(named: randomizeImageName)
    }
    
    func getRandomizeText() -> String{
        return randomizeText
    }
    
    override func getCocktailName(byIndex index: Int) -> String{
        return model.popularCocktails[index].cocktailName
    }
    
    override func getCocktailImage(byIndex index: Int) -> UIImage?{
        //Check if model contains image, else fetch image from network
        guard let image = model.popularCocktails[index].image else {
            let url = model.popularCocktails[index].imageName
            guard let imageURL = URL(string: url) else{ return nil}
            let data = try? Data(contentsOf: imageURL)
            var image: UIImage? = nil
            if let imageData = data{
                image = UIImage(data: imageData)
            }
            model.popularCocktails[index].image = image
            return image
        }
        return image
    }
    
    override func fetchCocktailById(index: Int){
        let newIndex = fetchIndexByDrinkId(model.popularCocktails[index].cocktailId)
        super.fetchCocktailById(index: newIndex)
    }
    
    override func getCocktail(byIndex index: Int) -> Cocktail{
        return model.popularCocktails[index]
    }
    
    func fetchRandomCocktail(){
        model.fetchRandomCocktail()
    }
}
