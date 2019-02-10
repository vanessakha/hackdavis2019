//
//  UserInfoProvider.swift
//  hackdavis2019
//
//  Created by Vanessa on 2/9/19.
//  Copyright © 2019 tut. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import AWSCore
import AWSPinpoint
import AWSDynamoDB
import AWSAuthCore

class UserInfoProvider{
    var _name: String?
    var _phone_number: String?
    var _wants_notifications: Bool?
    var _userId: String? = AWSIdentityManager.default().identityId
    
    func update(name: String, phone_number: String, wants_notifications: Bool){
        self._name = name
        self._phone_number = phone_number
        self._wants_notifications = wants_notifications
    }
    
    func getUserFromDDB(){
        // query and update local data
        print("getting user from db")
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId"
        ]
        queryExpression.expressionAttributeValues =
            [
            ":userId": AWSIdentityManager.default().identityId
        ]
        let object_mapper = AWSDynamoDBObjectMapper.default()
        print("about to perform actual query")
        object_mapper.query(Users.self, expression: queryExpression){ (output: AWSDynamoDBPaginatedOutput?, error: Error?) in // ? how do I access query items?
            print("querying")
            if error != nil {
                print("DynamoDB query request failed. Error: \(String(describing: error))")
            }
            if output != nil{
                print("Found [\(output!.items.count)] users")
                
                if (output!.items.count > 0){
                    var user: Users = output!.items[0] as! Users
                    DispatchQueue.main.async{
                        self.update(name: user._name!, phone_number: user._phoneNumber!, wants_notifications:  user._wantNotifications! as! Bool)
                    }
                }
                else{
                    self.updateUserDDB(userId: self._userId!, name: " ", phone_number: " ", wants_notifications: true)
                    self.getUserFromDDB()
                }
                
               
//                for meal in output!.items {
//                    let meal = meal as? Meals
//                    print("\nMealId: \(meal!._mealId!)\nTitle: \(meal!._name!)\nRating: \(meal!._rating!)\nAverage Rating: \(meal!._averageRating!)\nNum Raters: \(meal!._numRaters!)\nIngredients: \(meal!._ingredients!)\nRecipe: \(meal!._recipe!)\nLowercased name: \(meal!._lowercaseName!)\nratersList: \(meal!._ratersList)")
//
//                    // update core data
//                    DispatchQueue.main.async{
//                        self.update(mealId: meal!._mealId!, mealName: meal!._name!, rating: meal!._rating! as! Int, averageRating: meal!._averageRating!.floatValue, numRaters: meal!._numRaters! as! Int, ingredients: meal!._ingredients!, recipe: meal!._recipe!, filePath: meal!._filePath ?? "", s3Key: meal!._s3Key ?? "", ratersList: meal!._ratersList!)
//                    }
//                }
                print("got meals from DDB")
                
            }
        }
    }

    func updateUserDDB(userId: String, name: String, phone_number: String, wants_notifications: Bool){
        
        let object_mapper = AWSDynamoDBObjectMapper.default()
        
        let user: Users = Users()
        //        meal._userId = AWSIdentityManager.default().identityId
        user._userId = userId
        user._phoneNumber = phone_number
        user._wantNotifications = wants_notifications as! NSNumber
        
        
        if (!name.isEmpty){
            user._name = name
//            meal._lowercaseName = mealName.lowercased()
        }
        else{
            user._name = ""
        }
//            meal._lowercaseName = ""
        //        }
        //        meal._rating = rating as NSNumber
        //        if (!ingredients.isEmpty){
        //            meal._ingredients = ingredients
        //        }
        //        else{
        //            meal._ingredients = ""
        //        }
        //        if (!recipe.isEmpty){
        //            meal._recipe = recipe
        //        }
        //        else{
        //            meal._recipe = ""
        //        }
        
        
//        meal._updateDate = NSDate().timeIntervalSince1970 as NSNumber
        
        let updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes
        object_mapper.save(user, configuration: updateMapperConfig) { (error:Error?) in
            if let error = error {
                print("Amazon DynamoDB Save Error on meal update: \n\(error)")
                return
            }
            print("Existing user updated in DDB.")
        }
    }
    
    
}
