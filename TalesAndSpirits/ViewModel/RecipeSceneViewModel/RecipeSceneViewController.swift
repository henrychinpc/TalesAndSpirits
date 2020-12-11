//
//  RecipeSceneViewController.swift
//  TalesAndSpirits
//
//  Created by Prodip Guha Roy on 3/9/20.
//  Copyright © 2020 RMIT. All rights reserved.
//

import UIKit

protocol FavouriteCocktailDelegate {
    func addCocktailAsFavorite(_ drinkId: String)
    func removeCocktailAsFavorite(_ drinkId: String)
    func updatePersonalNote(_ drinkId: String,_ note: String)
}

class RecipeSceneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RefreshRecipeScene, UITextViewDelegate {
    
    
    var viewModel: RecipeSceneViewModel?
    var delegate: FavouriteCocktailDelegate?
    
    @IBOutlet weak var cocktailNameLabel: UILabel!
    @IBOutlet weak var cocktailImageView: UIImageView!    
    @IBOutlet weak var saveNoteButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var drinkInfoTableView: UITableView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var preparationLabel: UILabel!
    @IBOutlet weak var personalizedNoteTextView: UITextView!
    
    private let defaultDisabledTextViewMessage = "Add this cocktail to MyDiary to add personal note"
    private let defaultEnabledTextViewMessage = "Add a personal note to your favorite cocktail"
    
    //Assigning delegates to this class and populating view
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        personalizedNoteTextView.delegate = self
        
        
        populateView()
        
