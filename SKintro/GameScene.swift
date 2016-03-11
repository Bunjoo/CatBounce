//
//  GameScene.swift
//  SKintro
//
//  Created by admin on 2016-03-10.
//  Copyright (c) 2016 axu. All rights reserved.
//

import SpriteKit
import AVFoundation

//globals
let wallMask:UInt32 = 0x1 << 0 // 1
let catMask:UInt32 = 0x1 << 1 // 2
let floorMask:UInt32 = 0x1 << 2 // 4


class GameScene: SKScene , SKPhysicsContactDelegate{
    
    //Variables
    var cat:SKSpriteNode!
    var touchLocation:CGPoint = CGPointZero
    var bgm:SKAudioNode!
    var labelLose:SKLabelNode!
    var labelReplay:SKLabelNode!
    var labelCounter:SKLabelNode!
    var home:SKSpriteNode!
    var bounces:Int = 0
    var inGame = true
    
    override func didMoveToView(view: SKView) {
        
        //instantiate
        cat = self.childNodeWithName("cat") as! SKSpriteNode
        labelLose = self.childNodeWithName("labelLose") as! SKLabelNode
        labelReplay = self.childNodeWithName("labelReplay") as! SKLabelNode
        labelCounter = self.childNodeWithName("counter") as! SKLabelNode
        home = self.childNodeWithName("home") as! SKSpriteNode
        
        //start game with these hidden
        labelLose.hidden = true;
        labelReplay.hidden = true;
        home.hidden = true;
        
        //spin cat forever
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        cat.runAction(SKAction.repeatActionForever(action))
        
        //adding physics touch
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            //set location of where was touched
            let location = touch.locationInNode(self)
            
            //if tapped on cat and game is not over
            if(cat .containsPoint(location) && inGame){
                //propel cat up
                cat.physicsBody?.velocity = CGVectorMake(0,1500)
                //ADD BOUNCE CAT AT ANGLE??
                //increment bounce
                bounces += 1
                //meow if bounce counter is divisible of 10
                if bounces%10 == 0 {
                    self.runAction(SKAction.playSoundFileNamed("meow.wav", waitForCompletion: false))
                }
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //collision checking
        cat.physicsBody?.collisionBitMask = wallMask | floorMask
        cat.physicsBody?.contactTestBitMask = cat.physicsBody!.collisionBitMask
        
        for touch in touches{
            //store tap location
            let location = touch.locationInNode(self)
            
            //checks if game is over + if tapped on home
            if inGame == false && home.containsPoint(location){
                let game:GameScene = GameScene(fileNamed: "MainMenu")!
                game.scaleMode = .AspectFill
                let transition:SKTransition = SKTransition.crossFadeWithDuration(0.5)
                self.view?.presentScene(game, transition: transition)
            }
            //checks if game is over + if tapped on replay
            if inGame == false && labelReplay.containsPoint(location){
                let game:GameScene = GameScene(fileNamed: "GameScene")!
                game.scaleMode = .AspectFill
                let transition:SKTransition = SKTransition.crossFadeWithDuration(0.5)
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        let strBounces = bounces as NSNumber
        labelCounter.text = "Bounces: " + strBounces.stringValue
    }
    
    //reacting to collision
    func didBeginContact(contact: SKPhysicsContact) {
        
        let cat = (contact.bodyA.categoryBitMask == catMask) ? contact.bodyA: contact.bodyB
        let other = (cat == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == floorMask {
            inGame = false
            lost()
            cat.node?.removeAllActions()
            
        }
    }
    
    //called when lose.
    func lost(){
        cat.removeFromParent()
        labelLose.hidden = false
        labelReplay.hidden = false
        home.hidden = false
        self.runAction(SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false))
    }
    
}

