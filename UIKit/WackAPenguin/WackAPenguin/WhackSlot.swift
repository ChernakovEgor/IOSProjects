//
//  WhackSlot.swift
//  WackAPenguin
//
//  Created by Egor Chernakov on 31.03.2021.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let whackHole = SKSpriteNode(imageNamed: "whackHole")
        addChild(whackHole)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)

        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible.toggle()
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5 * hideTime) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        if let smoke = SKEmitterNode(fileNamed: "Smoke.sks") {
            smoke.position = charNode.position
            let addSmoke = SKAction.run {[weak self] in self?.addChild(smoke)}
            let removeSmoke = SKAction.run {[weak smoke] in smoke?.removeFromParent()}
            let delay = SKAction.wait(forDuration: 0.25)
            let smokeDelay = SKAction.wait(forDuration: 1)
            let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
            let notVisible = SKAction.run {[weak self] in self?.isVisible = false
            }
            let sequence = SKAction.sequence([addSmoke, delay, hide, notVisible, smokeDelay, removeSmoke])
            charNode.run(sequence)
        }
    }
}