        drinkInfoTableView.delegate = self
        drinkInfoTableView.dataSource = self
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
    }
    
    private func populateView(){
        if let viewModel = viewModel{
            cocktailNameLabel.text = viewModel.getCocktailName()
            cocktailImageView.image = viewModel.getCocktailImage()
            preparationLabel.text = viewModel.getCocktailInstructions()
            if let isFavorite = viewModel.getCocktailIsFavorite(){
                if(isFavorite){
                    favoriteButton.setBackgroundImage(UIImage(named: "Star-filled"), for: .normal)
                    saveNoteButton.isEnabled = true
                    personalizedNoteTextView.isEditable = true
                    
                    //Check if personalNote is empty populate Personal Note Text View with placeholder text
                    var personalNote = defaultEnabledTextViewMessage
                    if let note = viewModel.getCocktailPersonalizedNote(){
                        if !note.isEmpty{
                            personalNote = note
                        }
                    }
                    
                    if personalNote != defaultEnabledTextViewMessage{
                        removePlaceholderText()
                        personalizedNoteTextView.text = personalNote
                    }else{
                        showPlaceholderText(defaultEnabledTextViewMessage)
                    }
                    
                }else{
                    favoriteButton.setBackgroundImage(UIImage(named: "Star"), for: .normal)
                    saveNoteButton.isEnabled = false
                    personalizedNoteTextView.isEditable = false
                    showPlaceholderText(defaultDisabledTextViewMessage)
                }
            }
        }
    }
    
    func updateUI() {
        populateView()
        self.drinkInfoTableView.reloadData()
        self.ingredientsTableView.reloadData()
    }
    
    
    //Set Cell Count according to type of tableview- DrinksInfo/Ingredients
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if tableView == self.drinkInfoTableView{
            rowCount = 3
        }else if tableView == self.ingredientsTableView {
            if let viewModel = viewModel, let ingredients = viewModel.getCocktailIngredients() {
                rowCount = ingredients.count
            }
        }
        
        return rowCount
    }
    
    //Populate Table view with cells according to the type of tableview- DrinksInfo/Ingredients
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var finalCell =  UITableViewCell()
        
        if tableView == self.drinkInfoTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
            let infoLabel = cell.viewWithTag(1000) as? UILabel
            let infoLabel2 = cell.viewWithTag(1010) as? UILabel
            
            if let infoLabel = infoLabel, let infoLabel2 = infoLabel2, let viewModel = viewModel {
                if indexPath.row == 0{
                    infoLabel.text = viewModel.getCocktailCategory()
                    infoLabel2.text = "Category"
                }else if indexPath.row == 1{
                    var iBA = "none"
                    if let cocktailiBA = viewModel.getCocktailiBA(){
                        if !cocktailiBA.isEmpty{
                            iBA = cocktailiBA
                        }
                    }
                    infoLabel.text = iBA
                    infoLabel2.text = "iBA"
                }else if indexPath.row == 2{
                    infoLabel.text = viewModel.getCocktailGlassType()
                    infoLabel2.text = "Glass"
                }
            }
            
            finalCell = cell
        }else if tableView == self.ingredientsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
            let infoLabel = cell.viewWithTag(1001) as? UILabel
            let infoLabel2 = cell.viewWithTag(1020) as? UILabel
            
            if let infoLabel = infoLabel, let infoLabel2 = infoLabel2, let viewModel = viewModel, let ingredients = viewModel.getCocktailIngredients() {
                let currentIngredient: (name: String, quantity: String) = ingredients[indexPath.row]
                infoLabel.text = currentIngredient.name
                infoLabel2.text = currentIngredient.quantity
            }
            
            finalCell = cell
        }
        
        return finalCell
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        //If the cocktail is already a favourtite cocktail, show remove alert, else add it favourite
        if favoriteButton.currentBackgroundImage == UIImage(named: "Star-filled"){
            //If the cocktail is created by user, removing it deletes the cocktail. Showing appropriate messages
            if let viewModel = viewModel, let isUserDefined = viewModel.getCocktailIsUserDefined(), isUserDefined{
                showAlert("Once Removed all information regarding this cocktail will be removed from the app. You cannot undo this step. Do you wish to continue?")
            }else{
                showAlert("Once Removed all personal notes will be lost. Do you wish to continue?")
            }
            
        }else{
            //When clicked, the cocktail will be added to favourite and appear under My Diary. Call delegate to add this cocktail to MyDiary
            favoriteButton.setBackgroundImage(UIImage(named: "Star-filled"), for: .normal)
            if let viewModel = viewModel{
                
                if let drinkId = viewModel.getCocktailId(){
                    delegate?.addCocktailAsFavorite(drinkId)
                }
                saveNoteButton.isEnabled = true
                personalizedNoteTextView.isEditable = true
                personalizedNoteTextView.text = defaultEnabledTextViewMessage
            }
            
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if personalizedNoteTextView.text == defaultEnabledTextViewMessage{
        removePlaceholderText()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if personalizedNoteTextView.text.isEmpty{
            if let viewModel = viewModel, let isFavorite = viewModel.getCocktailIsFavorite(){
                var message = defaultDisabledTextViewMessage
                if isFavorite{
                    message = defaultEnabledTextViewMessage
                }
                showPlaceholderText(message)
            }
            
        }
    }
    
    //Check the content in personalizedNoteTextView and update cocktail with current note. Call delegate to passed updated note
    @IBAction func saveNoteButtonPressed(_ sender: Any) {
        if let note = personalizedNoteTextView.text{
            if !note.isEmpty && note != defaultEnabledTextViewMessage{
                if let viewModel = viewModel, let drinkId = viewModel.getCocktailId(), let name = viewModel.getCocktailName(){
                    if note != viewModel.getCocktailPersonalizedNote(){
                        viewModel.setCocktailPersonalNote(note: note)
                        delegate?.updatePersonalNote(drinkId, note)
                        showSuccessMessage(title: "Saved", message: "Personal Note for \(name) saved")
                    }
                }
            }
        }
    }
    
    
    
    private func showAlert(_ message: String){
        let alert = UIAlertController(title: "Remove from MyDiary", message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action  in self.removeFavorite()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
    }
    
    private func showSuccessMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    //This function resets the view to show cocktail that is removed from Favourite(My Diary)
    //Calls the delegate to remove the cocktail from My Diary list
    //If the cocktail is custom cocktail remove the cocktail and exit view
    private func removeFavorite(){
        favoriteButton.setBackgroundImage(UIImage(named: "Star"), for: .normal)
        if let viewModel = viewModel{
            viewModel.setCocktailPersonalNote(note: "")
            if let drinkId = viewModel.getCocktailId(){
                delegate?.removeCocktailAsFavorite(drinkId)
            }
            saveNoteButton.isEnabled = false
            personalizedNoteTextView.isEditable = false
            personalizedNoteTextView.text = defaultDisabledTextViewMessage
            if let isUserDefined = viewModel.getCocktailIsUserDefined(), isUserDefined{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    private func showPlaceholderText(_ message: String){
        personalizedNoteTextView.text = message
        personalizedNoteTextView.textColor = .lightGray
    }
    
    private func removePlaceholderText(){
        personalizedNoteTextView.text = ""
        personalizedNoteTextView.textColor = .black
    }
}
