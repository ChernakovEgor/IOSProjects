//
//  GameScene.swift
//  SwiftyNinja
//
//  Created by Egor Chernakov on 11.04.2021.
//

import AVFoundation
import SpriteKit
import GameplayKit

enum ForceBomb {
    case never, always, random
}

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    var activeSlicePoints = [CGPoint]()
    
    var isSwooshPlaying = false
    var activeEnemies = [SKSpriteNode]()
    var bombSoundEffect: AVAudioPlayer?
    
    var popupTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true
    
    var isGameEnded = false
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        sequence = [.oneNoBomb, .oneNoBomb, .one, .twoWithBomb, .two, .three, .chain]
        
        for _ in 0...1000 {
            if let next = SequenceType.allCases.randomElement() {
                sequence.append(next)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in self?.tossEnemies() }
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 44
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: \(score)"
        
        addChild(scoreLabel)
    }
    
    func createLives() {
        for i in 0 ..< 3 {
            let life = SKSpriteNode(imageNamed: "sliceLife")
            life.position = CGPoint(x: 834 + i * 70, y: 720)
            addChild(life)
            livesImages.append(life)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0.0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        activeSliceFG.strokeColor = .white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceFG)
        addChild(activeSliceBG)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        activeSlicePoints.append(position)
        
        redrawActiveSlices()
        
        if !isSwooshPlaying {
            playSwoosh()
        }
        
        let nodesAtPoint = nodes(at: position)
        
        let scale = SKAction.scale(to: 0.001, duration: 0.2)
        let fade = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scale, fade])
        let sequence = SKAction.sequence([group, .removeFromParent()])
        
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name == "enemy" || node.name == "rare" {
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = position
                    addChild(emitter)
                }
                
                score += node.name == "enemy" ? 1 : 5
                
                node.name = ""
                node.physicsBody?.isDynamic = false
                
                node.run(sequence)
                
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                
            } else if node.name == "bomb" {
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                
                bombContainer.run(sequence)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    func endGame(triggeredByBomb: Bool) {
        guard isGameEnded == false else { return }
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
    }
    
    func playSwoosh() {
        isSwooshPlaying = true
        
        let number = Int.random(in: 1...3)
        let fileName = "swoosh\(number).caf"
        
        let sound = SKAction.playSoundFileNamed(fileName, waitForCompletion: true)
        
        run(sound) { [weak self] in
            self?.isSwooshPlaying = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let position = touch.location(in: self )
        
        activeSlicePoints.removeAll(keepingCapacity: true)
        activeSlicePoints.append(position)
        
        redrawActiveSlices()
        
        activeSliceFG.removeAllActions()
        activeSliceBG.removeAllActions()
        
        activeSliceFG.alpha = 1
        activeSliceBG.alpha = 1
    }
    
    func redrawActiveSlices() {
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceFG.path = path.cgPath
        activeSliceBG.path = path.cgPath
    }
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }
        
        if enemyType == 0{
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
            
        } else {
            
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }
        
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }
        
        let randomYVelocity = Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        if Int.random(in: 0...9) == 9 {
            enemy.name = "rare"
            enemy.colorBlendFactor = 1
            enemy.color = .orange
            enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 60, dy: randomYVelocity * 60)
        }
        
        activeEnemies.append(enemy)
        addChild(enemy)
    }
    
    
    
    func substractLife() {
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    
                    if node.name == "enemy" {
                        substractLife()
                    }
                    
                    node.name = ""
                    node.removeFromParent()
                    activeEnemies.remove(at: index)
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in self?.tossEnemies() }
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    func tossEnemies() {
        guard isGameEnded == false else { return }
        
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let type = sequence[sequencePosition]
        switch type {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        case .one:
            createEnemy()
        case .twoWithBomb:
            createEnemy()
            createEnemy(forceBomb: .always)
        case .two:
            createEnemy()
            createEnemy()
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
        case .chain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 5) { [weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 5 * 2) { [weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 5 * 3) { [weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 5 * 4) { [weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 5 * 5) { [weak self] in self?.createEnemy()}
        case .fastChain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 10) { [weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 10 * 2) { [weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 10 * 3) { [weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 10 * 4) { [weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay / 10 * 5) { [weak self] in self?.createEnemy()}
        }
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
}
