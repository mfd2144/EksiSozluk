//
//  AgendaOptions.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 12.04.2021.
//

import UIKit

struct AgendaSettings:Codable {
    
    var sportOn:Bool
    var relationOn:Bool
    var entertainmentOn:Bool
    var politicalOn:Bool
    
    init(sportOn:Bool=true,iliskiOn:Bool=true,yetiskinOn:Bool=false,siyasiOn:Bool=true) {
        self.sportOn = sportOn
        self.relationOn = iliskiOn
        self.entertainmentOn = yetiskinOn
        self.politicalOn = siyasiOn
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
        dic["sport"] = model.sportOn
        dic["relation"] = model.relationOn
        dic["entertainment"] = model.entertainmentOn
        dic["political"] = model.politicalOn
        return dic
    }
    
    
    
    static func saveData(_ settingsArray:[String:Bool]){
        var settings = self.init()

        for (keys,values) in settingsArray{
            switch keys {
            case "sport": settings.sportOn = values
            case "relation": settings.relationOn = values
            case "entertainment": settings.entertainmentOn = values
            case "political":settings.politicalOn = values
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

