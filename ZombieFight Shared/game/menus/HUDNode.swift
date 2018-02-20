//
//  HUDNode.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SpriteKit
import GameController

class HUDNode : SKNode {
    var size = CGSize.zero
    var overlay:SKScene?
    var healthBar:SKSpriteNode?
    let maxHealth = 10.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    init(scene:SKScene, size:CGSize) {
        super.init()
        self.size = size
        self.overlay = scene
        
        self.addControls()
    }
    
    func setHealth(value:Float) {
        updateHealthBar(node: healthBar!, withHealthPoints: value)
    }
    
    private func addControls() {
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x:size.width * 0.50, y:size.height*0.92)
        self.addChild(scoreLabel)
        
        self.healthBar = SKSpriteNode()
        self.healthBar!.position = CGPoint(x:size.width * 0.1, y:size.height*0.92)
        self.addChild(self.healthBar!)
        self.setHealth(value: Float(maxHealth))
        
        let bombsLabel = SKLabelNode(fontNamed: "Chalkduster")
        bombsLabel.text = "Bombs: 0"
        bombsLabel.position = CGPoint(x:size.width - 120, y:size.height*0.92)
        bombsLabel.setScale(0.4)
        self.addChild(bombsLabel)
        
        let arrowsLabel = SKLabelNode(fontNamed: "Chalkduster")
        arrowsLabel.text = "Arrows: 0"
        arrowsLabel.position = CGPoint(x:size.width - 50, y:size.height*0.92)
        arrowsLabel.setScale(0.4)
        self.addChild(arrowsLabel)
        
        // The virtual D-pad
        #if os(iOS)
            let dpadSprite = SKSpriteNode(imageNamed: "Art.scnassets/overlays/dpad")
            dpadSprite.position = CGPoint(x:size.width * 0.15, y:size.height*0.2)
            dpadSprite.name = "dpad"
            dpadSprite.zPosition = 1.0
            dpadSprite.setScale(0.4)
            self.addChild(dpadSprite)

            let attackSprite = SKSpriteNode(imageNamed: "Art.scnassets/overlays/dpad")
            attackSprite.position = CGPoint(x:size.width * 0.85, y:size.height*0.2)
            attackSprite.name = "attackNode"
            attackSprite.zPosition = 1.0
            attackSprite.setScale(0.4)
            self.addChild(attackSprite)
        #endif
    }
    
    func removeControls() {
        guard let bar = healthBar else { return }
        bar.isHidden = true
    }
    
    private func updateHealthBar(node: SKSpriteNode, withHealthPoints hp: Float) {
        let healthBarWidth: CGFloat = 80
        let healthBarHeight: CGFloat = 25
        let barSize = CGSize(width: healthBarWidth, height: healthBarHeight);
        
        let greenFillColor = SKColor(red: 0.0, green: 1.0, blue: 0.0, alpha:1)
        let redFillColor = SKColor(red: 1.0, green: 0.0, blue: 0.0, alpha:1)
        let borderColor = SKColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        // create drawing context
#if os(iOS)
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
#else
        let spriteImage = NSImage(size: NSMakeSize(healthBarWidth, healthBarHeight))
        spriteImage.lockFocus()
        let context = NSGraphicsContext.current?.cgContext
#endif
        guard let ctx = context else {
            print("Cannot get current graphics context")
            return
        }
        // draw the outline for the health bar
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPoint.zero, size: barSize)
        ctx.stroke(borderRect, width: 2)
        
        // draw the health bar with a colored rectangle
        let barWidth = (barSize.width - 1) * CGFloat(hp) / CGFloat(maxHealth)
        if(barWidth <= 20.0) {
            redFillColor.setFill()
        } else {
            greenFillColor.setFill()
        }

        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        ctx.fill(barRect)
        
        // extract image
#if os(iOS)
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
#else
        spriteImage.unlockFocus()
#endif
        // set sprite texture and size
        node.texture = SKTexture(image: spriteImage)
        node.size = barSize
    }
    
#if os(iOS)
    func virtualDPadBounds() -> CGRect {
        return CGRect(x: 10, y: 10, width: 150.0, height: 150.0)
    }
#endif
}
