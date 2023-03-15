//
//  HUDNode.swift
//  PraCima
//
//  Created by Silvanei  Martins on 14/03/23.
//

import SpriteKit

class HUDNode: SKNode {
    // MARK: - Properties
    
    private var topScoreShape: SKShapeNode!
    private var topScoreLbl: SKLabelNode!
    
    // MARK: - Initializes
    override init() {
        super.init()
        self.setupTopScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Setups
extension HUDNode {
    private func setupTopScore() {
        let statusH: CGFloat = appDL.isIphoneX ? 88 : 40
        let scoreY: CGFloat = screenHeight - (statusH + 90/2 + 20)
        
        topScoreShape = SKShapeNode(rectOf: CGSize(width: 220, height: 90), cornerRadius: 8.0)
        topScoreShape.fillColor = UIColor(hex: 0x000000, alpha: 0.5)
        topScoreShape.zPosition = 20.0
        topScoreShape.position = CGPoint(x: screenWidth/2, y: scoreY)
        addChild(topScoreShape)
        
        topScoreLbl = SKLabelNode(fontNamed: FontName.wheaton)
        topScoreLbl.fontSize = 60.0
        topScoreLbl.text = "0"
        topScoreLbl.fontColor = .white
        topScoreLbl.zPosition = 25.0
        topScoreLbl.position = CGPoint(x: topScoreShape.frame.midX, y: topScoreShape.frame.midY - topScoreLbl.frame.height/2)
        addChild(topScoreLbl)
    }
    
    func updateScore(_ score: Int) {
        topScoreLbl.text = "\(score)"
        topScoreLbl.run(.sequence([
            .scale(to: 1.3, duration: 0.1),
            .scale(to: 1.0, duration: 0.1),
        ]))
    }
}
 

// MARK: - GameOver
extension HUDNode {
     
}
