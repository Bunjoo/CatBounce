//
//  GameViewController.swift
//  SKintro
//
//  Created by admin on 2016-03-10.
//  Copyright (c) 2016 axu. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

var bgm = AVAudioPlayer()

class GameViewController: UIViewController {

    func playBGM(filename: String){
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        guard let newURL = url else{
            print("could not find file: \(filename)")
            return
        }
        do{
            bgm = try AVAudioPlayer(contentsOfURL: newURL)
            bgm.numberOfLoops = -1
            bgm.prepareToPlay()
            bgm.play()
        }
        catch let error as NSError{
            print(error.description)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playBGM("bgm.mp3")

        if let scene = GameScene(fileNamed:"MainMenu") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFit
            //aspect.fit -> makes it fit no matter what (but letterboxes)
            // .fill -> makes it fit into screen, but can look squished (also shows more than "oultines") (scales)
            // .ResizeFill -> changes size of scene to match device. (zooms in wayy too much?)
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
