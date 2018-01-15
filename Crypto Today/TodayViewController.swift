//
//  TodayViewController.swift
//  Crypto Today
//
//  Created by ryseek on 16.09.17.
//  Copyright © 2017 ryseek. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire

class TodayViewController: UIViewController, NCWidgetProviding {
    var currencyName = "USD"
    
    
    var bit : LocalBitcoins!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var dif6h: UILabel!
    @IBOutlet weak var dif12h: UILabel!
    @IBOutlet weak var dif24h: UILabel!
    
    @IBOutlet weak var updated: UILabel!
    
    let green = UIColor.init(red: 0, green: 249/255, blue: 0, alpha: 1)
    let red = UIColor.init(red: 255/255, green: 39/255, blue: 0, alpha: 1)
    let accuracyString = "%.2f"
    let cornerRadius = CGFloat(5)
    
    var priceText : String {
        set{
            saveDK(saveData: newValue, saveKey : "priceText")
            self.price.text = newValue
        }
        get{
            return loadDK(loadKey: "priceText")
        }
    }
    
    var updatedText : String {
        set{
            saveDK(saveData: newValue, saveKey : "updatedText")
            self.updated.text = newValue
        }
        get{
            return loadDK(loadKey: "updatedText")
        }
    }
    
    var dif6 : Float {
        set{
            saveDK(saveData: String(newValue), saveKey : "dif6")
            
            
            if newValue > 0 {
                self.dif6h.text = "+ " + String(format: accuracyString,newValue) + " %"
                self.dif6h.backgroundColor = green
            } else if newValue < 0{
                self.dif6h.text = String(format: accuracyString,newValue)
                self.dif6h.backgroundColor = red
            }else {
                // self.dif6h.text = ""
            }
        }
        get{
            if (Float(loadDK(loadKey: "dif6")) != nil){
                return Float(loadDK(loadKey: "dif6"))!
            } else {
                return 0
            }
        }
    }
    
    var dif12 : Float {
        set{
            saveDK(saveData: String(newValue), saveKey : "dif12")
            
            if newValue > 0 {
                self.dif12h.text = "+ " + String(format: accuracyString,newValue) + " %"
                self.dif12h.backgroundColor = green
            } else if newValue < 0{
                self.dif12h.text = String(format: accuracyString,newValue) + " %"
                self.dif12h.backgroundColor = red
            }else {
                //self.dif12h.text = ""
            }
        }
        get{
            if (Float(loadDK(loadKey: "dif12")) != nil){
                return Float(loadDK(loadKey: "dif12"))!
            } else {
                return 0
            }
        }
    }
    
    var dif24 : Float {
        set{
            saveDK(saveData: String(newValue), saveKey : "dif24")
            
            if newValue > 0 {
                self.dif24h.text = "+ " + String(format: accuracyString,newValue) + " %"
                self.dif24h.backgroundColor = green
            } else if newValue < 0{
                self.dif24h.text = String(format: accuracyString,newValue) + " %"
                self.dif24h.backgroundColor = red
            }else {
                //   self.dif24h.text = ""
            }
        }
        get{
            if (Float(loadDK(loadKey: "dif24")) != nil){
                return Float(loadDK(loadKey: "dif24"))!
            } else {
                return 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("_________________")
        
        self.setUp()
        
        self.updateTicker()
        
        // Do any additional setup after loading the view from its nib.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        self.updateTicker()
        completionHandler(NCUpdateResult.newData)
    }
    
    func setUp() {
        self.bit = LocalBitcoins.init()
        
        self.dif6h.clipsToBounds = true
        self.dif12h.clipsToBounds = true
        self.dif24h.clipsToBounds = true
        
        self.dif6h.layer.cornerRadius = cornerRadius
        self.dif12h.layer.cornerRadius = cornerRadius
        self.dif24h.layer.cornerRadius = cornerRadius
    }
    
    
    func updateTicker(){
        self.updateWidget()
        
        self.bit.loadAverageTicker(completionHandler: {success in
            self.updateWidget()
        })
        
    }
    
    func updateWidget(){
        if(self.bit.tickers.count > 0){
            if let ticker = bit.getTickerForCurrency(currncyName: currencyName){
                
                if let avg1h = ticker.avg1h {
                    self.priceText = "1 BTC = " + String(Int(avg1h)) + " " + ticker.currencyName
                    self.updatedText = "Updated: " + ticker.time
                }
                
                if let averageDif = ticker.getDifferenceFor(.lastHours) {
                    self.dif6 = averageDif
                }
                if let averageDif = ticker.getDifferenceFor(.halfDay) {
                    self.dif12 = averageDif
                }
                if let averageDif = ticker.getDifferenceFor(.day) {
                    self.dif24 = averageDif
                }
                
            }
        }else {
            self.priceText = loadDK(loadKey: "priceText")
            self.updatedText = loadDK(loadKey: "updatedText")
            self.dif6 = self.dif6.setAsGet()
            self.dif12 = self.dif12.setAsGet()
            self.dif24 = self.dif24.setAsGet()
        }
    }
    
}
extension Float {
    func setAsGet() -> Float{
        return self
    }
}
