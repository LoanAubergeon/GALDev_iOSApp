//
//  CalculationForMapDisplay.swift
//  GALDev
//
//  Created by Loan Aubergeon on 06/10/2017.
//  Copyright © 2017 Loan Aubergeon. All rights reserved.
//

import Foundation

class CalculationForMapDisplay{
    
    var xCenter : Double!
    var yCenter : Double!

    
    var zoom : Int!
    
    
    func zoomCalcul(){
        
    }
    
    func centerCalcul(xLat : Double, yLat : Double, xLong : Double, yLong : Double){
        self.xCenter = abs(xLong - xLat)
        self.yCenter = abs(yLong - yLat)
    }
    
    
}
