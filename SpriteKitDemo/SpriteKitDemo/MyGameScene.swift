//
//  MyGameScene.swift
//  SpriteKitDemo
//
//  Created by Hanson on 16/5/10.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import SpriteKit
import AVFoundation

let playerName = "player"


class MyGameScene: SKScene {

    // 敌人
    var monsters = [SKSpriteNode]()
    // 飞镖
    var projectiles = [SKSpriteNode]()
    // 音效
    lazy var projectileSoundEffectAction = SKAction.playSoundFileNamed("pew-pew-lei", waitForCompletion: false)
    // 击退敌人
    var monstersDestroyed = 0
    
    var bgmPlayer: AVAudioPlayer? = {
        let bgmPath = NSBundle.mainBundle().pathForResource("background-music-aac", ofType: "caf")
        let bgmPlayer = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: bgmPath!))
        bgmPlayer.numberOfLoops = -1
        return bgmPlayer
    }()
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // 添加英雄
        backgroundColor = SKColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let player = SKSpriteNode(imageNamed: "player")
        player.name = playerName
        player.position = CGPointMake(player.size.width * 0.5, frame.size.height * 0.5)
        addChild(player)
        
        // 添加敌人
        let actionAddMonster = SKAction.runBlock { [unowned self] in
            self.addMonster()
        }
        let actionWaitNextMonster = SKAction.waitForDuration(1.0)
        runAction(SKAction.repeatActionForever(SKAction.sequence([actionAddMonster,actionWaitNextMonster])))
        
        // 播放背景音乐
        bgmPlayer?.play()
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
            
            // 敌人移动到屏幕边缘，跳转场景（输）
            self.changeToResultSceneWithWon(false)
            
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
            let moveAction = SKAction.moveTo(realDest, duration: Double(realMoveDuration))
            let projectileCastAction = SKAction.group([moveAction, projectileSoundEffectAction])
            projectile.runAction(projectileCastAction){ [unowned self] in
                self.projectiles.removeAtIndex(self.projectiles.indexOf(projectile)!)
                projectile.removeFromParent()
            }
            
            
        }
    }
    
    // 检测飞镖和敌人是否碰撞，碰撞即移除飞镖和敌人
    override func update(currentTime: NSTimeInterval) {
        
        var projectilesToDelete = [SKSpriteNode]()
        
        for projectile in projectiles {
            
            // 标记中飞镖的敌人monster
            var monstersToDelete = [SKSpriteNode]()
            for monster in monsters {
                if CGRectIntersectsRect(projectile.frame, monster.frame) {
                    monstersToDelete.append(monster)
                    
                    // 击中敌人，统计数量
                    monstersDestroyed += 1
                    if monstersDestroyed >= 30 {
                        // 击中人数达到30人，跳转场景（赢）
                        changeToResultSceneWithWon(true)
                    }
                }
            }
            
            // 将中飞镖的敌人移除
            for monster in monstersToDelete {
                monsters.removeAtIndex(monsters.indexOf(monster)!)
                monster.removeFromParent()
            }
            
            // 若该飞镖击中敌人，标记飞镖
            if monstersToDelete.count > 0 {
                projectilesToDelete.append(projectile)
            }
        }
        
        // 移除击中敌人的飞镖
        for projectile in projectilesToDelete {
            projectiles.removeAtIndex(projectiles.indexOf(projectile)!)
            projectile.removeFromParent()
        }
    }
    
    func changeToResultSceneWithWon(won: Bool) {
        bgmPlayer?.stop()
        bgmPlayer = nil
        
        let resultScene = MyGameResultScene(size: self.size, won: won)
        let reveal = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 1.0)
        self.scene?.view?.presentScene(resultScene, transition: reveal)
    }
    
}
