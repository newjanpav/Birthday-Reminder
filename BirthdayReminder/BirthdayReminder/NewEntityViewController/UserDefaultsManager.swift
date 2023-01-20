//
//  UserDefaultsManager.swift
//  BirthdayReminder
//
//  Created by Pavel Shymanski on 9.01.23.
//

import Foundation
class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init(){}
    
    enum Key: String {
        case birthdayEntity
    }
    
    // add  complex data
    func save(value:Any?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        
    }
    //remove complex data from UserDefaults
    func value(forKey key: Key) -> Any? {
        UserDefaults.standard.value(forKey: key.rawValue)
    }

    // save data to array
    func saveArray(array: [BirthdayEntity],forKey key: Key ){
        let encoder = JSONEncoder()
        let data = try! encoder.encode(array)
        save(value: data, forKey: key)
    }
    // remove data from array
    func takeAwayArray( forKey key: Key) -> [BirthdayEntity]?{
        let decoder = JSONDecoder()
        let object : Any? = UserDefaultsManager.shared.value(forKey:key)
        guard let data = object as? Data else{return nil}
        let item =  try? decoder.decode([BirthdayEntity].self, from: data)
        return item
        
    }
}






