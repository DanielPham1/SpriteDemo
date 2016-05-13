//
//  GameScene.swift
//  FlappyBridDemo
//
//  Created by Hanson on 16/5/12.
//  Copyright (c) 2016年 Hanson. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
   
    let bgScale: CGFloat = 2.0 // 背景缩放比例
    let movingSpeed: CGFloat = 50 // 移动速度
    let verticalPipeGap = 50.0 // 卡口高度
    let moving = SKNode() // 移动的父节点
    let pipes = SKNode()
    
    var groundY: CGFloat! // 地面的Y值
    var pipeTextureTop: SKTexture! // 顶部卡口
    var pipeTextureBottom: SKTexture! // 底部卡口
    var movePipesAndRemove: SKAction! // 卡口动作
    
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    
    
    override func didMoveToView(view: SKView) {
        
        addChild(moving)
        moving.addChild(pipes)
        backgroundColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        
        // 地面
        let groundTexture = SKTexture(imageNamed: "land")
        groundY = groundTexture.size().height * bgScale * 0.5
        let groundPosition = CGPoint(x: groundTexture.size().width * bgScale, y: groundY)
        movingTextrue(groundTexture, position: groundPosition)

        // 房屋
        let skyTexture = SKTexture(imageNamed: "sky")
        let skyPosition = CGPoint(x: skyTexture.size().width * bgScale, y: skyTexture.size().height * 0.5 * bgScale  + groundTexture.size().height * bgScale)
        movingTextrue(skyTexture, position: skyPosition)
        
        
        
        
        // 卡口
        pipeTextureTop = SKTexture(imageNamed: "PipeTop") // 顶部钢管
        pipeTextureTop.filteringMode = .Nearest
        pipeTextureBottom = SKTexture(imageNamed: "PipeBottom") // 底部钢管
        pipeTextureBottom.filteringMode = .Nearest
        
        // 卡口动画
        let distanceToMove = CGFloat(self.frame.size.width + 4.0 * pipeTextureTop.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
//        let pipeSpriteDown = SKSpriteNode(texture: pipeTextureTop)
//        let pipeSpriteUp = SKSpriteNode(texture: pipeTextureBottom)
//        pipeSpriteUp.anchorPoint = CGPointMake(0.5, 0)
//        pipeSpriteUp.position = CGPointMake(frame.size.width * 0.5, groundTexture.size().height * birdCategory)
//        pipeSpriteDown.anchorPoint = CGPointMake(0.5, 1)
//        pipeSpriteDown.position = CGPointMake(frame.size.width * 0.5, frame.size.height)
//        
//        moving.addChild(pipeSpriteUp)
//        moving.addChild(pipeSpriteDown)
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
    }
    
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: self.frame.size.width + pipeTextureBottom.size().width * 2, y: 0 )
        pipePair.zPosition = 1
        
        let height = UInt32( self.frame.size.height / 4)
        let y = Double(arc4random_uniform(height) + height);
        
        let pipeTop = SKSpriteNode(texture: pipeTextureTop)
//        pipeDown.setScale(0.5)
        pipeTop.position = CGPoint(x: 0.0, y: y + Double(pipeTop.size.height) + verticalPipeGap)
        
        
        pipeTop.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTop.size)
        pipeTop.physicsBody?.dynamic = false
        pipeTop.physicsBody?.categoryBitMask = pipeCategory
        pipeTop.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeTop)
        
        let pipeBottom = SKSpriteNode(texture: pipeTextureBottom)
//        pipeUp.setScale(0.5)
        pipeBottom.position = CGPoint(x: 0.0, y: y)
        pipeBottom.size = CGSize(width: pipeTextureBottom.size().width, height: pipeBottom.frame.origin.y - groundY)
        
        pipeBottom.physicsBody = SKPhysicsBody(rectangleOfSize: pipeBottom.size)
        pipeBottom.physicsBody?.dynamic = false
        pipeBottom.physicsBody?.categoryBitMask = pipeCategory
        pipeBottom.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeBottom)
        
        var contactNode = SKNode()
        contactNode.position = CGPoint( x: pipeTop.size.width + 50 / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize( width: pipeBottom.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        pipePair.runAction(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }
    
    
    
    func movingTextrue(textTrue: SKTexture,position: CGPoint) {
        textTrue.filteringMode = .Nearest
        let moveDuration = NSTimeInterval(textTrue.size().width / movingSpeed);
        let moveSprite = SKAction.moveByX(-textTrue.size().width * 2.0, y: 0, duration: moveDuration)
        let resetSprite = SKAction.moveByX(textTrue.size().width * 2.0, y: 0, duration: 0.0)
        let moveSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSprite,resetSprite]))
        
        let maxMove = Int(2.0 + self.frame.size.width / ( textTrue.size().width * bgScale ) + 0.5)
        for i in 0 ..< maxMove {
            let sprite = SKSpriteNode(texture: textTrue)
            sprite.setScale(bgScale)
            sprite.position = CGPoint(x: CGFloat(i) * position.x, y: position.y)
            sprite.runAction(moveSpritesForever)
            moving.addChild(sprite)
        }
    }
}


class PipeSpriteNode: SKSpriteNode {
    <#code#>
}