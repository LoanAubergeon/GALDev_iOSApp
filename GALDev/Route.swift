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
    var origin : String!
    var destination : String!
    var driver : Int!
    
    init(){
        
    }
    
    init(id: Int, origin: String, destination: String, driver: Int){
        self.id = id
        self.origin = origin
        self.destination = destination
        self.driver = driver
    }
    
}
