//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","EGP"]
    let currencySympolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R", "£EG"]
    var finalURL : String?
    var Row : Int?
   

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(runTimecode), userInfo: nil, repeats: true)

       
       
       
    }
    @objc func runTimecode(){
        if finalURL != nil{
            
            getBitcoinPrice(url: finalURL!, Symbol: currencySympolArray[Row!])
        }
    }
    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        Row = row
        finalURL = baseURL + currencyArray[row]
        getBitcoinPrice(url: finalURL!, Symbol: currencySympolArray[row])
    }
    

    // Networking
    func getBitcoinPrice(url : String, Symbol : String)
    {
       
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("got price")
                print(response.result.value!)
                let bitCoibJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinDate(json: bitCoibJSON, symbolDisplay: Symbol)
            }
            else{
                print("Failur!")
                print(response.result.error!)
            }
        }
    }
    
    
    
    //JSON Pasring
    
    func updateBitcoinDate( json : JSON, symbolDisplay : String){
        
            let price = json["ask"].double
        if price != nil {
            bitcoinPriceLabel.text = String("\(price!) \(symbolDisplay)")
        }
        
        else{
             bitcoinPriceLabel.text = "Price Unavilable!"
        }
        
        
    }
//    
//    //MARK: - Networking
//    /***************************************************************/
//
//    func getWeatherData(url: String, parameters: [String : String]) {
//        
//        Alamofire.request(url, method: .get, parameters: parameters)
//            .responseJSON { response in
//                if response.result.isSuccess {
//
//                    print("Sucess! Got the weather data")
//                    let weatherJSON : JSON = JSON(response.result.value!)
//
//                    self.updateWeatherData(json: weatherJSON)
//
//                } else {
//                    print("Error: \(String(describing: response.result.error))")
//                    self.bitcoinPriceLabel.text = "Connection Issues"
//                }
//            }
//
//    }
//
//    
//    
//    
//    
//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
//    func updateWeatherData(json : JSON) {
//        
//        if let tempResult = json["main"]["temp"].double {
//        
//        weatherData.temperature = Int(round(tempResult!) - 273.15)
//        weatherData.city = json["name"].stringValue
//        weatherData.condition = json["weather"][0]["id"].intValue
//        weatherData.weatherIconName =    weatherData.updateWeatherIcon(condition: weatherData.condition)
//        }
//        
//        updateUIWithWeatherData()
//    }
//    




}

