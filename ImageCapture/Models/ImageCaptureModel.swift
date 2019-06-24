//
//  ImageCaptureModel.swift
//  ImageCapture
//
//  Created by Challa Karthik on 23/10/18.
//  Copyright © 2018 ideabytes. All rights reserved.
//

import UIKit

enum RecordStatus {
    case active, inactive, deleted
    
    func simpleDescription() -> String {
        switch self {
        case .active:
            return "Active"
        case .inactive:
            return "Inactive"
        case .deleted:
            return "Deleted"
        }
    }
}

struct ImageCaptureModel {
    
    var category: String?
    var subCategory: String?
    var imageName: String?
    var image: UIImage?
    var rating: Int?
    var comment: String? = ""
    var syncedToCloud: Bool?
    var status = RecordStatus.active.simpleDescription()
    var _created: Date?
    var _updated: Date?
}

struct BaseItemModel {
    var name: String
    var imageName: String
}

struct ItemModel {
    var listOfItems: [BaseItemModel]
}

extension ImageCaptureModel: SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE ImageData(
        sno INTEGER PRIMARY KEY AUTOINCREMENT,
        category CHAR(255),
        subcategory CHAR(255),
        imageName TEXT,
        rating INT,
        comment TEXT,
        lat DOUBLE,
        lon DOUBLE,
        syncedToCloud BOOLEAN,
        status CHAR(255),
        _created DATETIME,
        _updated DATETIME
        );
        """
    }
}
