//
//  MyGameResultScene.swift
//  SpriteKitDemo
//
//  Created by Hanson on 16/5/10.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import SpriteKit

class MyGameResultScene: SKScene {

    convenience init(size: CGSize,won: Bool) {
        self.init(size:size)
        backgroundColor = SKColor.whiteColor()
        scaleMode = .AspectFill
        
        let resultLabel = SKLabelNode(fontNamed: "Chalkduster")
        resultLabel.text = won ? "You win!" : "You lose"
        resultLabel.fontColor = SKColor.blackColor()
        resultLabel.fontSize = 30
        resultLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        addChild(resultLabel)
        
        let retryLabel = SKLabelNode(fontNamed: "Chalkduster")
        retryLabel.text = "Try again"
        retryLabel.name = "retry"
        retryLabel.fontSize = 20
        retryLabel.fontColor = SKColor.redColor()
        retryLabel.position = CGPointMake(resultLabel.position.x, resultLabel.position.y * 0.8)
        addChild(retryLabel)
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            let node = self.nodeAtPoint(touchLocation)
            if node.name == "retry" {
                changeToGameScene()
            }
        }
    }
    
    func changeToGameScene() {
        let gameScene = MyGameScene(size: self.size)
        let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 1.0)
        self.scene?.view?.presentScene(gameScene, transition: reveal)
    }
}
