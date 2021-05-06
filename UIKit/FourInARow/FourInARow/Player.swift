//
//  Player.swift
//  FourInARow
//
//  Created by Egor Chernakov on 04.05.2021.
//

import GameplayKit
import UIKit

class Player: NSObject, GKGameModelPlayer {
    var chip: ChipColor
    var color: UIColor
    var name: String
    var playerId: Int
    
    var opponent: Player {
        if chip == .red {
            return Player.allPlayers[1]
        } else {
            return Player.allPlayers[0]
        }
    }
    
    static var allPlayers = [Player(chip: .red), Player(chip: .black)]
    
    init(chip: ChipColor) {
        self.chip = chip
        self.playerId = chip.rawValue
        
        if chip == .red {
            name = "Red"
            color = .red
        } else {
            name = "Black"
            color = .black
        }
        
        super.init()
    }
}
