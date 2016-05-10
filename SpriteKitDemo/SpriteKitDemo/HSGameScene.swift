//
//  HSGameScene.swift
//  SpriteKitDemo
//
//  Created by Hanson on 16/5/9.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import SpriteKit

class HSGameScene: SKScene {

    var contentCreated: Bool?
    override func didMoveToView(view: SKView) {
        
        if let create = contentCreated where create { return }
        
        backgroundColor = SKColor.blueColor()
        scaleMode = .AspectFill
        addChild(newHelloNode())
        
    }
    
    func newHelloNode() -> SKLabelNode {
        let helloNode = SKLabelNode()
        helloNode.name = "HelloNode"
        helloNode.text = "Hello Scene"
        helloNode.fontSize = 10
        helloNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))

        return helloNode
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let helloNode = childNodeWithName("HelloNode") {
            helloNode.name = nil
            let moveUp = SKAction.moveByX(0, y: 100, duration: 0.5)
            let zoom = SKAction.scaleTo(2.0, duration: 0.25)
            let pause = SKAction.waitForDuration(0.5)
            let fadeAway = SKAction.fadeInWithDuration(0.5)
            let remove = SKAction.removeFromParent()
            let moveSequence = SKAction.sequence([moveUp,zoom,pause,fadeAway,remove])
            
            helloNode.runAction(moveSequence) { [unowned self] in
                
                let spaceshipScene = SpaceshipScene(size: self.size)
                
                // 转场动画
//                let fade = SKTransition.fadeWithDuration(0.5) // 淡化
//                let cross = SKTransition.crossFadeWithDuration(0.5) // 淡化
//                let doors = SKTransition.doorwayWithDuration(0.5) // 开门
                
                let flip = SKTransition.flipHorizontalWithDuration(0.5) // 翻转
                
                self.view?.presentScene(spaceshipScene, transition: flip)
            }
            
        }
        
    }
}
