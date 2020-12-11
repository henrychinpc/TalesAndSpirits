//
//  AddNewCocktailController.swift
//  TalesAndSpirits
//
//  Created by GAJSA on 2/10/20.
//  Copyright © 2020 RMIT. All rights reserved.
//
import Foundation
import UIKit
import AVKit
import MobileCoreServices

protocol UserDefinedCocktail{
    func addCocktail(_ cocktailDetails: [String: String], image: UIImage?)
}

class AddNewCocktailController: UIViewController,UITextViewDelegate{
    

    @IBOutlet weak var RecipeText: UITextView!
    @IBOutlet weak var NoteTextView: UITextView!
    
    @IBOutlet weak var cocktailNameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var iBATextField: UITextField!
    @IBOutlet weak var glassTextField: UITextField!
    
    
    @IBOutlet weak var ingredient1TextField: UITextField!
    @IBOutlet weak var ingredient2TextField: UITextField!
    @IBOutlet weak var ingredient3TextField: UITextField!
    @IBOutlet weak var ingredient4TextField: UITextField!
    @IBOutlet weak var ingredient5TextField: UITextField!
    
    
    @IBOutlet weak var quantity1TextField: UITextField!
    @IBOutlet weak var quantity2TextField: UITextField!
    @IBOutlet weak var quantity3TextField: UITextField!
    @IBOutlet weak var quantity4TextField: UITextField!
    @IBOutlet weak var quantity5TextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var takePictureButton: UIButton!
    
    var avPlayerViewController: AVPlayerViewController!
    
    var delegate: UserDefinedCocktail?
    
    var image: UIImage?
    var movieURL: URL?
    var lastChosenMediaType: String?
    
    private let defaultRecipeTextViewMessage: String = "Enter recipe here"
    private let defaultNoteTextViewMessage: String = "Enter notes here"
    
