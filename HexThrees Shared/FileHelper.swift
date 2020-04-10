//
//  FileHelper.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 05.11.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol IFileHelper {
	static func saveFileUrl() -> URL?
	static func loadSave() -> SavedGame?
}

class FileHelper: IFileHelper {
	private static let SaveGameFileName = "SavedGame.json"
	
	static func saveFileUrl() -> URL? {
		guard let documentDirectoryUrl = FileManager.default.urls(
			for: .documentDirectory,
			in: .userDomainMask).first else { return nil }
		
		return documentDirectoryUrl.appendingPathComponent(SaveGameFileName)
	}
	
	static func loadSave() -> SavedGame? {
		if !saveFileExist() {
			return nil
		}
		
		guard let jsonString = loadJsonFromFile() else { return nil }
		guard let gameSave = decodeJsonToGameState(jsonString) else { return nil }
		
		return gameSave
	}
	
	private static func saveFileExist() -> Bool {
		guard let fileUrl = saveFileUrl() else {
			return false
		}
		return FileManager.default.fileExists(atPath: fileUrl.path)
	}
	
	private static func decodeJsonToGameState(_ json: String) -> SavedGame? {
		do {
			let savedGame = try JSONDecoder().decode(SavedGame.self, from: json.data(using: .utf8)!)
			return savedGame
		} catch { print(error) }
		return nil
	}
	
	private static func loadJsonFromFile() -> String? {
		guard let fileUrl = FileHelper.saveFileUrl() else { return nil }
		do {
			return try String(contentsOf: fileUrl, encoding: .utf8)
		} catch {
			print(error)
		}
		return nil
	}
}
