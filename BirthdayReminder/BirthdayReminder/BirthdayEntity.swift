//
//  BirthdayEntiti.swift
//  BirthdayReminder
//
//  Created by Pavel Shymanski on 4.01.23.
//

import Foundation
import UIKit

struct  BirthdayEntity: Equatable, Codable {
    
    let name : String
    let dateString : Date
    let iconData: Data?
    var newFormatedDate: String?
    // this property return formated Data
    var formatedData: String? {
        get {
            let dateFormater = DateFormatter()
            if newFormatedDate == nil {
                dateFormater.dateFormat = "MMM d , yyyy"
                return dateFormater.string(from: dateString)}
            else{
                dateFormater.dateFormat = newFormatedDate
                return dateFormater.string(from: dateString)
            }
        }
    }
}
    
