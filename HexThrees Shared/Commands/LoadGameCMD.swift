//
//  LoadGameCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class LoadGameCMD: GameCMD {
    
    override func run() {
        
        guard let jsonString = loadJsonFromFile() else { return }
        guard let gameSave = decodeJsonToGameState(jsonString) else { return }
        
        //@todo: remove assets from final build, make soft loading,
        assert(gameModel.bgHexes.count == gameSave.cells.count, "on load game configs are different")
        
        applySaveToModel(gameSave)
    }
    
    private func applySaveToModel(_ gameSave: SavedGame) {
        
        for i in 0..<gameSave.cells.count {
            
            if gameSave.cells[i].blocked {
                
                gameModel.bgHexes[i].block()
            }
            else if gameSave.cells[i].val != nil {
                
                let newElement = GameCell(
                    model: self.gameModel,
                    val: gameSave.cells[i].val!)
                gameModel.bgHexes[i].addGameCell(cell: newElement)
                newElement.playAppearAnimation()
            }
        }
        gameModel.score = gameSave.score
    }
    
    private func decodeJsonToGameState(_ json : String) -> SavedGame? {
        
        do {
            
            let savedGame = try JSONDecoder().decode(SavedGame.self, from: json.data(using: .utf8)!)
            return savedGame
        } catch { print(error) }
        return nil
    }
    
    //@todo: should it be a class FileManager?
    private func loadJsonFromFile() -> String? {
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("SavedGame.json") //@todo: use constant or config for that
        
        do {
            
            return try String(contentsOf: fileUrl, encoding: .utf8)
        } catch {
            
            print(error)
        }
        return nil
    }
}
