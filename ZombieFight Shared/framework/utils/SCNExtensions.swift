//
//  SCNExtensions.swift
//  Raven
//
//  Created by Vivek Nagar on 2/7/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

public extension Int {
    /// SwiftRandom extension
    public static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

public extension Double {
    /// SwiftRandom extension
    public static func random(lower: Double = 0, _ upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

public extension Float {
    /// SwiftRandom extension
    public static func random(lower: Float = 0, _ upper: Float = 100) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

public extension CGFloat {
    /// SwiftRandom extension
    public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}


// MARK: Simd

extension float2 {
    init(_ v: CGPoint) {
        self.init(Float(v.x), Float(v.y))
    }
}

extension float3 {
    func length() -> Float {
        return sqrtf(x*x + y*y + z*z)
    }
    
    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0 and returns
     * the result as a new SCNVector3.
     */
    func normalized() -> float3 {
        return self / length()
    }
    
    mutating func truncate(max:Float) -> float3 {
        if (length() > max) {
            self = normalized()
            self = self * max
        }
        return self
    }
    
    func perp() -> float3 {
        return float3(-z, 0.0, x)
    }
}

// MARK: CoreAnimation
/*
extension CAAnimation {
    class func animationWithSceneNamed(_ name: String) -> CAAnimation? {
        var animation: CAAnimation?
        if let scene = SCNScene(named: name) {
            scene.rootNode.enumerateChildNodes({ (child, stop) in
                if child.animationKeys.count > 0 {
                    animation = child.animation(forKey: child.animationKeys.first!)
                    stop.initialize(to: true)
                }
            })
        }
        return animation
    }
}
 */

// MARK: SceneKit
extension SCNAnimationPlayer {
    func animationPlayer(offset:TimeInterval) -> SCNAnimationPlayer {
        var anim = self.animation
        let caAnim = CAAnimation(scnAnimation: anim)
        caAnim.timeOffset = offset * caAnim.duration
        caAnim.speed = 0
        caAnim.usesSceneTimeBase = false
        anim = SCNAnimation(caAnimation: caAnim)
        let animPlayer = SCNAnimationPlayer(animation: anim)
        return animPlayer
    }
    
    func animationPlayer(count:Float) -> SCNAnimationPlayer {
        var anim = self.animation
        let caAnim = CAAnimation(scnAnimation: anim)
        caAnim.repeatCount = count
        caAnim.usesSceneTimeBase = false
        anim = SCNAnimation(caAnimation: caAnim)
        let animPlayer = SCNAnimationPlayer(animation: anim)
        return animPlayer
    }
}

extension SCNNode {
    func orientationVector() -> SCNVector3 {
        return SCNVector3(self.worldTransform.m31, self.worldTransform.m32, self.worldTransform.m33)
    }
}

extension SCNGeometry {
    class func triangleFrom(vector1: SCNVector3, vector2: SCNVector3, vector3: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1, 2]
        let source = SCNGeometrySource(vertices: [vector1, vector2, vector3])
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        
        return SCNGeometry(sources: [source], elements: [element])
    }
}

extension SCNTransaction {
    class func animateWithDuration(_ duration: CFTimeInterval = 0.25, timingFunction: CAMediaTimingFunction? = nil, completionBlock: (() -> Void)? = nil, animations: () -> Void) {
        begin()
        self.animationDuration = duration
        self.completionBlock = completionBlock
        self.animationTimingFunction = timingFunction
        animations()
        commit()
    }
}

extension SCNPhysicsContact {
    func match(_ category: Int, block: (_ matching: SCNNode, _ other: SCNNode) -> Void) {
        if self.nodeA.physicsBody!.categoryBitMask == category {
            block(self.nodeA, self.nodeB)
        }
        
        if self.nodeB.physicsBody!.categoryBitMask == category {
            block(self.nodeB, self.nodeA)
        }
    }
}

extension SCNAudioSource {
    convenience init(name: String, volume: Float = 1.0, positional: Bool = true, loops: Bool = false, shouldStream: Bool = false, shouldLoad: Bool = true) {
        self.init(named: "game.scnassets/sounds/\(name)")!
        self.volume = volume
        self.isPositional = positional
        self.loops = loops
        self.shouldStream = shouldStream
        if shouldLoad {
            load()
        }
    }
}

extension SCNVector3
{
    /* Cast to float3 */
    init(_ floatValue:float3) {
        self.x = SCNFloat(floatValue.x)
        self.y = SCNFloat(floatValue.y)
        self.z = SCNFloat(floatValue.z)
    }
    
    /* Length of vector */
    func length() -> Float {
        return sqrtf(Float(x*x + y*y + z*z))
    }
    
    /* Squared Length of vector */
    func lengthSquared() -> Float {
        return Float(x*x + y*y + z*z)
    }
    
    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0 and returns
     * the result as a new SCNVector3.
     */
    func normalized() -> SCNVector3 {
        return SCNVector3(Float(self.x)/length(), Float(self.y)/length(), Float(self.z)/length())
    }
    
    /**
     * Negates the vector described by SCNVector3 and returns
     * the result as a new SCNVector3.
     */
    func negate() -> SCNVector3 {
        return self * -1
    }
    
    /**
     * Negates the vector described by SCNVector3
     */
    mutating func negated() -> SCNVector3 {
        self = negate()
        return self
    }
    
    /**
     * Calculates the distance between two SCNVector3. Pythagoras!
     */
    func distance(vector: SCNVector3) -> Float {
        return (self - vector).length()
    }
    
    /**
     * Calculates the dot product between two SCNVector3.
     */
    func dot(vector: SCNVector3) -> Float {
        return Float(x * vector.x + y * vector.y + z * vector.z)
    }
    
    /**
     * Calculates the cross product between two SCNVector3.
     */
    func cross(vector: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x)
    }
    
    func perpendicular() -> SCNVector3 {
        return SCNVector3Make(-z, y, x)
    }
    
    mutating func truncate(max:Float) -> SCNVector3 {
        if (length() > max) {
            self = normalized()
            self = self * max
        }
        return self
    }
    
    func angleBetween(vector:SCNVector3) -> Float {
        let dot = self.dot(vector:vector)
        let lengthA = self.length()
        let lengthB = vector.length()
        
        // Now to find the angle
        let theta = acos( dot / (lengthA * lengthB) )
        return theta
    }
    
    func angleBetweenInDegrees(vector:SCNVector3) -> Float {
        let theta = self.angleBetween(vector:vector)
        return theta * 180 / Float.pi
    }
}

/**
 * Adds two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

/**
 * Increments a SCNVector3 with the value of another.
 */
func += ( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

/**
 * Subtracts two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

/**
 * Decrements a SCNVector3 with the value of another.
 */
func -= ( left: inout SCNVector3, right: SCNVector3) {
    left = left - right
}

/**
 * Multiplies two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

/**
 * Is equal with another.
 */
func == ( left: SCNVector3, right: SCNVector3) -> Bool {
    return (left.x==right.x) && (left.y==right.y) && (left.z==right.z)
}

/**
* Is not equal with another.
*/
func != ( left: SCNVector3, right: SCNVector3) -> Bool {
    return !((left.x==right.x) && (left.y==right.y) && (left.z==right.z))
}

/**
 * Multiplies a SCNVector3 with another.
 */
func *= ( left: inout SCNVector3, right: SCNVector3) {
    left = left * right
}

/**
 * Multiplies the x, y and z fields of a SCNVector3 with the same scalar value and
 * returns the result as a new SCNVector3.
 */
func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x * SCNFloat(scalar), vector.y * SCNFloat(scalar), vector.z * SCNFloat(scalar))
}

/**
 * Multiplies the x and y fields of a SCNVector3 with the same scalar value.
 */
func *= ( vector: inout SCNVector3, scalar: Float) {
    vector = vector * scalar
}

/**
 * Divides two SCNVector3 vectors abd returns the result as a new SCNVector3
 */
func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 * Divides a SCNVector3 by another.
 */
func /= ( left: inout SCNVector3, right: SCNVector3) {
    left = left / right
}

/**
 * Divides the x, y and z fields of a SCNVector3 by the same scalar value and
 * returns the result as a new SCNVector3.
 */
func / (vector: SCNVector3, scalar: SCNFloat) -> SCNVector3 {
    return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}


/**
 * Negate a vector
 */
func SCNVector3Negate(vector: SCNVector3) -> SCNVector3 {
    return vector * -1
}

/**
 * Returns the length (magnitude) of the vector described by the SCNVector3
 */
func SCNVector3Length(vector: SCNVector3) -> Float
{
    return sqrtf(Float(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z))
}

/**
 * Returns the distance between two SCNVector3 vectors
 */
func SCNVector3Distance(vectorStart: SCNVector3, vectorEnd: SCNVector3) -> Float {
    return SCNVector3Length(vector: vectorEnd - vectorStart)
}


/**
 * Calculates the dot product between two SCNVector3 vectors
 */
func SCNVector3DotProduct(left: SCNVector3, right: SCNVector3) -> Float {
    return Float(left.x * right.x + left.y * right.y + left.z * right.z)
}

/**
 * Calculates the cross product between two SCNVector3 vectors
 */
func SCNVector3CrossProduct(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.y * right.z - left.z * right.y, left.z * right.x - left.x * right.z, left.x * right.y - left.y * right.x)
}

