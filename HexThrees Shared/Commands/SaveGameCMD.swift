//
//  SaveGameCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SaveGameCMD : GameCMD {
    
    var cells: [SavedGame.SavedCell]?
    
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
    
    private func saveCell(cell: BgCell) {
        cells?.append(SavedGame.SavedCell(
            val: cell.gameCell?.value,
            blocked: cell.isBlocked,
            bonusType: cell.bonus?.type,
            bonusTurns: cell.bonus?.turnsCount))
    }
    
    private func retrieveSaveFromModel() -> SavedGame {
        self.cells = [SavedGame.SavedCell]()
        self.gameModel.field.executeForAll(lambda: self.saveCell)
        
        return SavedGame(
            cells: self.cells!,
            score: self.gameModel.score,
            fieldSize: FieldSize(rawValue: self.gameModel.field.width)!)
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
