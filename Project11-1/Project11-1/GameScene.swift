//
//  GameScene.swift
//  Project11-1
//
//  Created by 박다미 on 2023/03/30.
//

/*
 우리가 사용하고 있는 그림에는 "ballRed"가 아닌 다른 공 그림이 있습니다. 화면을 탭할 때마다 임의의 공 색상을 사용하도록 코드를 작성해 보세요.
 현재 사용자는 아무 곳이나 탭하여 볼을 생성할 수 있으므로 게임이 너무 쉬워집니다.
 새 공의 Y 값을 강제로 적용하여 화면 상단에 가깝게 하십시오.
 플레이어에게 최대 5개의 볼을 제공한 다음 공을 맞으면 장애물 상자를 제거하십시오. 단 5개의 공으로 모든 핀을 없앨 수 있을까요? 녹색 슬롯에 착지하면 추가 공을 얻을 수 있습니다.
 */
import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    let ballColors = ["Blue", "Cyan", "Green", "Grey", "Purple", "Red", "Yellow"]
    
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var editingMode: Bool = false{
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384) //크기
        background.blendMode = .replace //
        background.zPosition = -1 //모든것 뒤에
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)//화면에서 나가지 않게
        physicsWorld.contactDelegate = self
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        addChild(background)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch  = touches.first else {return} //첫번째 터치(동시에 여러 손가락으로 터치방지)
        let location = touch.location(in: self) //터치한 곳의 위치 알기
        let objects = nodes(at: location)
        if objects.contains(editLabel){
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1),green: CGFloat.random(in: 0...1),blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
                
            }else {
                
                
                
                let ball = SKSpriteNode(imageNamed: "ballRed")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4 //튕김정도
                ball.physicsBody!.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.name = "ball"
                ball.position = location
                addChild(ball)
            }
        }
        
    }
    func makeBouncer(at position: CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood{
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinFoever = SKAction.repeatForever(spin)
        slotGlow.run(spinFoever)
    }
    func destroy(ball: SKNode){
        //불타는 효과
        if let fireParicles = SKEmitterNode(fileNamed: "FireParticles"){
            fireParicles.position = ball.position
            addChild(fireParicles)
        }
        ball.removeFromParent()
    }
    
    func collisionBetween(ball: SKNode, object: SKNode){
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball"{
            collisionBetween(ball: nodeA, object: nodeB)
            
        }else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    
}

