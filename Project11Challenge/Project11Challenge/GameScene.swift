//
//  GameScene.swift
//  Project11Challenge
//
//  Created by 박다미 on 2023/04/03.
//

/*
 랜덤으로 box가 생길것
 newgame 클릭시 초기화
 공은 5개
 bad로 떨어질때 공개수 깎임
 박스 모두 깨면 승리
 공이 다 사라지면 패
 */
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //공 색깔 랜덤
    var ballColors = ["Blue", "Cyan", "Green", "Grey", "Purple", "Red", "Yellow"]
    //남은공
    var chanceLabel: SKLabelNode!
    var chance = 5 {
        didSet{
            chanceLabel.text = "change: \(chance)"
        }
    }
    var initLabel : SKLabelNode!
    var resultLabel : SKLabelNode!
    
   
    override func didMove(to view: SKView) {
        //background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
       addChild(background)
        //남은 기회 라벨
        chanceLabel = SKLabelNode(fontNamed: "Chalkduster")
        chanceLabel.text = "change: \(chance)"
        chanceLabel.horizontalAlignmentMode = .right
        chanceLabel.position = CGPoint(x: 980, y: 700)
        addChild(chanceLabel)
        
        //초기화 버튼
        initLabel = SKLabelNode(fontNamed: "Chalkduster")
        initLabel.text = "Init Game"
        initLabel.position = CGPoint(x: 150, y: 700)
        addChild(initLabel)
        
        //게임 결과
        resultLabel = SKLabelNode(fontNamed: "Chalkduster")
        resultLabel.text = ""
        resultLabel.horizontalAlignmentMode = .center
        resultLabel.position = CGPoint(x: 512, y: 700)
        addChild(resultLabel)

        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        //튕겨지는 물체
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        //good bad 불타는 물체
       
        
        initGame()
  
    }
    //동시터치문제
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        //터치한곳을 지정하고
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        //초기화버튼일때
        if objects.contains(initLabel){
            initGame()
        }
        //아무데나 눌렀을때 공이 나옴  화면에 공 없을때
        else if chance > 0 && !isBallInPlay() {
            let ball = SKSpriteNode(imageNamed: "ball\(ballColors.randomElement()!)")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
            ball.physicsBody?.restitution = 0.4
            ball.position = CGPoint(x: location.x, y: 700)
            ball.name = "ball"
            addChild(ball)
        }
        
    }
    //초기화 : 박스 랜덤으로, chance = 5
    func initGame(){
        chance = 5
        resultLabel.text = ""
        
        //남은 박스 모두 지우고 박스 다시 랜덤으로 보이기
        for node in self.children{
            if node.name == "box"{
                node.removeFromParent()
            }
            
        }
        //랜덤 박스 만들기 13~17개
        let randomBoxCount: Int = Int.random(in: 13...17)
        makeRandomBoxes(number: randomBoxCount)
    }
    func makeRandomBoxes(number:Int){
    for _ in 1...number {
            let size = CGSize(width: Int.random(in: 16...128), height: 16)
            let color = getBoxColor()
            let rotation = CGFloat.random(in: 0...3)
            let position = CGPoint(x: CGFloat.random(in: 128...896), y: CGFloat.random(in: 200...568))
        
        let box = SKShapeNode(rectOf: size, cornerRadius: 3)
        box.fillColor = color
        box.strokeColor = color
        box.lineWidth = 1
        box.zRotation = rotation
        box.position = position
        box.physicsBody = SKPhysicsBody(rectangleOf: size)
        box.physicsBody?.isDynamic = false
        box.name = "box"
        addChild(box)
        }
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        }
        else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    func isBallInPlay() -> Bool {
        for node in self.children {
            if node.name == "ball" {
                return true
            }
        }
        return false
    }
    func getBoxColor() -> UIColor {

        let colors = [
            UIColor.red,
            UIColor.magenta,
            UIColor.blue,
            UIColor.cyan,
            UIColor.green,
            UIColor.yellow,
            UIColor.orange,
            UIColor.purple,
            UIColor.white
        ]

        return colors.randomElement()!.withAlphaComponent(0.75)
    }
    //bouncer
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    //slot
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        }
        else {
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
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "box" {
            object.removeFromParent()
        }
        if object.name == "good" {
            destroy(ball: ball, isGood: true)
            manageResult()
        }
        else if object.name == "bad" {
            destroy(ball: ball, isGood: false)
            chance -= 1
            manageResult()
        }
    }
    func manageResult() {
        //박스가 안남았으면
        if !isRemainingBoxes() {
            resultLabel.fontColor = UIColor.green
            resultLabel.text = "CLEAR!!"
        }
        else if chance == 0 {
            resultLabel.fontColor = UIColor.red
            resultLabel.text = "FAIL..."
        }
    }
    func isRemainingBoxes() -> Bool {
        for node in self.children {
            if node.name == "box" {
                return true
            }
        }
        return false
    }
    func destroy(ball: SKNode, isGood: Bool) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            //good일때 초록불
            if isGood {
                fireParticles.particleColorGreenRange = 1
            }
            else {
                fireParticles.particleColorRedRange = 1
            }
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
}

