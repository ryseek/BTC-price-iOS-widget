//
//  UsefulFunctions.swift
//  webScrapper
//
//  Created by ryseek on 24.09.17.
//  Copyright © 2017 ryseek. All rights reserved.
//

import Foundation

func convertSwiftyJSON(text: String) -> JSON {
    let dataFromString = text.data(using: .utf8, allowLossyConversion: false)
    let json = JSON(dataFromString)
    
    return json
}

func saveDK(saveData:String,saveKey:String)->Void{
    
    let defaults = UserDefaults.standard
    defaults.set(saveData, forKey: saveKey)
}

func loadDK(loadKey: String)->String{
    let defaults = UserDefaults.standard
    if let stringOne = defaults.string(forKey: loadKey) {
        //NSLog(stringOne,"a") // Some String Value
        return stringOne
    }else{
        return "error"
    }
}
