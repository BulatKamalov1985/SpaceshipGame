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
    
    // MARK: - Properties
    
    // Категории для определения типов объектов
    let playerCatefory: UInt32 = 0x1
    let enemyCatefory: UInt32 = 0x10
    
    // Свойства класса для управления различными элементами игры
    private var starfield = SKEmitterNode()
    private var player = SKSpriteNode()
    private var playerFire = SKSpriteNode()
    private var enemy = SKSpriteNode()
    private var shotCounterLabel = SKLabelNode()
    private var shotCount = 0
    private var fireTimer: Timer?
    private var enemyTimer: Timer?
    private var isCollisionOccurred = false
    
    // MARK: - Scene Lifecycle
    
    // Метод вызывается, когда сцена была добавлена к представлению
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        setupScene()
        startTimers()
    }
    
    // MARK: - Setup
    
    // Методы для инициализации и создания различных элементов сцены
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
    
    // Метод для сброса состояния игрока после столкновения
    private func resetPlayer() {
        // Удалите старого игрока, если он уже существует
        player.removeFromParent()
        
        // Пересоздайте игрока
        createPlayer(playerType: 1)
        
        // Сбросьте флаг isCollisionOccurred, чтобы игрок мог стрелять снова
        isCollisionOccurred = false
    }
    
    // MARK: - Timers
    
    // Методы для управления таймерами, которые регулярно выполняют определенные действия
    private func startTimers() {
        fireTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireAttack), userInfo: nil, repeats: true)
        enemyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeEnemys), userInfo: nil, repeats: true)
    }
    
    private func stopTimers() {
        fireTimer?.invalidate()
        enemyTimer?.invalidate()
    }
    
    // MARK: - Actions
    
    // Методы, которые обрабатывают действия игрока, такие как стрельба и создание врагов
    @objc private func playerFireAttack() {
        
        if isCollisionOccurred {
            return
        }
        
        playerFire = SKSpriteNode(imageNamed: "red_laser")
        playerFire.setScale(0.2)
        playerFire.position = CGPoint(x: player.position.x, y: player.position.y + 10)
        playerFire.zPosition = 3
        playerFire.name = "FIRE"
        addChild(playerFire)
        
        let moveAction = SKAction.moveTo(y: 1400, duration: 0.5)
        let delateAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, delateAction])
        
        // Добавляем в лазер атрибут "isPlayerLaser" для идентификации, что это лазер игрока
        playerFire.userData = ["isPlayerLaser": true]
        
        playerFire.run(combine)
        
        // Увеличиваем количество выстрелов и обновляем метку
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
    
    // Метод для обновления метки счетчика выстрелов
    private func updateShotCounterLabel(count: Int) {
        shotCounterLabel.text = "Shots: \(count)"
    }
    
    // MARK: - Touches
    
    // Метод для обработки перемещения игрока при касаниях на экран
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
    
    // Метод для показа всплывающего окна с сообщением об окончании игры после столкновения
    func showGameOverAlert() {
        let alert = UIAlertController(title: "Игра окончена", message: "Вы столкнулись с врагом!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Вызываем метод resetPlayer после закрытия алерта
            self?.resetPlayer()
            self?.shotCount = 0
        }
        alert.addAction(okAction)
        
        // Получите текущий вид окна и представление сцены
        if let window = view?.window, let viewController = window.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Collision
    
    // Метод для обработки столкновений объектов и показа взрывов
    func didBegin(_ contact: SKPhysicsContact) {
        // Определяем узлы, с которыми произошло столкновение
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        
        // Проверяем наличие узлов, с которыми произошло столкновение
        guard let nodeA = bodyA, let nodeB = bodyB else {
            return
        }
        
        // Проверяем, если player столкнулся с врагом, удаляем оба узла
        if (nodeA.name == "ENEMY" && nodeB == player) || (nodeB.name == "ENEMY" && nodeA == player) {
            player.removeFromParent()
            nodeA.removeFromParent()
            nodeB.removeFromParent()
            isCollisionOccurred = true
            // Показываем UIAlertController после удаления player и врага
            showGameOverAlert()
        }
        
        // Определяем позицию столкновения и показываем взрыв
        let collisionPosition = contact.contactPoint
        showExplosion(at: collisionPosition)
    }
    
    // Метод для показа взрыва на заданной позиции
    func showExplosion(at position: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = position
        explosion.zPosition = 10
        explosion.setScale(0.3)
        addChild(explosion)
        
        // Анимация взрыва
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        explosion.run(sequence)
    }
    
    // MARK: - Deinit
    
    // Метод для остановки таймеров перед освобождением памяти
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
