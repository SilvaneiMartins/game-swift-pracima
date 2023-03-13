//
//  WallNode.swift
//  PraCima
//
//  Created by Silvanei  Martins on 13/03/23.
//

import SpriteKit

class WallNode: SKNode {
    // MARK: - Properties
    
    private var node: SKSpriteNode!
    
    // MARK: - Initializes
    override init() {
        super.init()
        self.name = "Wall"
        self.zPosition = 5.0
        
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Setups
extension WallNode {
    private func setupPhysics() {
        let size = CGSize(width: screenWidth, height: 40.0)
        node = SKSpriteNode(color: .red, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.mass = 100.0
        node.physicsBody?.restitution = 1.0
        node.physicsBody?.categoryBitMask = 0
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
}
