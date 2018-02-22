//
//  GameUtils.swift
//  ZombieFight iOS
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class GameUtils {
    class func loadNodeFromScene(filename:String) -> SCNNode? {
        let node = SCNNode()
        guard let modelScene = SCNScene(named: filename) else {
            print("Cannot load player model")
            return nil
        }
        for anode in modelScene.rootNode.childNodes as [SCNNode] {
            node.addChildNode(anode)
        }
        return node
    }
    
    /* New method of animations using SCNAnimationPlayer */
    class func loadAnimation(fromSceneNamed sceneName: String) -> SCNAnimationPlayer {
        let scene = SCNScene( named: sceneName )!
        // find top level animation
        var animationPlayer: SCNAnimationPlayer! = nil
        scene.rootNode.enumerateChildNodes { (child, stop) in
            if !child.animationKeys.isEmpty {
                animationPlayer = child.animationPlayer(forKey: child.animationKeys[0])
                stop.pointee = true
            }
        }
        return animationPlayer
    }
    
    /* old method using CAAnimation */
    class func loadAnimation(sceneName:String, withExtension:String, animationIdentifier:String) -> CAAnimation? {
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: withExtension)
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
            // The animation will  play forever
            animationObject.repeatCount = Float.infinity
            // To create smooth transitions between animations
            animationObject.fadeInDuration = CGFloat(0.2)
            animationObject.fadeOutDuration = CGFloat(0.2)
            
            return animationObject
        } else {
            return nil
        }
    }
    
    class func createLine(from:SCNVector3, to:SCNVector3, color:SKColor=SKColor.red) -> SCNNode {
        let data = [from, to]
        let indices:[Int32] = [0, 1]
        
        let indexData = NSData(bytes: indices, length: indices.count * MemoryLayout<Int32>.size)
        let vertexSource = SCNGeometrySource(vertices: data)
        let element = SCNGeometryElement(data: indexData as Data,
                                         primitiveType: SCNGeometryPrimitiveType.line,
                                         primitiveCount: 1,
                                         bytesPerIndex: MemoryLayout<Int32>.size)
        
        let geo = SCNGeometry(sources: [vertexSource], elements: [element])
        let material = SCNMaterial()
        material.diffuse.contents = color
        geo.firstMaterial = material
        geo.firstMaterial!.isDoubleSided = true
        geo.firstMaterial!.diffuse.contents = color
        return SCNNode(geometry: geo)
    }
    
    class func addBillboardText(text:String, color:SKColor=SKColor.blue) -> SCNNode {
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial!.diffuse.contents = SKColor.red
        let textNode = SCNNode(geometry: textGeometry)
        
        // Update object's pivot to its center
        // https://stackoverflow.com/questions/44828764/arkit-placing-an-scntext-at-a-particular-point-in-front-of-the-camera
        let (min, max) = textGeometry.boundingBox
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        let parentNode = SCNNode(geometry:SCNPlane(width: 0.2, height: 0.2))
        parentNode.geometry?.firstMaterial?.diffuse.contents = color
        
        let yFreeConstraint = SCNBillboardConstraint()
        //yFreeConstraint.freeAxes = .Y // optionally
        parentNode.constraints = [yFreeConstraint] // apply the constraint to the parent node
        parentNode.addChildNode(textNode)
        return parentNode
    }
    
    class func degreesToRadians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
    
    class func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / Double.pi
    }
    
}
