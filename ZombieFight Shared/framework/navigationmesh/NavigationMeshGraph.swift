//
//  NavigationMesh.swift
//  GKGraphTest
//
//  Created by Vivek Nagar on 1/27/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import GameplayKit

class NavigationMeshGraph : GKGraph {
    // MARK: - Public properties
    /// The `NavigationMeshPolygon` objects that comprise the navigation mesh for the graph
    var polygons: [NavigationMeshPolygon] {
        didSet {
            resetNodesForPolygons()
        }
    }
    
    // MARK: - Initialization methods
    /// Initialize the graph with an array of polygons
    /// - parameter polygons The array of polygons to initialize with
    init(polygons: [NavigationMeshPolygon]) {
        self.polygons = polygons
        super.init()
        
        resetNodesForPolygons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func connectNodeToClosestPointOnNavigationMesh(node: GKGraphNode2D) {
        var minDistance = Float.greatestFiniteMagnitude
        var intersection: float2!
        var containingPolygon: NavigationMeshPolygon!
        
        let nodePoint = float2(node.position.x, node.position.y)
        for polygon in polygons {
            if polygon.contains(point: nodePoint) {
                intersection = nodePoint
                containingPolygon = polygon
                break
            }
            
            var lastPoint = polygon.points.last!
            for point in polygon.points {
                if let distanceAndIntersection = distanceSquaredAndIntersectionFromPoint(point: nodePoint, toLine: (p1: lastPoint, p2: point)) {
                    if distanceAndIntersection.distanceSquared < minDistance {
                        intersection = distanceAndIntersection.intersection
                        minDistance = distanceAndIntersection.distanceSquared
                        containingPolygon = polygon
                    }
                }
                lastPoint = point
            }
        }
        
        node.position = intersection
        node.addConnections(to: containingPolygon.graphNodes, bidirectional: true)
    }
    // MARK: - Private methods
    /// Sets up the `GKGraphNode`s that make up the graph based on the polygons
    private func resetNodesForPolygons() {
        if let nodes = nodes {
            remove(nodes)
        }
        var pointToNode: [String: GKGraphNode2D] = [:]
        for polygon in polygons {
            var lastPoint = polygon.points.last!
            
            var totalPoint = float2(0, 0)
            for point in polygon.points {
                addPoint(point: point, polygon: polygon, pointToNode: &pointToNode)
                
                let midPoint = float2((point.x + lastPoint.x) / 2.0, (point.y + lastPoint.y) / 2.0)
                addPoint(point: midPoint, polygon: polygon, pointToNode: &pointToNode)
                
                lastPoint = point
                totalPoint.x += point.x
                totalPoint.y += point.y
            }
            // Add the centroid
            addPoint(point: float2(totalPoint.x / Float(polygon.points.count), totalPoint.y / Float(polygon.points.count)), polygon: polygon, pointToNode: &pointToNode)
        }
    }
    
    private func addPoint(point: float2, polygon: NavigationMeshPolygon, pointToNode: inout [String: GKGraphNode2D]) {
        let graphNode: GKGraphNode2D
        if let node = pointToNode["\(point)"] {
            graphNode = node
        }
        else {
            graphNode = NavigationMeshGraphNode(point: point)
            add([graphNode])
        }
        graphNode.addConnections(to: polygon.graphNodes, bidirectional: true)
        polygon.graphNodes.append(graphNode)
        pointToNode["\(point)"] = graphNode
    }
    
    private func distanceSquaredAndIntersectionFromPoint(point: float2, toLine line: (p1: float2, p2: float2)) -> (distanceSquared: Float, intersection: float2)? {
        // This code is ported from: http://paulbourke.net/geometry/pointlineplane/
        let (l1, l2) = line
        let lineMagnitude = distance_squared(l1, l2)
        let u = (((point.x - l1.x) * (l2.x - l1.x) + (point.y - l1.y) * (l2.y - l1.y)) / lineMagnitude)
        if u < 0.0 || u > 1.0 {
            return nil
        }
        
        let intersection = float2(l1.x + u * (l2.x - l1.x), l1.y + u * (l2.y - l1.y))
        return (distanceSquared: distance_squared(point, intersection), intersection: intersection)
    }
}

class NavigationMeshGraphNode: GKGraphNode2D {
    // TODO: Revisit this? Find out why GKGraphNode2D's cost isn't related to distance as I thought it should be
    override func cost(to node: GKGraphNode) -> Float {
        //print("CALCULATING COST")
        guard let graphNode = node as? GKGraphNode2D else { return super.cost(to: node) }
        return distance_squared(position, graphNode.position)
    }
}

class NavigationMeshPolygon {
    /// The points that make up the polygon
    public let points: [float2]
    /// The graph nodes associated with this polygon
    public var graphNodes: [GKGraphNode2D] = []
    
    // MARK: - Initialization methods
    /// - parameter points The points that make up the polygon
    public init(points: [float2]) {
        self.points = points
    }
    
    func contains(point: float2) -> Bool {
        var pJ = points.last!
        var contains = false
        for pI in points {
            if ( ((pI.y >= point.y) != (pJ.y >= point.y)) &&
                (point.x <= (pJ.x - pI.x) * (point.y - pI.y) / (pJ.y - pI.y) + pI.x) ){
                contains = !contains
            }
            pJ=pI
        }
        return contains
    }
}


