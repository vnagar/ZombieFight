//
//  MenuUtils.swift
//  Titan
//
//  Created by Vivek Nagar on 1/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SpriteKit

class MenuUtils {
    class func labelWithText(text:String, textSize:CGFloat, fontColor:SKColor)->SKLabelNode {
        let fontName:String = "Optima-ExtraBlack"
        let myLabel:SKLabelNode = SKLabelNode(fontNamed: fontName)
        
        myLabel.name = text
        myLabel.text = text
        myLabel.fontSize = textSize;
        myLabel.fontColor = fontColor
        
        return myLabel;
    }

}
