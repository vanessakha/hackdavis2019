//
//  BuildingViewController.swift
//  hackdavis2019
//
//  Created by Vanessa on 2/9/19.
//  Copyright © 2019 tut. All rights reserved.
//

import UIKit
import os.log
import Foundation
import CoreData
import CoreGraphics
import AWSS3
import AWSMobileClient
import AWSDynamoDB
import AWSLambda

class BuildingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var steamDataLabel: UILabel!
    @IBOutlet weak var electricityDataLabel: UILabel!
    @IBOutlet weak var waterDataLabel: UILabel!
    @IBOutlet weak var totalDataLabel: UILabel!
    
    var _userInfoProvider: UserInfoProvider? = nil
    var building: Building? = nil
    
    override func viewDidLoad() {
        // LAMBDA
        let name = building!.name
        let lambda_invoker = AWSLambdaInvoker.default()
        let json_obj: [String: Any] = ["Name": name]
        lambda_invoker.invokeFunction("DavisNRG/buildings", jsonObject: json_obj).continueWith(block: {(task: AWSTask<AnyObject>)-> Any? in
            if (task.error != nil){
                print("Error: \(task.error!)")
            }
            else{
                
            }
        )})
        
    }
//    // MARK: Properties
//    var mealsContentProvider: MealsContentProvider? = nil
//    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var photoImageView: UIImageView!
//    @IBOutlet weak var ratingControl: RatingControl!
//    //    @IBOutlet weak var saveButton: UIBarButtonItem!
//    @IBOutlet weak var ingredientsTextView: UITextView!
//    @IBOutlet weak var recipeTextView: UITextView!
//    @IBOutlet weak var averageRatingLabel: UILabel!
//
//    var dismissKeyboardTapGesture: UITapGestureRecognizer?
//    //    var meal: Meal? //change
//
//    var autoSaveTimer: Timer!
//    static var mealId: String?
//    var meals: [NSManagedObject] = []
//    var filePath: String = "empty"
//    var s3Key: String = "empty"
//    var is_presenting_picker = false
//    var averageRating: Int?
//    var initialRating: Int?
//    var ratersList = [String: String]()
//
//    override func viewDidLoad() {
//    super.viewDidLoad()
//
//    print("meal view controller did load")
//    //        print("info on myMeal: \(String(myMeal?.value(forKey: "name") as! String))")
//    view.isUserInteractionEnabled = true
//
//    mealsContentProvider = MealsContentProvider()
//
//    //        if MealViewController.mealId != nil {
//    //            let queryExpression = AWSDynamoDBQueryExpression()
//    //            queryExpression.indexName = "getMeal"
//    //            queryExpression.keyConditionExpression = "mealId = :mealId"
//    //            queryExpression.expressionAttributeValues = [
//    //                ":mealId": MealViewController.mealId
//    //            ]
//    //
//    //            let object_mapper = AWSDynamoDBObjectMapper.default()
//    //            object_mapper.query(Meals.self, expression: queryExpression){ (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
//    //                print("Querying")
//    //                if error != nil {
//    //                    print("DynamoDB query request failed. Error \(String(describing: error))")
//    //                }
//    //                if output != nil{
//    //                    print("num of meals with this mealId: \(output!.items.count)")
//    //                    let meal = output!.items[0] as! Meals
//    //                    self.myMeal!.averageRating = meal._averageRating!.floatValue
//    //                    self.myMeal!.numRaters = meal._numRaters!.int32Value
//    //                }
//    //
//    //            }
//    //        }
//    //        else{
//    //            print("Meal id is nil, not querying for meal")
//    //        }
//    configureView()
//
//    initialRating = ratingControl.rating
//
//    autoSaveTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(autoSave), userInfo: nil, repeats: true)
//
//
//    }
//
//    var myMeal: Meal? {
//    didSet{
//    MealViewController.mealId = myMeal?.value(forKey: "mealId") as? String
//    //            configureView() // ?
//    self.filePath = myMeal?.value(forKey: "filePath") as! String
//    self.s3Key = myMeal?.value(forKey: "s3Key") as! String
//    var key: String?
//    var value: String?
//    for rater in myMeal!.rater!.allObjects as! [Rater]{
//    key = rater.userId
//    value = rater.rating
//    self.ratersList[key!] = value
//    }
//    }
//    }
//
//    func configureView(){
//    //        photoImageView.image = UIImage(named: "defaultPhoto")
//    if let meal_name = myMeal?.value(forKey: "name") as? String {
//    nameTextField?.text = meal_name
//    }
//    if let meal_rating = myMeal?.value(forKey: "rating") as? Int {
//    print("meal_rating: \(String(meal_rating))")
//    ratingControl.rating = meal_rating
//    }
//    if let meal_recipe = myMeal?.value(forKey: "recipe") as? String {
//    recipeTextView?.text = meal_recipe
//    }
//    if let meal_ingredients = myMeal?.value(forKey: "ingredients") as? String {
//    ingredientsTextView?.text = meal_ingredients
//    }
//    if let meal_photo_path = myMeal?.value(forKey: "filePath") as? String{
//    let absFilePath = MealTableViewController.absDocURL!.appendingPathComponent(meal_photo_path).path
//    if !absFilePath.isEmpty && FileManager.default.fileExists(atPath: absFilePath){
//    if let photo = UIImage(contentsOfFile: absFilePath){
//    self.photoImageView?.image = photo
//    }
//    }
//    }
//    if let meal_averageRating = myMeal?.value(forKey: "averageRating") as? Float{
//    averageRatingLabel.text = "\(String(meal_averageRating)) carrots"
//    }
//    }
//
//    @objc func autoSave(){
//    if (MealViewController.mealId == nil){
//    // first save
//    let id = mealsContentProvider?.insert(mealName: "new meal", rating: 0, averageRating: 0, numRaters: 0, ingredients: "ingredients", recipe: "recipe", filePath: "empty", s3Key: "empty")
//    mealsContentProvider?.insertMealDDB(mealId: id!, mealName: "new meal", rating: 0, averageRating: 0, numRaters: 0, ingredients: ingredientsTextView.text!, recipe: recipeTextView.text!, filePath: "empty", s3Key: "empty", ratersList: self.ratersList)
//    MealViewController.mealId = id
//    }
//    else{
//    // update meal
//    let meal_id = MealViewController.mealId
//    var meal_name = self.nameTextField.text!
//    if meal_name.isEmpty{
//    meal_name = "new meal"
//    }
//    let meal_rating = self.ratingControl.rating
//    let meal_ingredients = self.ingredientsTextView.text
//    let meal_recipe = self.recipeTextView.text
//    let meal_photo_path = self.filePath
//
//    let meal_avrgRating: Float?
//    let meal_numRaters: Int?
//    let meal_ratersList = self.ratersList
//
//    // don't officialize averageRatings or numRaters until final update
//    // if myMeals was set/ we came from table view cell
//    if let meal = myMeal{
//    let numRaters = meal.value(forKey: "numRaters") as? Int
//    let avrgRating = meal.value(forKey: "averageRating") as? Float
//    //                let ratersList = meal.value(forKey: "ratersList") as? [String: String]
//
//    meal_avrgRating = avrgRating
//    meal_numRaters = numRaters
//    }
//    else{
//    //  myMeal not set yet because we came from add button
//    // set values to zero for now
//    meal_avrgRating = 0
//    meal_numRaters = 0
//    }
//
//    mealsContentProvider?.update(mealId: meal_id!, mealName: meal_name, rating: meal_rating, averageRating: meal_avrgRating!, numRaters: meal_numRaters!,ingredients: meal_ingredients!, recipe: meal_recipe!, filePath: meal_photo_path, s3Key: s3Key, ratersList: meal_ratersList)
//
//    let userId = AWSIdentityManager.default().identityId
//
//    mealsContentProvider?.updateMealDDB(userId: userId!, mealId: meal_id!, mealName: meal_name, rating: meal_rating, averageRating: meal_avrgRating!, numRaters: meal_numRaters!, ingredients: meal_ingredients!, recipe: meal_recipe!, filePath: meal_photo_path, s3Key: s3Key, ratersList: meal_ratersList)
//    }
//    }
//
//    override func viewDidAppear(_ animated: Bool){
//    super.viewDidAppear(animated)
//    NotificationCenter.default.addObserver(self, selector: #selector(MealViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//    NotificationCenter.default.addObserver(self, selector: #selector(MealViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//    print("View about to disappear")
//    NotificationCenter.default.removeObserver(self)
//    super.viewWillDisappear(animated)
//    if !is_presenting_picker{
//    if autoSaveTimer != nil{
//    autoSaveTimer.invalidate()
//    }
//
//    let mealId = MealViewController.mealId
//
//    if mealId == nil {
//    print("no meal id")
//    }
//    else { // update the meal one last time, update average rating here
//
//    let meal_id = MealViewController.mealId
//    var meal_name = self.nameTextField.text!
//    if meal_name.isEmpty{
//    meal_name = "new meal"
//    }
//    let meal_rating = self.ratingControl.rating
//    let meal_ingredients = self.ingredientsTextView.text
//    let meal_recipe = self.recipeTextView.text
//    let meal_photo_path = self.filePath
//    let meal_origNumRaters: Int?
//    let meal_originalAverageRating: Float?
//    var meal_ratersList = self.ratersList
//
//    if let meal = myMeal{
//    let origNumRaters = meal.value(forKey: "numRaters") as? Int
//    let originalAverageRating = meal.value(forKey: "averageRating") as? Float
//    //                    let origRatersList = meal.value(forKey: "ratersList") as? [String:String]
//
//    meal_origNumRaters = origNumRaters
//    meal_originalAverageRating = originalAverageRating
//    }
//    else{
//    meal_origNumRaters = 0
//    meal_originalAverageRating = 0
//    }
//
//    let meal_newNumRaters: Int?
//    let meal_averageRating: Float?
//    let userId = AWSIdentityManager.default().identityId
//    if initialRating == 0{
//    if meal_rating != 0{
//    // rating changes, numRaters changes, ratersList changes
//    meal_newNumRaters = meal_origNumRaters! + 1
//    meal_averageRating = ((meal_originalAverageRating! * Float(meal_origNumRaters!)) + Float(meal_rating)) / Float(meal_newNumRaters!)
//
//    meal_ratersList[userId!] = String(meal_rating)
//    }
//    else{
//    // rating stays the same, numRaters stays the same, ratersList stays the same
//    meal_newNumRaters = meal_origNumRaters!
//    meal_averageRating = meal_originalAverageRating!
//    }
//    }
//    else{
//    // note: meal_rating will never be 0 if initialRating is not 0 (rating can't change back to 0)
//    // execute this block if initialRating != 0 (&& meal_rating != 0)
//    // rating changes, numRaters stays the same
//    meal_newNumRaters = meal_origNumRaters!
//    // subtract old rating and add new rating
//    meal_averageRating = (meal_originalAverageRating! - Float(initialRating!) + Float(meal_rating)) / Float(meal_newNumRaters!)
//    }
//
//    mealsContentProvider?.update(mealId: meal_id!, mealName: meal_name, rating: meal_rating, averageRating: meal_averageRating!, numRaters: meal_newNumRaters!, ingredients: meal_ingredients!, recipe: meal_recipe!, filePath: meal_photo_path, s3Key: s3Key, ratersList: meal_ratersList)
//
//    mealsContentProvider?.updateMealDDB(userId: userId!, mealId: meal_id!, mealName: meal_name, rating: meal_rating, averageRating: meal_averageRating!, numRaters: meal_newNumRaters!, ingredients: meal_ingredients!, recipe: meal_recipe!, filePath: meal_photo_path, s3Key: s3Key, ratersList: meal_ratersList) // ?
//    }
//    }
//    }
//
//    func calculateAverageRating()->Int{
//
//    return 0
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//    if !is_presenting_picker{
//    MealViewController.mealId = nil
//    }
//    return
//    }
//
//    @objc func keyboardWillShow(notification: NSNotification){
//    if dismissKeyboardTapGesture == nil{
//    dismissKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(MealViewController.dismissKeyboard))
//    self.view.addGestureRecognizer(dismissKeyboardTapGesture!)
//    }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification){
//    if dismissKeyboardTapGesture != nil{
//    self.view.removeGestureRecognizer(dismissKeyboardTapGesture!)
//    dismissKeyboardTapGesture = nil
//    }
//    }
//
//    @objc func dismissKeyboard(sender: AnyObject){
//    //        self.view.endEditing(true)
//    ingredientsTextView.resignFirstResponder()
//    recipeTextView.resignFirstResponder()
//    }
//
//    //MARK: UITextView Methods
//
//    // UITextView Delegate Methods
//    func textViewDidBeginEditing(_ textView: UITextView) {
//    textView.backgroundColor = UIColor.lightGray
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//    textView.backgroundColor = UIColor.white
//    }
//
//    //MARK: UITextFieldDelegate
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    textField.resignFirstResponder()
//    return true
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//    //        updateSaveButtonState()
//    navigationItem.title = textField.text
//    }
//    //MARK: UIImagePickerControllerDelegate
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
//    is_presenting_picker = false
//    picker.dismiss(animated: true, completion: nil)
//
//    }
//    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]){
//
//    print("mealId: \(String(describing: MealViewController.mealId))")
//    let fileManager = FileManager.default
//    let documentPath = MealTableViewController.absDocURL!.path
//    let selectedImageTag = NSUUID().uuidString
//    let relFilePath = "\(String(selectedImageTag)).png"
//    let absFileURL = MealTableViewController.absDocURL!.appendingPathComponent(relFilePath)
//    let absFilePath = MealTableViewController.absDocURL!.appendingPathComponent(relFilePath).path
//    guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
//    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//    }
//
//    do{ // change?
//    let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
//    print("Accessed files")
//    for file in files {
//    if "\(documentPath)/\(file)" == absFilePath {
//    print("Removed file if it already exists.")
//    try fileManager.removeItem(atPath: absFilePath)
//    }
//    }
//    }
//    catch{
//    print("Could not add image from document directory: \(error)")
//    }
//
//    do{
//    if let pngImageData = UIImagePNGRepresentation(selectedImage) {
//    try pngImageData.write(to: absFileURL, options: .atomic)
//    print("Wrote image to file path")
//    }
//    }
//    catch{
//    print("Couldn't write image")
//    }
//
//    let uploadRequest = AWSS3TransferManagerUploadRequest()
//    print("Created request")
//    uploadRequest!.bucket = "mealsapp-userfiles-mobilehub-1459387644/public"
//    print("Set bucket")
//    let S3key = NSUUID().uuidString
//    uploadRequest!.key = S3key
//    print("Set key")
//    uploadRequest!.body = absFileURL
//
//    myMeal?.s3Key = S3key
//    self.s3Key = S3key
//
//    let transferManager = AWSS3TransferManager.default()
//    print("Made transfer manager")
//
//    transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: {(task: AWSTask<AnyObject>)-> Any? in
//    if let error = task.error as NSError? {
//    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
//    switch code{
//    case .cancelled, .paused:
//    break
//    default:
//    print("Error uploading: \(String(describing: uploadRequest!.key))\nError: \(error)")
//    }
//    }
//    else{
//    print("Error uploading: \(String(describing: uploadRequest!.key))\nError: \(error)")
//    }
//    return nil
//    }
//    //            let uploadOutput = task.result
//    print("Upload complete for: \(uploadRequest!.key)")
//    return nil
//    })
//
//    self.filePath = relFilePath
//    photoImageView.image = selectedImage
//    print("Dismissing image picker")
//    is_presenting_picker = false
//    picker.dismiss(animated: true, completion: nil)
//    }
//
//
//    //MARK: Actions
//
//    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
//        self.nameTextField.resignFirstResponder()
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.delegate = self
//        print("mealId before picker: \(String(describing: MealViewController.mealId))")
//        is_presenting_picker = true
//        present(imagePickerController, animated: true, completion: nil)
//    }
//
//    func createManager() -> AWSS3TransferManager{
//        return AWSS3TransferManager.default()
//    }
    
}
