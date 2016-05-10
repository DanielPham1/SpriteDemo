//
//  MyGameScene.swift
//  SpriteKitDemo
//
//  Created by Hanson on 16/5/10.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import SpriteKit

let playerName = "player"

class MyGameScene: SKScene {

    var monsters = [SKSpriteNode]()
    var projectiles = [SKSpriteNode]()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // 添加英雄
        backgroundColor = SKColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let player = SKSpriteNode(imageNamed: "player")
        player.name = playerName
        player.position = CGPointMake(player.size.width * 0.5, player.size.height * 0.5)
        addChild(player)
        
        // 添加敌人
        let actionAddMonster = SKAction.runBlock { [unowned self] in
            self.addMonster()
        }
        let actionWaitNextMonster = SKAction.waitForDuration(1.0)
        runAction(SKAction.repeatActionForever(SKAction.sequence([actionAddMonster,actionWaitNextMonster])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 添加敌人
    func addMonster() {
        
        let monster = SKSpriteNode(imageNamed: "monster")
        let winSize = size
        let minY = monster.size.height * 0.5
        let maxY = winSize.height - monster.size.height * 0.5
        let rangeY = maxY - minY
        let actualY = (CGFloat(arc4random()) % rangeY) + minY
        
        // 显示敌人
        monster.position = CGPointMake(winSize.width - monster.size.width * 0.5, actualY)
        addChild(monster)
        monsters.append(monster)
        
        // 计算敌人移动参数
        let minDuration = 2.00
        let maxDuration = 4.00
        let rangeDuration = maxDuration - minDuration
        let actualDuration = (Double(arc4random()) % rangeDuration) + minDuration
        let actionMove = SKAction.moveTo(CGPointMake(-monster.size.width * 0.5, actualY), duration: actualDuration)
        
        let actionMoveDone = SKAction.runBlock { [unowned self] in
           self.monsters.removeAtIndex(self.monsters.indexOf(monster)!)
            monster.removeFromParent()
        }
        
        monster.runAction(SKAction.sequence([actionMove,actionMoveDone]))
    }
    
    
    // 点击屏幕发射飞镖
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let winSize = size
            
            // 取出英雄
            guard let player = childNodeWithName(playerName) else { return }
            // 当前点击的点
            let touchPoint = touch.locationInNode(self)
            
            let offSet = CGPointMake(touchPoint.x - player.position.x, touchPoint.y - player.position.y)
            // 点击英雄左边无效
            if offSet.x <= 0 { return }
            
            // 创建飞镖
            let projectile = SKSpriteNode(imageNamed: "projectile.png")
            projectile.position = player.position
            addChild(projectile)
            projectiles.append(projectile)
            
            // 计算偏移量
            let realX = winSize.width - projectile.size.width * 0.5
            let ratio = offSet.y / offSet.x
            let realY = (realX * ratio) + projectile.position.y
            let realDest = CGPointMake(realX, realY)
            
            // 计算飞镖移动时间
            let offRealX = realX - projectile.position.x
            let offRealY = realY - projectile.position.y
            let length = sqrtf(Float((offRealX * offRealX) + (offRealY * offRealY)))
            let velocity = self.size.width
            let realMoveDuration =  CGFloat(length) / velocity
            
            // 执行飞镖移动操作，移动结束将移除飞镖
            projectile.runAction(SKAction.moveTo(realDest, duration: Double(realMoveDuration))){ [unowned self] in
                self.projectiles.removeAtIndex(self.projectiles.indexOf(projectile)!)
                projectile.removeFromParent()
            }
            
            
        }
    }
    
    // 检测飞镖和敌人是否碰撞，碰撞即移除飞镖和敌人
    override func update(currentTime: NSTimeInterval) {
        
        var projectilesToDelete = [SKSpriteNode]()
        
        for projectile in projectiles {
            
            var monstersToDelete = [SKSpriteNode]()
            for monster in monsters {
                if CGRectIntersectsRect(projectile.frame, monster.frame) {
                    monstersToDelete.append(monster)
                }
            }
            
            for monster in monstersToDelete {
                monsters.removeAtIndex(monsters.indexOf(monster)!)
                monster.removeFromParent()
            }
            
            if monstersToDelete.count > 0 {
                projectilesToDelete.append(projectile)
            }
        }
        
        for projectile in projectilesToDelete {
            projectiles.removeAtIndex(projectiles.indexOf(projectile)!)
            projectile.removeFromParent()
        }
    }
    
}
