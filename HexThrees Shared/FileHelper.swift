//
//  FileHelper.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 05.11.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class FileHelper {
    
    private static let SaveGameFileName = "SavedGame.json"
    
    class func SaveFileUrl() -> URL? {
        
        guard let documentDirectoryUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        return documentDirectoryUrl.appendingPathComponent(SaveGameFileName)
    }
    
    class func SaveFileExist() -> Bool {
        
        guard let fileUrl = SaveFileUrl() else {
            return false
        }
        return FileManager.default.fileExists(atPath: fileUrl.path)
    }
    
    
}
