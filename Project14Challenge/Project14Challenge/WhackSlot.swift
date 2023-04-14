//
//  WhackSlot.swift
//  Project14Challenge
//
//  Created by 박다미 on 2023/04/13.
//

import UIKit
import SpriteKit



class WhackSlot: SKNode {
    
    var charNode : SKSpriteNode!
    var isVisible = false
    var isHit = false
    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = nil
       // cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
        
        
    }
    //보일때
    func show(hideTime: Double) {
        if isVisible {return}
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
            
        }else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
            
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
        //숨을때
        func hide() {
            if !isVisible { return }
            
            charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
            isVisible = false
        }
        
        
        //잡았을때
        func hit(){
            isHit = true
            
            let delay = SKAction.wait(forDuration: 0.25)
            let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
            let notVisible = SKAction.run {[weak self] in self?.isVisible = false}
            let sequence = SKAction.sequence([delay, hide, notVisible])
            charNode.run(sequence)
        }
    }
