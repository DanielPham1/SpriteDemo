//
//  GuideScene.swift
//  FlappyBridDemo
//
//  Created by Hanson on 16/5/12.
//  Copyright © 2016年 Hanson. All rights reserved.
//

import SpriteKit

struct GrandeNode {
    var text:String?
    var difficult: CGFloat?
}

// 节点名称
let grandeNodeName = "grandeNodeName" // 难易度节点名称
let backgroundName = "backgroundName" // 背景节点名称

class GuideScene: SKScene {
    // 难易度
    var facilitys = [GrandeNode(text: "简单", difficult: 120),
                    GrandeNode(text: "一般", difficult: 120),
                    GrandeNode(text: "困难", difficult: 120)]
    
    // 背景图
    lazy var background: SKSpriteNode = {
        let sprite = SKSpriteNode(imageNamed: "blue-shooting-stars")
        sprite.name = backgroundName
        sprite.anchorPoint = CGPointZero
        
        return sprite
    }()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        // 添加背景
        addChild(background)
        
        // 添加 难易度选择节点
        addGrandeNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 添加难易度选择节点
    func addGrandeNode()  {
        var index: CGFloat = 0.0
        for facility in facilitys {
            let grandeNode = SKLabelNode(text: facility.text)
            grandeNode.name = grandeNodeName
            grandeNode.fontName = "Chalkduster"
            grandeNode.fontSize = 24
            grandeNode.fontColor = SKColor.greenColor()
            grandeNode.position = CGPointMake(size.width * 0.5, size.height * 0.5 + 50 - (index * 50))
            background.addChild(grandeNode)
            index += 1
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touche = touches.first else { return }
        let touchLocation = touche.locationInNode(self)
        let touchNode = nodeAtPoint(touchLocation) as? SKLabelNode
        // 点击的不是难易度节点，不做操作
        if touchNode?.name != grandeNodeName { return }
        
        // 创建场景
        let scene = GameScene(size: size)
        for facility in facilitys {
            
            if touchNode?.text != facility.text { continue }
            
            // 切换场景
//            scene.difficult = facility.difficult
            let transition = SKTransition.crossFadeWithDuration(2.0)
            view?.presentScene(scene, transition: transition)
            break
        }
        
    }
}

