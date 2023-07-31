//
//  ContentView.swift
//  SpaceshipGame
//
//  Created by Bulat Kamalov on 28.07.2023.
//

import SwiftUI
import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let playerCatefory: UInt32 = 0x1
    let enemyCatefory: UInt32 = 0x10
    
    // MARK: - Properties
    private var starfield = SKEmitterNode()
    private var player = SKSpriteNode()
    private var playerFire = SKSpriteNode()
    private var enemy = SKSpriteNode()
    private var shotCounterLabel = SKLabelNode()
    private var shotCount = 0
    private var fireTimer: Timer?
    private var enemyTimer: Timer?
    
    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        setupScene()
        startTimers()
    }
    
    // MARK: - Setup
    private func setupScene() {
        scene?.size = CGSize(width: 750, height: 1335)
        createStarfield()
        createPlayer(playerType: 1)
        createCountLabel()
    }
    
    private func createStarfield() {
        starfield = SKEmitterNode(fileNamed: "Starfield") ?? SKEmitterNode()
        starfield.position = CGPoint(x: size.width / 2, y: size.height / 2)
        starfield.zPosition = -1
        addChild(starfield)
    }
    
    private func createPlayer(playerType: Int) {
        var shipName = ""
        switch playerType {
        case 1:
            shipName = "ship"
        case 2:
            shipName = "ship1"
        default:
            shipName = "ship3"
        }
        player = SKSpriteNode(imageNamed: shipName)
        player.position = CGPoint(x: size.width / 2, y: 120)
        player.setScale(2)
        player.zPosition = 19
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = playerCatefory
        player.physicsBody?.contactTestBitMask = enemyCatefory
        player.physicsBody?.collisionBitMask = 0
        
        addChild(player)
    }
    
    private func createCountLabel() {
        shotCounterLabel = SKLabelNode(text: "Shots: 0")
        shotCounterLabel.fontName = "Helvetica-Bold"
        shotCounterLabel.fontSize = 30
        shotCounterLabel.fontColor = .white
        shotCounterLabel.position = CGPoint(x: size.width - 100, y: size.height - 100)
        shotCounterLabel.zPosition = 10
        addChild(shotCounterLabel)
        
        let borderRect = CGRect(x: shotCounterLabel.frame.origin.x - 30,
                                y: shotCounterLabel.frame.origin.y - 5,
                                width: shotCounterLabel.frame.size.width + 60,
                                height: shotCounterLabel.frame.size.height + 10)
        
        let border = SKShapeNode(rect: borderRect, cornerRadius: 10)
        border.strokeColor = SKColor.white
        border.lineWidth = 2
        border.zPosition = 9 // Make sure the border appears behind the label
        addChild(border)
    }
    
    // MARK: - Timers
    private func startTimers() {
        fireTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireAttack), userInfo: nil, repeats: true)
        enemyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeEnemys), userInfo: nil, repeats: true)
    }
    
    private func stopTimers() {
        fireTimer?.invalidate()
        enemyTimer?.invalidate()
    }
    
    // MARK: - Actions
    @objc private func playerFireAttack() {
        playerFire = SKSpriteNode(imageNamed: "red_laser")
        playerFire.setScale(0.2)
        playerFire.position = CGPoint(x: player.position.x, y: player.position.y + 10)
        playerFire.zPosition = 3
        addChild(playerFire)
        
        let moveAction = SKAction.moveTo(y: 1400, duration: 0.5)
        let delateAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, delateAction])
        playerFire.run(combine)
        
        // Increment shot count and update the label
        shotCount += 1
        updateShotCounterLabel(count: shotCount)
    }
    
    @objc private func makeEnemys() {
        let randomNumber = GKRandomDistribution(lowestValue: 50, highestValue: 700)
        enemy = SKSpriteNode(imageNamed: "ship4")
        enemy.setScale(0.3)
        enemy.position = CGPoint(x: randomNumber.nextInt(), y: 1400)
        enemy.zPosition = 5
        enemy.name = "ENEMY"
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = enemyCatefory
        enemy.physicsBody?.contactTestBitMask = playerCatefory
        enemy.physicsBody?.collisionBitMask = 0
        addChild(enemy)
        
        let moveAction = SKAction.moveTo(y: -100, duration: 2)
        let delateAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, delateAction])
        enemy.run(combine)
    }
    
    // MARK: - Update Label
    private func updateShotCounterLabel(count: Int) {
        shotCounterLabel.text = "Shots: \(count)"
    }
    
    // MARK: - Touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
    
    // MARK: - Collision
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node?.name
        
    }
    
    // MARK: - Deinit
    deinit {
        stopTimers()
    }
}

struct ContentView: View {
    let scene = GameScene()
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
