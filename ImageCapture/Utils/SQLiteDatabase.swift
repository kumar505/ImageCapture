//
//  SQLiteDatabase.swift
//  ImageCapture
//
//  Created by Challa Karthik on 23/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import SQLite3
import Foundation
import UIKit

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

protocol SQLTable {
    static var createStatement: String { get }
}

class SQLiteDatabase {
    fileprivate let dbPointer: OpaquePointer?
    
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message received from SQLite"
        }
    }
    
    fileprivate init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func open(path: String) throws -> SQLiteDatabase {
        
        var db: OpaquePointer?
        if sqlite3_open(path, &db) == SQLITE_OK {
            return SQLiteDatabase(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db){
                let message = String(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError.OpenDatabase(message: "No error message received from SQLite")
            }
        }
    }
}

extension SQLiteDatabase {
    
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
}

extension SQLiteDatabase {
    
    func createTable(table: SQLTable.Type) throws {
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        defer {
            sqlite3_finalize(createTableStatement)
        }
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("\(table) table created.")
    }
}

extension SQLiteDatabase {
    
    func insertImageData(imageData: ImageCaptureModel) throws {
        let insertQuery = "INSERT INTO ImageData (category, subcategory, imageName, rating, comment, syncedToCloud, lat, lon, status, _created, _updated) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        let insertTableStatement = try prepareStatement(sql: insertQuery)
        defer {
            sqlite3_finalize(insertTableStatement)
        }
        
        let category = imageData.category! as NSString
        let subCategory = imageData.subCategory! as NSString
        let imageName = imageData.imageName! as NSString
        let rating = Int32(imageData.rating!)
        let comment = imageData.comment! as NSString
        let status = imageData.status as NSString
        guard sqlite3_bind_text(insertTableStatement, 1, category.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertTableStatement, 2, subCategory.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertTableStatement, 3, imageName.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(insertTableStatement, 4, rating) == SQLITE_OK &&
            sqlite3_bind_text(insertTableStatement, 5, comment.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(insertTableStatement, 6, 0) == SQLITE_OK &&
            sqlite3_bind_double(insertTableStatement, 7, 0.0) == SQLITE_OK &&
            sqlite3_bind_double(insertTableStatement, 8, 0.0) == SQLITE_OK &&
            sqlite3_bind_text(insertTableStatement, 9, status.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(insertTableStatement, 10, Int32(getCurrentGMTDateTimeMillis(date: getCurrentGMTDateTime()))) == SQLITE_OK &&
            sqlite3_bind_int(insertTableStatement, 11, Int32(getCurrentGMTDateTimeMillis(date: getCurrentGMTDateTime()))) == SQLITE_OK else {
                throw SQLiteError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(insertTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        
        print("Succesfully inserted row")
    }
}

extension SQLiteDatabase {
    
    func selectAll() -> [ImageCaptureModel] {
        
        let selectAllQuery = "SELECT * FROM ImageData ORDER BY _created DESC;"
        var data: [ImageCaptureModel] = []
        guard let queryStatement = try? prepareStatement(sql: selectAllQuery) else {
            return data
        }
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            
            var imageModel = ImageCaptureModel()
            imageModel.category = String(cString: sqlite3_column_text(queryStatement, 1))
            imageModel.subCategory = String(cString: sqlite3_column_text(queryStatement, 2))
            imageModel.imageName = String(cString: sqlite3_column_text(queryStatement, 3))
            let imageURL = pathToDocumentDirectory.appendingPathComponent(imageModel.imageName!).relativePath
            if let imageData: Data = try? Data(contentsOf: URL(fileURLWithPath: imageURL)),
                let image: UIImage = UIImage(data: imageData) {
                imageModel.image = image
            } else {
                imageModel.image = UIImage(named: "cam")
            }
            imageModel.rating = Int(sqlite3_column_int(queryStatement, 4))
            imageModel.comment = String(cString: sqlite3_column_text(queryStatement, 5))            
            data.append(imageModel)
        }
        
        return data
    }
}
