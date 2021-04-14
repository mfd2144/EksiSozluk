//
//  GundemOptions.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 12.04.2021.
//

import UIKit

struct GundemSettings:Codable {
    
    var sporOn:Bool
    var iliskiOn:Bool
    var yetiskinOn:Bool
    var siyasiOn:Bool
    
  
    
    private static var startingSettingsModel:GundemSettings{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("GundemSettings.plist")
        do{
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: path!)
            let startingSettings = try decoder.decode(GundemSettings.self, from: data)
            return startingSettings
        }catch{
//            if for first time starting
            let defaultSettings = GundemSettings()
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
    
    
    
    init(sporOn:Bool=true,iliskiOn:Bool=true,yetiskinOn:Bool=false,siyasiOn:Bool=true) {
        self.sporOn = sporOn
        self.iliskiOn = iliskiOn
        self.yetiskinOn = yetiskinOn
        self.siyasiOn = siyasiOn
    }
    

    static func fetchStartingSettings() -> Dictionary<String,Bool> {
        var dic = Dictionary<String,Bool>()
        let model = startingSettingsModel
        
        dic["spor"] = model.sporOn
        dic["ilişki"] = model.iliskiOn
        dic["yetişkin"] = model.yetiskinOn
        dic["siyasi"] = model.siyasiOn
        return dic
    }
    
    
    
    static func saveData(_ settingsArray:[String:Bool]){
        var settings = self.init()

        for (keys,values) in settingsArray{
            switch keys {
            case "spor": settings.sporOn = values
            case "ilişki": settings.iliskiOn = values
            case "yetişkin": settings.yetiskinOn = values
            case "siyasi":settings.siyasiOn = values
            default: return
            }
        }
 
        
        let path = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("GundemSettings.plist"))!
        let encoder = PropertyListEncoder()
        
        do {
           let data = try encoder.encode(settings)
            try data.write(to: path)
        } catch {
            print("settings saving error")
        }
        
    }
    
    
}

