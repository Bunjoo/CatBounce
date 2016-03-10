//
//  GameScene.swift
//  SKintro
//
//  Created by admin on 2016-03-10.
//  Copyright (c) 2016 axu. All rights reserved.
//

import SpriteKit

let wallMask:UInt32 = 0x1 << 0 // 1
let catMask:UInt32 = 0x1 << 1 // 2
let floorMask:UInt32 = 0x1 << 2 // 4
let replay = SKLabelNode(fontNamed: "Chalkduster")

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    var cat:SKSpriteNode!
    var touchLocation:CGPoint = CGPointZero
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)*/
        
        cat = self.childNodeWithName("cat") as! SKSpriteNode
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        cat.runAction(SKAction.repeatActionForever(action))
        
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if()
        }*/
        cat.physicsBody?.velocity = CGVectorMake(0,1500)
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cat.physicsBody?.collisionBitMask = wallMask | floorMask
        cat.physicsBody?.contactTestBitMask = cat.physicsBody!.collisionBitMask
        /*
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if replay.position == location {
            }
        }*/
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        /*print(cat.position.y)
        if(cat.position.y <= 56){
            let myLabel = SKLabelNode(fontNamed:"Chalkduster")
            myLabel.text = "Hello, World!"
            myLabel.fontSize = 45
            myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            
            self.addChild(myLabel)
        }
        */
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let cat = (contact.bodyA.categoryBitMask == catMask) ? contact.bodyA: contact.bodyB
        
        let other = (cat == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == floorMask {
            let myLabel = SKLabelNode(fontNamed:"Chalkduster")
            myLabel.text = "You Lose!"
            myLabel.fontSize = 80
            myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            self.addChild(myLabel)
            cat.node?.removeAllActions()
            
            
            replay.text = "play again?"
            replay.fontSize = 50
            replay.position = CGPoint(x:CGRectGetMidX(self.frame), y:myLabel.position.y - 50)
            self.addChild(replay)
            
            
        }
    }
    
}
