//
//  Move.swift
//  FourInARow
//
//  Created by Egor Chernakov on 04.05.2021.
//

import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
