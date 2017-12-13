//
//  Utils.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 21.11.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation

class BackgroundFetchAssist {
    let fetchCitiesWeatherGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    
    static let shared = BackgroundFetchAssist()
    private init(){}
    
    var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "Last Update") as? Date
        }
        set {
            UserDefaults.standard.setValue(Data(), forKey: "Last Update")
        }
    }
}
