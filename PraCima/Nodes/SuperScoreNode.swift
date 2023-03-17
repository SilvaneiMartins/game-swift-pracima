//
//  SuperScoreNode.swift
//  PraCima
//
//  Created by Silvanei  Martins on 16/03/23.
//

import SpriteKit

class SuperScoreNode: SKNode {
    // MARK: - Properties
    
    private var node: SKSpriteNode!
    private let radius: CGFloat = 35.0
    private let scale: CGFloat = 0.5
    
    // MARK: - Initializes
    override init() {
        super.init()
        self.name = "SuperScore"
        self.zPosition = 10.0
        
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Setups
extension SuperScoreNode {
    private func setupPhysics() {
        node = SKSpriteNode(imageNamed: "icon-star")
        node.name = "SuperScore"
        node.setScale(scale)
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius * 0.8)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = PhysicsCategories.SuperScore
        addChild(node)
    }
}
