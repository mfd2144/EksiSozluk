//
//  AgendaOptions.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 12.04.2021.
//

import UIKit

struct AgendaSettings:Codable {
    
    var sporOn:Bool
    var iliskiOn:Bool
    var yetiskinOn:Bool
    var siyasiOn:Bool
    
    init(sporOn:Bool=true,iliskiOn:Bool=true,yetiskinOn:Bool=false,siyasiOn:Bool=true) {
        self.sporOn = sporOn
        self.iliskiOn = iliskiOn
        self.yetiskinOn = yetiskinOn
        self.siyasiOn = siyasiOn
    }
    
  
    
    private static var startingSettingsModel:AgendaSettings{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("AgendaSettings.plist")
        do{
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: path!)
            let startingSettings = try decoder.decode(AgendaSettings.self, from: data)
            return startingSettings
        }catch{
//            if for first time starting
            let defaultSettings = AgendaSettings()
            let encoder = PropertyListEncoder()
            
            do {
                let data = try encoder.encode(defaultSettings)
                try data.write(to: path!)
            }catch{
                print(error.localizedDescription)
            }
            return defaultSettings
        }
        
    }
    
    static func fetchStartingSettings() -> Dictionary<String,Bool> {
        var dic = Dictionary<String,Bool>()
        let model = startingSettingsModel
        dic["spor"] = model.sporOn
        dic["relation"] = model.iliskiOn
        dic["entertainment"] = model.yetiskinOn
        dic["politicial"] = model.siyasiOn
        return dic
    }
    
    
    
    static func saveData(_ settingsArray:[String:Bool]){
        var settings = self.init()

        for (keys,values) in settingsArray{
            switch keys {
            case "spor": settings.sporOn = values
            case "relation": settings.iliskiOn = values
            case "entertainment": settings.yetiskinOn = values
            case "politicial":settings.siyasiOn = values
            default: return
            }
        }
 
        
        let path = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("AgendaSettings.plist"))!
        let encoder = PropertyListEncoder()
        
        do {
           let data = try encoder.encode(settings)
            try data.write(to: path)
        } catch {
            print("settings saving error")
        }
        
    }
    
    
}

