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
        
        let saveCell : (_:BgCell) -> Void = {
            cells.append(SavedGame.SavedCell(
                val: $0.gameCell?.value,
                blocked: $0.isBlocked,
                bonusType: $0.bonus?.type,
                bonusTurns: $0.bonus?.turnsCount))
        }
        
        self.gameModel.field.executeForAll(lambda: saveCell)
		
        return SavedGame(
            cells: cells,
            score: self.gameModel.score,
            fieldSize: FieldSize(rawValue: self.gameModel.field.width)!,
			bonuses: self.gameModel.collectableBonuses
				.filter {$0.value.currentValue > 0 }
				.mapValues { SavedGame.CollectableBonusCodable(currentValue: $0.currentValue, maxValue: $0.maxValue )})
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
