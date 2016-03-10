//
//  MainMenu.swift
//  SKintro
//
//  Created by admin on 2016-03-10.
//  Copyright © 2016 axu. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        
        game.scaleMode = .AspectFill
        
        let transition:SKTransition = SKTransition.crossFadeWithDuration(0.5)
        
        self.view?.presentScene(game, transition: transition)
        
    }
}
