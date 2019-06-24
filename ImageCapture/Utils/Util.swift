//
//  Util.swift
//  ImageCapture
//
//  Created by Challa Karthik on 23/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import Foundation
import UIKit

// Util Variables

var imageCaptureModel = ImageCaptureModel()

var items: [String: [String]] =  [
    "Fruits" : ["Apple", "Orange", "Banana", "Unknown"],
    "Vegetables" : ["Tomato", "Brinjal", "Capsicum", "Unknown"],
    "Leaves" : ["Ferns", "Conifer", "Lycophytes", "Unknown"],
    "Unknown" : ["Unknown"] ]

let dbFileName = "CapturedImageData.sqlite"
var pathToDocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let pathToSQLDB = pathToDocumentDirectory.appendingPathComponent(dbFileName).relativePath
var db: SQLiteDatabase? = nil

let baseCellbackgroundColor = UIColor(red: 221/255, green: 228/255, blue: 234/255, alpha: 1)
let orangeBackgroundColor = UIColor(red: 247/255, green: 147/255, blue: 30/255, alpha: 1)

// Util Methods

func getCurrentGMTDateTime() -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter.string(from: Date())
}

func getCurrentGMTDateTimeMillis(date: String) -> Double {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return (formatter.date(from: date)?.timeIntervalSince1970)!.rounded()
}
