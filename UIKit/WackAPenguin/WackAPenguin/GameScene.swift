//
//  GameScene.swift
//  WackAPenguin
//
//  Created by Egor Chernakov on 31.03.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var whackSlots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var popupTime = 0.85
    var rounds = 0
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.fontSize = 48
        gameScore.text = "Score: 0"
        gameScore.horizontalAlignmentMode = .left
        addChild(gameScore)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + i*170, y: 410)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + i*170, y: 320)) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + i*170, y: 230)) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + i*170, y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackedHole = node.parent?.parent as? WhackSlot else { continue }
            if !whackedHole.isVisible { continue }
            if whackedHole.isHit { continue }
            whackedHole.hit()
            
            if node.name == "charEnemy" {
                node.xScale = 0.75
                node.yScale = 0.75
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "charFriend" {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            }
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        whackSlots.append(slot)
        addChild(slot)
    }
    
    func showEnemy() {
        popupTime *= 0.991
        rounds += 1
        
        if rounds >= 30 {
            for hole in whackSlots { hole.hide() }
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 364)
            gameOver.zPosition = 1
            addChild(gameOver)
            return
        }
        
        whackSlots.shuffle()
        whackSlots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { whackSlots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 6 { whackSlots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { whackSlots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { whackSlots[4].show(hideTime: popupTime) }
        
        let lowerBound = popupTime / 2.0
        let upperBound = popupTime * 2
        let delta = Double.random(in: lowerBound...upperBound)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delta) { [weak self] in
            self?.showEnemy()
        }
    }
}
