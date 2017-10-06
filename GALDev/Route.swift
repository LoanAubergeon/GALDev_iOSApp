//
//  Route.swift
//  GALDev
//
//  Created by Loan Aubergeon on 05/10/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import Foundation

struct Route {
    
    var id : Int!
    var originName : String!
    var destinationName : String!
    var driver : Int!
    var date : String!
    var time : String!
    var recurrence : Bool!
    
    init(){
        
    }
    
    init(id: Int, originName: String, destinationName: String, driver: Int){
        self.id = id
        self.originName = originName
        self.destinationName = destinationName
        self.driver = driver
    }
    
    init(originName: String, destinationName : String, date : String, time : String, recurrence : Bool){
        self.originName = originName
        self.destinationName = destinationName
        self.date = date
        self.time = time
        self.recurrence = recurrence
    }
    
    
}
