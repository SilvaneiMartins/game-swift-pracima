//
//  GameScene.swift
//  PraCima
//
//  Created by Silvanei  Martins on 12/03/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    private let worldNode = SKNode()
    private var bgNode: SKSpriteNode!
    
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}


// MARK: - Setups

extension GameScene {
    private func setupNodes() {
        backgroundColor = .white
        
        // TODO: - BackgroundNode
        addBG()
        
        // TODO: - WorldNode
        addChild(worldNode)
    }
}

// MARK: - BackgroundNode
extension GameScene {
    private func addBG() {
        bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgNode)
    }
}
