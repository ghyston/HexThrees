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
                blocked: bgCell.isBlocked,
                bonusType: bgCell.bonus?.type,
                bonusTurns: bgCell.bonus?.turnsCount))
        }
            
        return SavedGame(
            cells: cells,
            score: self.gameModel.score,
            fieldSize: FieldSize(rawValue: self.gameModel.fieldWidth)!)
    }
    
    private func saveJsonToFile(_ json: String)
    {
        
        guard let fileUrl = FileHelper.saveFileUrl() else { return }
        
        do {
            try json.write(to: fileUrl, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}
