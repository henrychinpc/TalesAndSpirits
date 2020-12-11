//
//  TalesAndSpiritsUITests.swift
//  TalesAndSpiritsUITests
//
//  Created by GAJSA on 14/8/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import XCTest

class TalesAndSpiritsUITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHomeHasCollectionView(){
        
        let app = XCUIApplication()
        XCTAssertTrue(app.collectionViews.element.exists)
        
    }
    
    func testFavouriteIsAdded(){
        
        let app = XCUIApplication()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Mojito").element.tap()
        app.scrollViews.otherElements.buttons["Star"].tap()
        XCTAssertTrue(app.buttons["Star"].isEnabled)
        
    }
    
    
    
    func testCocktailHasTableView(){
        
        let app = XCUIApplication()
        XCUIApplication().tabBars.buttons["Cocktails"].tap()
        XCTAssertTrue(app.tables.element.exists)
        XCTAssertFalse(app.collectionViews.element.exists)
        
    }
    
    
    
    func testAddNewCocktailViewButtonExists() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["My Diary"].tap()
        app.tables/*@START_MENU_TOKEN@*/.buttons["icons8 add 100"]/*[[".cells.buttons[\"icons8 add 100\"]",".buttons[\"icons8 add 100\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.buttons["Pick From Library"].exists)
        XCTAssertTrue(app.textFields["Quantity"].exists)
        
    }
    
    
    
    func testDeveloperLabelExist(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["More"].tap()
        let tf = app.staticTexts["DEVELOPMENT TEAM"]
        XCTAssertTrue(tf.exists)
        
    }
}
