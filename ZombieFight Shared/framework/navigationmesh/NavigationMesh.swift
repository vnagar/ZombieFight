//
//  NavigationMesh.swift
//  NavmeshTest
//
//  Created by Vivek Nagar on 1/26/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit
import GameplayKit

class NavigationMesh {
    private let baseNode:SCNNode
    private let scene:SCNScene
    private var vertices = [SCNVector3](); // A new array for vertices
    private var indicies = [Int]()
    private var polygons = [NavigationMeshPolygon]()
    private var graph:NavigationMeshGraph?
    
    init(scene:SCNScene, node:SCNNode) {
        //Base node is the "Navmesh" node loaded from blender
        self.baseNode = node
        self.scene = scene
        let source = baseNode.geometry!.sources[0] // Decode vertices
        let element = baseNode.geometry!.elements[0] // Decode indexes
        vertices = decodeData(vertexSource: source)
        indicies = decodeElement(elementData: element)
        polygons = createNavigationMeshPolygons()
        self.graph = NavigationMeshGraph(polygons:polygons)
    }
    
    func findPathBetweenNodes(fromNode:SCNNode, toNode:SCNNode) -> [float3] {
        let from = float3(fromNode.position)
        let to = float3(toNode.position)
        return findPathBetweenPoints(fromPoint: from, toPoint: to)
    }
    
    func findPathBetweenPoints(fromPoint:float3, toPoint:float3) -> [float3] {
        let toGraphNode = NavigationMeshGraphNode(point: float2(Float(toPoint.x), Float(toPoint.z)))
        let fromGraphNode = NavigationMeshGraphNode(point: float2(Float(fromPoint.x), Float(fromPoint.z)))
        
        graph?.connectNodeToClosestPointOnNavigationMesh(node: toGraphNode)
        graph?.connectNodeToClosestPointOnNavigationMesh(node: fromGraphNode)
        
        var pathVectors = [float3]()
        
        if let path = graph?.findPath(from: fromGraphNode, to: toGraphNode) {
            for p in path {
                let node = p as! GKGraphNode2D
                let position = float3(node.position.x, 1.0, node.position.y)
                pathVectors.append(position)
            }
        }
        
        return pathVectors
    }
    
    func findPathBetweenPoints(fromPoint:SCNVector3, toPoint:SCNVector3) -> [SCNVector3] {
        let toGraphNode = NavigationMeshGraphNode(point: float2(Float(toPoint.x), Float(toPoint.z)))
        let fromGraphNode = NavigationMeshGraphNode(point: float2(Float(fromPoint.x), Float(fromPoint.z)))
        
        graph?.connectNodeToClosestPointOnNavigationMesh(node: toGraphNode)
        graph?.connectNodeToClosestPointOnNavigationMesh(node: fromGraphNode)
        
        var pathVectors = [SCNVector3]()
        
        if let path = graph?.findPath(from: fromGraphNode, to: toGraphNode) {
            for p in path {
                let node = p as! GKGraphNode2D
                let position = SCNVector3(node.position.x, 0.0, node.position.y)
                pathVectors.append(position)
            }
        }
        return pathVectors
    }
    
    func drawMesh() {
        for i in stride(from: 0, to: indicies.count - 1, by: 3) {
            let a = indicies[i]
            let b = indicies[i+1]
            let c = indicies[i+2]
            
            let geo = SCNGeometry.triangleFrom(vector1: vertices[a], vector2: vertices[b], vector3: vertices[c])
            let triangleNode = SCNNode()
            triangleNode.geometry = geo
            
            let color = SKColor(red: CGFloat(4*i)/255.0, green: CGFloat(3*i)/255.0, blue: CGFloat(2*i)/255.0, alpha: 1.0)
            triangleNode.geometry?.firstMaterial?.diffuse.contents = color
            scene.rootNode.addChildNode(triangleNode)
        }
    }
    
    private func createNavigationMeshPolygons() -> [NavigationMeshPolygon] {
        var polys = [NavigationMeshPolygon]()
        for i in stride(from: 0, to: indicies.count - 1, by: 3) {
            let a = indicies[i]
            let b = indicies[i+1]
            let c = indicies[i+2]
            
            let pointA = float2(Float(vertices[a].x), Float(vertices[a].z))
            let pointB = float2(Float(vertices[b].x), Float(vertices[b].z))
            let pointC = float2(Float(vertices[c].x), Float(vertices[c].z))

            let p = NavigationMeshPolygon(points:[pointA, pointB, pointC])
            polys.append(p)
        }
        return polys
    }
    
    private func decodeData(vertexSource:SCNGeometrySource) -> [SCNVector3] {
        var decodedVertices = [SCNVector3](); // A new array for vertices
        
        let stride = vertexSource.dataStride; // in bytes
        let offset = vertexSource.dataOffset; // in bytes
        
        let componentsPerVector = vertexSource.componentsPerVector;
        let bytesPerVector = componentsPerVector * vertexSource.bytesPerComponent;
        let vectorCount = vertexSource.vectorCount;
        
        // for each vector, read the bytes
        for i in 0...vectorCount-1 {
            // The range of bytes for this vector
            let byteRange = NSMakeRange(i*stride + offset, // Start at current stride + offset
                bytesPerVector);   // and read the lenght of one vector
            
            // Assuming that bytes per component is 4 (a float)
            // If it was 8 then it would be a double (aka CGFloat)
            var vectorData = [Float](repeating:0.0, count:componentsPerVector)
            // Read into the vector data buffer
            //[vertexSource.data getBytes:&vectorData range:byteRange];
            let nsData = NSData(data:vertexSource.data)
            nsData.getBytes(&vectorData, range: byteRange)
            
            // At this point you can read the data from the float array
            let x = vectorData[0];
            let y = vectorData[1];
            let z = vectorData[2];
            
            decodedVertices.append(SCNVector3Make(SCNFloat(x), SCNFloat(y), SCNFloat(z)))
        }
        return decodedVertices
    }
    
    private func decodeElement(elementData:SCNGeometryElement) -> [Int] {
        //Return the array of indices of vertices in order
        var indexes = [Int]()
        let bytesPerVector = 1
        let numberInEachPrimitive = 3
        
        // for each vector, read the bytes
        for i in  0...elementData.primitiveCount*numberInEachPrimitive-1 {
            // The range of bytes for this vector
            let byteRange = NSMakeRange(i, bytesPerVector);   // and read the length of one vector
            
            var index:Int = 0
            // Read into the vector data buffer
            let nsData = NSData(data:elementData.data)
            nsData.getBytes(&index, range: byteRange)
            
            indexes.append(index);
        }
        return indexes
    }
    
}

