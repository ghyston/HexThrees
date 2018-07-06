//
//  SaveGameCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SaveGameCMD : GameCMD {
    
    override func run() {
        
        guard let jsonString : String = encodeGameStateToJson() else {
            return
        }
        
        saveJsonToFile(jsonString)
    }
    
    private func encodeGameStateToJson() -> String? {
        
        let savedGame = retrieveSaveFromModel()
        
        do {
            
            let jsonData = try JSONEncoder().encode(savedGame)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
            
        } catch { print(error) }
        return nil
    }
    
    private func retrieveSaveFromModel() -> SavedGame {
            
        var cells = [SavedGame.SavedCell]()
        for bgCell in self.gameModel.bgHexes {
                
            cells.append(SavedGame.SavedCell(
                val: bgCell.gameCell?.value,
                blocked: bgCell.isBlocked))
        }
            
        return SavedGame(
            cells: cells,
            score: self.gameModel.score)
    }
    
    //@todo: should it be a class FileManager?
    private func saveJsonToFile(_ json: String) {
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("SavedGame.json") //@todo: use constant or config for that
        
        do {
            try json.write(to: fileUrl, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}
