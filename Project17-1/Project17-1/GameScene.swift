//
//  GameScene.swift
//  Project17-1
//
//  Created by 박다미 on 2023/04/20.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player : SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode?
    var newGameLabel: SKLabelNode?
    
    var timerLoop = 0
    var timerInterval: Double = 1
    
    
    var possibleEnemies = ["ball", "hammer","tv"]
    var gameTimer : Timer?
    var isGameOver = false
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10) // starfield가 미리 생성되도록 시뮬레이션이 10초뒤 생성
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1 //객체가 다른 객체와 충돌할 때, 어떤충돌을 처리할지를 설정-> 1로 설정 =>다른 객체에서 categoryBitMask 속성도 1로 설정 player 객체가 충돌이 일어날 때 알림을 받음
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        physicsWorld.gravity = .zero //무중력
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true) //0.35간격으로 createEnemy함수 호출
        
    }
    @objc func createEnemy(){
        //적 의 수가 20 이상이 되면, 게임 타이머의 실행 간격을 0.1초씩 줄여서 적이 더 빠르게 이동
        

        if timerLoop >= 20 { //timerLoop 변수는 게임에서 출현한 적의 수를 저장
            timerLoop = 0
            
            if timerInterval >= 0.2 {
                timerInterval -= 0.1
            }
                
            gameTimer?.invalidate() //현재 실행 중인 타이머를 중지
            gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true) // 새로운 타이머를 생성

        }
        
        guard let enemy = possibleEnemies.randomElement() else{ return}
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    func gameOver(){
        
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()
        isGameOver = true
        gameTimer?.invalidate()
        
            
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel?.position = CGPoint(x: 512, y: 384)
        gameOverLabel?.zPosition = 1
        gameOverLabel?.fontSize = 48
        gameOverLabel?.horizontalAlignmentMode = .center
        gameOverLabel?.text = "GAME OVER"
        addChild(gameOverLabel!)

        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel?.position = CGPoint(x: 512, y: 324)
        newGameLabel?.zPosition = 1
        newGameLabel?.fontSize = 32
        newGameLabel?.horizontalAlignmentMode = .center
        newGameLabel?.text = "New Game"
        newGameLabel?.name = "NewGame"
        addChild(newGameLabel!)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //        let explosion = SKEmitterNode(fileNamed: "explosion")!
        //        explosion.position = player.position
        //        addChild(explosion)
        //
        //        player.removeFromParent()
        //        isGameOver = true
        //        gameTimer?.invalidate()
        gameOver()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        if !isGameOver {
            gameOver()
            return
        }
        
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        for object in objects {
            if object.name == "NewGame" {
                newGame()
            }

        }
    }
    func newGame() {
        guard isGameOver else { return }
        
        score = 0
        timerLoop = 0
        timerInterval = 1
        isGameOver = false
        
        //라벨 없애기
        if let gameOverLabel = gameOverLabel {
            gameOverLabel.removeFromParent()
        }
        if let newGameLabel = newGameLabel {
            newGameLabel.removeFromParent()
        }
        
        // 적들 없애고 초기화
        for node in children {
            if node.name == "Enemy" {
                node.removeFromParent()
            }
        }
        
        player.position = CGPoint(x: 100, y: 384)
        addChild(player)

        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)

    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        var location = touch.location(in: self)
        
        if location.y < 100{
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        player.position = location
    }

    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300{
                node.removeFromParent()
            }
        }
        if !isGameOver {
            score += 1
        }
    }
}
