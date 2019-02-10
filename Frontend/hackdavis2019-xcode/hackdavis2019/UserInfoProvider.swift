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
        object_mapper.query(Users.self, expression: queryExpression){ (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
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
                
                print("got meals from DDB")
                
            }
        }
    }

    func updateUserDDB(userId: String, name: String, phone_number: String, wants_notifications: Bool){
        
        let object_mapper = AWSDynamoDBObjectMapper.default()
        
        let user: Users = Users()
        user._userId = userId
        user._phoneNumber = phone_number
        user._wantNotifications = wants_notifications as! NSNumber
        
        
        if (!name.isEmpty){
            user._name = name
        }
        else{
            user._name = ""
        }
        
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
