//
//  GameScene.swift
//  SKintro
//
//  Created by admin on 2016-03-10.
//  Copyright (c) 2016 axu. All rights reserved.
//

import SpriteKit
import AVFoundation

let wallMask:UInt32 = 0x1 << 0 // 1
let catMask:UInt32 = 0x1 << 1 // 2
let floorMask:UInt32 = 0x1 << 2 // 4


class GameScene: SKScene , SKPhysicsContactDelegate{
    
    var cat:SKSpriteNode!
    var touchLocation:CGPoint = CGPointZero
    var bgm:SKAudioNode!
    var labelLose:SKLabelNode!
    var labelReplay:SKLabelNode!
    var labelCounter:SKLabelNode!
    var bounces:Int = 0
    var inGame = true
    
    override func didMoveToView(view: SKView) {
        
        cat = self.childNodeWithName("cat") as! SKSpriteNode
        labelLose = self.childNodeWithName("labelLose") as! SKLabelNode
        labelReplay = self.childNodeWithName("labelReplay") as! SKLabelNode
        labelCounter = self.childNodeWithName("counter") as! SKLabelNode
        
        labelLose.hidden = true;
        labelReplay.hidden = true;
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        cat.runAction(SKAction.repeatActionForever(action))
        
        self.physicsWorld.contactDelegate = self
        
        //this method used for occasional sounds
        
        //self.runAction(SKAction.playSoundFileNamed("bgm.mp3", waitForCompletion: false))
        
        //correct method to use bgm -- doesnt work?
        //let backgroundMusic = SKAudioNode(fileNamed: "bgm.mp3")
        //self.addChild(backgroundMusic)
        //bgm = SKAudioNode(fileNamed: "bgm.mp3")
        //self.addChild(bgm)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if()
        }*/
        //cat.physicsBody?.velocity = CGVectorMake(0,1500)
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if(cat .containsPoint(location) && inGame){
                cat.physicsBody?.velocity = CGVectorMake(0,1500)
                bounces += 1
                if bounces%5 == 0 {
                    self.runAction(SKAction.playSoundFileNamed("meow.wav", waitForCompletion: false))
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cat.physicsBody?.collisionBitMask = wallMask | floorMask
        cat.physicsBody?.contactTestBitMask = cat.physicsBody!.collisionBitMask
        
        for touch in touches{
            let location = touch.locationInNode(self)
            
            if labelReplay.hidden == false{
                if labelReplay.containsPoint(location){
                    let game:GameScene = GameScene(fileNamed: "GameScene")!
                    game.scaleMode = .AspectFill
                    let transition:SKTransition = SKTransition.crossFadeWithDuration(0.5)
                    self.view?.presentScene(game, transition: transition)
                }
            }

        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        let strBounces = bounces as NSNumber
        labelCounter.text = "Bounces: " + strBounces.stringValue
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let cat = (contact.bodyA.categoryBitMask == catMask) ? contact.bodyA: contact.bodyB
        
        let other = (cat == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == floorMask {
            labelLose.hidden = false
            labelReplay.hidden = false
            inGame = false
            cat.node?.removeAllActions()
            
        }
    }
    
}
// didmovetoview
/* Setup your scene here */
/*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
myLabel.text = "Hello, World!"
myLabel.fontSize = 45
myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))

self.addChild(myLabel)*/

