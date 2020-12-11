//
//  TalesAndSpiritsTests.swift
//  TalesAndSpiritsTests
//
//  Created by GAJSA on 14/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import XCTest
@testable import TalesAndSpirits

class TalesAndSpiritsTests: XCTestCase {
    
    var restRequest: REST_Request!
    var manhattan: Cocktail!
    var sampleDrink: CocktailJson!
    var sessionUnderTest: URLSession!
    var cocktailthis: CocktailsJson!
    var controllerUnderTest: MyDiaryTableViewController!
    var dbManager: CocktailDBManager!
    var homeView: HomeViewController!
    var homeViewModel: HomeViewModel!
    var myDiary: MyDiaryViewModel!
    var cocktailView: CocktailsViewController!
    var recipeScene: RecipeSceneViewModel!

    override func setUp() {
        super.setUp()
    
        manhattan = Cocktail(cocktailId: "1001", cocktailName: "Manhattan", imageName: "1001.jpg")
        
        sampleDrink = CocktailJson(idDrink: "1002", strDrink: "Strong", strDrinkThumb: "1002.jpg", strCategory: "str", strIBA: nil, strGlass: "Old-fashioned glass", strInstructions: "Pour drink into cup", strIngredient1: "Sugar", strIngredient2: "Ice cubes", strIngredient3: "Whisky", strIngredient4: "Gin", strIngredient5: "Water", strIngredient6: nil, strIngredient7: nil, strIngredient8: nil, strIngredient9: nil, strIngredient10: nil, strMeasure1: "1 oz", strMeasure2: "1 oz", strMeasure3: nil, strMeasure4: nil, strMeasure5: nil, strMeasure6: nil, strMeasure7: nil, strMeasure8: nil, strMeasure9: nil, strMeasure10: nil)

        sessionUnderTest = URLSession(configuration: .default)
        restRequest?.cocktails.append(manhattan)
        
        
    }

    override func tearDown() {
        super.tearDown()
        
        manhattan = nil
        sampleDrink = nil
        sessionUnderTest = nil

    }

    func testCocktail() {
        
        XCTAssertEqual(manhattan.cocktailId, "1001")
        XCTAssertFalse(manhattan.cocktailName == "Manhatan")
        XCTAssertTrue((manhattan.imageName).contains(".jpg"))
        XCTAssertFalse(manhattan.isFavorite, "It should not be a favourite by default")
        XCTAssertFalse(manhattan.isUserDefined, "It should not be a user defined drink")
    }
    
    func testCocktailJSON() {
        
        XCTAssertTrue(sampleDrink.strIBA == nil)
        XCTAssertTrue(sampleDrink.strIngredient1 != nil)
        XCTAssertTrue((sampleDrink.idDrink).contains("1002"))
        XCTAssertFalse((sampleDrink.strInstructions)!.isEmpty)
        XCTAssertEqual(sampleDrink.strMeasure2, "1 oz")
    }
    
    func testPerformance() {
        
        let cock = CocktailsViewController()
    
        measure {
            cock.updateUIWithRestData()
            
        }
    }
    
    func testDB() {

        XCTAssertTrue(REST_Request().cocktails.count == 0, "It should not be populated by default")
        XCTAssertTrue(REST_Request().popularCocktails.count == 0, "It should not be populated by default")
        XCTAssertEqual(dbManager?.appDelegate, nil)
        XCTAssertTrue(dbManager?.cocktails.count == nil)
    }

    
    func testValidURLStatusCode200() {
        
        // baseURL used for the app is a paid service, so we are only checking for the availability of the site here
        let url = URL(string: "https://www.thecocktaildb.com/")
        
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code : \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
    }
    
}
