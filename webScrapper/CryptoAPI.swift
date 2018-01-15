//
//  CryptoAPI.swift
//  webScrapper
//
//  Created by ryseek on 24.09.17.
//  Copyright © 2017 ryseek. All rights reserved.
//

import Foundation
import Alamofire

class Currency {
    var shortName : String
    var fullName : String
    var altcoin : Bool
    
    init(shortName : String, fullName : String, altcoin : Bool){
        self.shortName = shortName
        self.fullName = fullName
        self.altcoin = altcoin
    }
}
class Country {
    var code : String
    
    init(code : String){
        self.code = code
    }
}

class Agent {
    
}

class Ticker {
    var currencyName : String
    var avg1h : Float?
    var avg6h : Float?
    var avg12h : Float?
    var avg24h : Float?
    var volume_btc : Float?
    var time : String
    
    enum Average {
        case lastHours
        case halfDay
        case day
    }
    
    
    init(currencyName : String ,avg1h : Float? ,avg6h : Float? ,avg12h : Float?, avg24h : Float? , volume_btc : Float?){
        self.currencyName = currencyName
        self.avg1h = avg1h
        self.avg6h = avg6h
        self.avg12h = avg12h
        self.avg24h = avg24h
        self.volume_btc = volume_btc
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMMM dd"
        self.time = dateFormatter.string(from: Date())
    }
    
    func getDifferenceFor(_ average: Average) -> Float?{
        switch average {
        case .lastHours:
            if (self.avg6h != nil),(self.avg1h != nil) {
                let difference = (self.avg1h! / self.avg6h! - 1) * 100
                return difference
            }
        case .halfDay :
            if (self.avg12h != nil),(self.avg1h != nil) {
                let difference = (self.avg1h! / self.avg12h! - 1) * 100
                return difference
            }
        case .day:
            if (self.avg24h != nil),(self.avg1h != nil) {
                let difference = (self.avg1h! / self.avg24h! - 1) * 100
                return difference
            }
        }
        return nil
    }
}

class LocalBitcoins {
    private var mainUrl = "https://localbitcoins.net/"
    var currencies : [Currency] = []
    var countries : [Country] = []
    var tickers : [Ticker] = []
    init(){
    }
    
    func loadCountries(completionHandler:@escaping (Bool) -> ()) {
        let url = mainUrl + "api/countrycodes/"
        Alamofire.request(url).responseString { response in
            print("\(response.result.isSuccess)")
            if let raw = response.result.value {
                self.countries = []
                
                let coRaw = convertSwiftyJSON(text: raw)["data"]["cc_list"]
                for country in coRaw {
                    //print(country.1.stringValue)
                    self.countries.append(Country.init(code: country.1.stringValue))
                }
                completionHandler(true)
            }
        }
        
    }
    
    func loadCurrencies(completionHandler:@escaping (Bool) -> ()){
        
        let url = mainUrl + "api/currencies/"
        Alamofire.request(url).responseString { response in
            print("\(response.result.isSuccess)")
            if let raw = response.result.value {
                self.currencies = []
                
                let curRaw = convertSwiftyJSON(text: raw)["data"]["currencies"]
                for currency in curRaw {
                    
                    //print(currency)
                    let newCurrency = Currency.init(shortName: currency.0, fullName: currency.1["name"].stringValue, altcoin: currency.1["altcoin"].boolValue)
                    self.currencies.append(newCurrency)
                    
                }
                completionHandler(true)
            }
        }
    }
    
    func loadAverageTicker(completionHandler:@escaping (Bool) -> ()){
        
        let url = mainUrl + "bitcoinaverage/ticker-all-currencies/"
        
        Alamofire.request(url).responseString { response in
            print("\(response.result.isSuccess)")
            if let raw = response.result.value {
                self.tickers = []
                let tickerJson = convertSwiftyJSON(text: raw)
                
                for ticker in tickerJson {
                    let newTicker = Ticker.init(currencyName: ticker.0 ,
                                                avg1h: ticker.1["avg_1h"].floatValue,
                                                avg6h: ticker.1["avg_6h"].floatValue,
                                                avg12h: ticker.1["avg_12h"].floatValue,
                                                avg24h: ticker.1["avg_24h"].floatValue,
                                                volume_btc: ticker.1["volume_btc"].floatValue)
                    self.tickers.append(newTicker)
                }
                
                completionHandler(true)
            }
        }
    }
    
    func getTickerForCurrency(currncyName : String) -> Ticker?{
        for ticker in tickers {
            if ticker.currencyName == currncyName{
                return ticker
            }
        }
        return nil
    }
}
