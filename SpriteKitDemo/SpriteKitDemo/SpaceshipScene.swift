//
//  SpaceshipScene.swift
//  SpriteKitDemo
//
//  Created by Hanson on 16/5/9.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import SpriteKit

class SpaceshipScene: SKScene {

    var contentCreated: Bool?
    
    override func didMoveToView(view: SKView) {
        
        if let create = contentCreated where create { return }
        
        backgroundColor = SKColor.redColor()
        scaleMode = .AspectFill
        addSpaceship()
        
    }

    // 添加飞船
    func addSpaceship() {
        let spaceship = newSpaceship()
        spaceship.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))

        addChild(spaceship)
        
    }
    
    func newSpaceship() -> SKSpriteNode {
        let hull = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(64, 32))
        let hover = SKAction.sequence([SKAction.waitForDuration(0.5),
            SKAction.moveToX(100, duration: 50),
            SKAction.waitForDuration(0.5),
            SKAction.moveToX(-100, duration: -50)
            ])
        
        hull.runAction(SKAction.repeatActionForever(hover))
        return hull
    }
}
