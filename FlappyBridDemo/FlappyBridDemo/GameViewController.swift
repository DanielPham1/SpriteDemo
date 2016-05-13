//
//  GameViewController.swift
//  FlappyBridDemo
//
//  Created by Hanson on 16/5/12.
//  Copyright (c) 2016年 Hanson. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let skView = view as! SKView
        if skView.scene == nil {
            skView.showsFPS = true
            skView.showsNodeCount = true
//            let scene = GuideScene(size: skView.frame.size)
            let scene = GameScene(size: skView.frame.size)
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
