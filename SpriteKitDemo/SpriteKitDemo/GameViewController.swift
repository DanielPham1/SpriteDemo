//
//  GameViewController.swift
//  SpriteKitDemo
//
//  Created by Hanson on 16/5/9.
//  Copyright (c) 2016年 Hanson. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        setupView()
    }
    
    func setupView() {
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        // 默认
//        defaultScene(skView)
        
        // 创建的Hello
//        helloScene(skView)
        
        // 游戏
        gameScene(skView)
    }

    // 默认场景
    func defaultScene(skView: SKView) {
        guard let scene = GameScene(fileNamed: "GameScene")  else { return }
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    
    // 第一个场景，显示Hello Scene
    func helloScene(skView: SKView) {
        // 创建场景
        let scene = HSGameScene(size: CGSizeMake(100, 100))
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)

    }
    
    // 游戏
    func gameScene(skView: SKView) {
        let scene = MyGameScene(size: skView.frame.size)
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)

    }
}