    // Does not get called when returning after selecting the
    // media to display.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // If the camera source (i.e. simulator) is not available, then
        // hide the take picture button.
        if !UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera) {
            takePictureButton.isEnabled = false
        }
        
        RecipeText.delegate = self
        NoteTextView.delegate = self
        
        self.RecipeText.layer.borderWidth = 1
        self.NoteTextView.layer.borderWidth = 1
        self.RecipeText.layer.borderColor = UIColor.lightGray.cgColor
        self.NoteTextView.layer.borderColor = UIColor.lightGray.cgColor
        RecipeText.text = defaultRecipeTextViewMessage
        RecipeText.textColor = UIColor.lightGray
        NoteTextView.text = defaultNoteTextViewMessage
        NoteTextView.textColor = UIColor.lightGray
        RecipeText.layer.cornerRadius = 5
        RecipeText.clipsToBounds = true
        NoteTextView.layer.cornerRadius = 5
        NoteTextView.clipsToBounds = true
        imageView.image = UIImage(named: "no_image_available")
    }
    
    // When returning to the app, update the display with the
    // chosen media type
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
    }
    
    func updateDisplay() {
        
        // optional, so if let used to unwrap.
        if let mediaType = lastChosenMediaType {
            
            // if the media chosen is an image, then get the
            // image and display it.
            
            // MobileCore Services Package
            if mediaType == (kUTTypeImage as NSString) as String {
                imageView.image = image!
                imageView.isHidden = false
                if avPlayerViewController != nil {
                    avPlayerViewController!.view.isHidden = true
                }
                
                // Otherwise the media chosen is a video
            } else if mediaType == (kUTTypeMovie as NSString) as String {
                if avPlayerViewController == nil {
                    // Instantiate a view for displaying the video
                    avPlayerViewController = AVPlayerViewController()
                    let avPlayerView = avPlayerViewController!.view
                    avPlayerView?.frame = imageView.frame
                    avPlayerView?.clipsToBounds = true
                    view.addSubview(avPlayerView!)
                }
                
                if let url = movieURL {
                    imageView.isHidden = true
                    avPlayerViewController.player = AVPlayer(url: url)
                    avPlayerViewController!.view.isHidden = false
                    avPlayerViewController!.player!.play()
                }
            }
        }
    }
    
    
    @IBAction func shootPicture(_ sender: Any) {
        pickMediaFromSource(UIImagePickerControllerSourceType.camera)
        
    }
   
    
    @IBAction func selectExistingPictureOrVideo(_ sender: UIButton) {
        pickMediaFromSource(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    // This method gets called by the action methods to select
    // what type of media the user wants.
    func pickMediaFromSource(_ sourceType:UIImagePickerControllerSourceType)
    {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
            
        {
            // Instantiate an image picker
            let picker = UIImagePickerController()
            
            // Display the media types avaialble on the picker
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType)!
            
            // Set delegate to self for system method calls.
            // This needs to be the delegate for both the picker
            // controller and the navigation controller.
            picker.delegate = self
            
            // Is the user allowed to edit the media
            picker.allowsEditing = true
            picker.sourceType = sourceType
            
            // Present the picker to the user.
            present(picker, animated: true, completion: nil)
        }
            // Otherwise display an error message
        else
        {
            let alertController = UIAlertController(title:"Error accessing media",message: "Unsupported media source.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    

    
    

    
    //When Save button is clicked
    //Validate the user inputs
    //Call delegate to add cocktail to My Diary
    //Mandatory fields to be filled by user: CocktailName, Image(can be no_image_available as well) and At least 1 entry for ingredient and quantity
    @IBAction func SaveNewCocktail(_ sender: Any) {
        
        var cocktailDetails: [String: String] = [:]
        
        var missingUserInput: Bool = false
        var totalIngredientsEntered: Int = 0
        var fieldsMissingInput: String = ""
        
        if let name = cocktailNameTextField.text, !name.isEmpty{
                cocktailDetails["name"] = name
        }else{
            showMissingEntryAlert("Name field cannot be empty. Please enter name of cocktail")
            return
        }
        
        guard imageView.image != nil else{
            showMissingEntryAlert("Image cannot be empty. Please Upload Image of cocktail")
            return
        }
        
        if let category = categoryTextField.text, !category.isEmpty{
            cocktailDetails["category"] = category
        }else{
            missingUserInput = true
            fieldsMissingInput.append("Category\n")
        }
        
        if let iBA = iBATextField.text, !iBA.isEmpty{
            cocktailDetails["iBA"] = iBA
        }else{
            missingUserInput = true
            fieldsMissingInput.append("iBA\n")
        }
        
        if let glass = glassTextField.text, !glass.isEmpty{
            cocktailDetails["glass"] = glass
        }else{
            missingUserInput = true
            fieldsMissingInput.append("Glass\n")
        }
        
        if let recipe = RecipeText.text, !recipe.isEmpty && recipe != defaultRecipeTextViewMessage{
            cocktailDetails["recipe"] = recipe
        }else{
            missingUserInput = true
            fieldsMissingInput.append("Recipe\n")
        }
        
        if let note = NoteTextView.text, !note.isEmpty && note != defaultNoteTextViewMessage{
            cocktailDetails["note"] = note
        }
        
        if let ingredient = ingredient1TextField.text, let quantity = quantity1TextField.text, !ingredient.isEmpty && !quantity.isEmpty{
            cocktailDetails["ingredient1"] = ingredient
            cocktailDetails["quantity1"] = quantity
            totalIngredientsEntered += 1
        }else{
            showMissingEntryAlert("Cocktail should have atleast 1 ingredient and its quantity. Please Enter ingredient name and quantity")
            return
        }
        
        if let ingredient = ingredient2TextField.text, let quantity = quantity2TextField.text, !ingredient.isEmpty && !quantity.isEmpty{
            cocktailDetails["ingredient2"] = ingredient
            cocktailDetails["quantity2"] = quantity
            totalIngredientsEntered += 1
        }
        
        if let ingredient = ingredient3TextField.text, let quantity = quantity3TextField.text, !ingredient.isEmpty && !quantity.isEmpty{
            cocktailDetails["ingredient3"] = ingredient
            cocktailDetails["quantity3"] = quantity
            totalIngredientsEntered += 1
        }
        
        if let ingredient = ingredient4TextField.text, let quantity = quantity4TextField.text, !ingredient.isEmpty && !quantity.isEmpty{
            cocktailDetails["ingredient4"] = ingredient
            cocktailDetails["quantity4"] = quantity
            totalIngredientsEntered += 1
        }
        
        if let ingredient = ingredient5TextField.text, let quantity = quantity5TextField.text, !ingredient.isEmpty && !quantity.isEmpty{
            cocktailDetails["ingredient5"] = ingredient
            cocktailDetails["quantity5"] = quantity
            totalIngredientsEntered += 1
        }
        
        showConfirmationAlert(missingUserInput, fieldsMissingInput ,cocktailDetails, imageView.image)
        
    }
    
    func showConfirmationAlert(_ missingUserInput: Bool,_ fieldsMissingInput: String ,_ cocktailDetails: [String: String],_ image: UIImage?){
        
        var message: String = ""
        
        if missingUserInput{
            message.append("The following fields are empty\n")
            message.append(fieldsMissingInput)
            message.append("Any field left empty cannot be edited later!\n")
        }
        message.append("Do you wish to continue saving this cocktail?")
        
        let alert = UIAlertController(title: "Save Cocktail to MyDiary", message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action  in self.saveDataAndExit(cocktailDetails, image)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        
        present(alert, animated: true)
    }
    
    //Save cocktail details and exit view
    func saveDataAndExit(_ cocktailDetails: [String: String],_ image: UIImage?){
        delegate?.addCocktail(cocktailDetails, image: imageView.image)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showMissingEntryAlert(_ message: String){
        
        let alert = UIAlertController(title: "Invalid/Missing Entry", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == RecipeText && RecipeText.text == defaultRecipeTextViewMessage{
            RecipeText.text = ""
            RecipeText.textColor = .black
        }
        if textView == NoteTextView && NoteTextView.text == defaultNoteTextViewMessage{
            NoteTextView.text = ""
            NoteTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == RecipeText && RecipeText.text.isEmpty{
            RecipeText.text = defaultRecipeTextViewMessage
            RecipeText.textColor = .lightGray
        }
        if textView == NoteTextView && NoteTextView.text.isEmpty{
            NoteTextView.text = defaultNoteTextViewMessage
            NoteTextView.textColor = .lightGray
        }
    }
    
    
    
    
}


extension AddNewCocktailController: UIImagePickerControllerDelegate
{
    // Delegate method to process once the media has been selected
    // by the user.
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        
        // Set the variable to the data retrieved.
        if let mediaType = lastChosenMediaType {
            if mediaType == (kUTTypeImage as NSString) as String {
                image = info[UIImagePickerControllerEditedImage] as? UIImage
                saveImage(image: image!, path: "test")
                
            } else if mediaType == (kUTTypeMovie as NSString) as String {
                movieURL = info[UIImagePickerControllerMediaURL] as? URL
            }
        }
        
        // Dismiss the picker to return to the apps view
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage (image: UIImage, path: String)
    {
        let pngImageData = UIImagePNGRepresentation(image)
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageUniqueName : Int64 = Int64(NSDate().timeIntervalSince1970 * 1000);
        let filePath = docDir.appendingPathComponent("\(imageUniqueName).png");
        
        do{
            try pngImageData?.write(to : filePath , options : .atomic)
            
        }catch{
            print("couldn't write image")
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}


extension AddNewCocktailController:UINavigationControllerDelegate{}
