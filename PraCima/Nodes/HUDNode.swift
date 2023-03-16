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
    
    private var gameOverShape: SKShapeNode!
    private var gameOverNode: SKSpriteNode!
    
    private var homeNode: SKSpriteNode!
    private var againNode: SKSpriteNode!
    
    private var isHome = false {
        didSet {
            updateBtn(node: homeNode, event: isHome)
        }
    }
    
    private var isAgain = false {
        didSet {
            updateBtn(node: againNode, event: isAgain)
        }
    }
    
    // MARK: - Initializes
    override init() {
        super.init()
        self.setupTopScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        
        if node.name == "Home" && !isHome {
            isHome = true
        }
        
        if node.name == "PlayAgain" && !isAgain {
            isAgain = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isHome {
            isHome = false
            print("Home")
        }
        
        if isAgain {
            isAgain = false
            print("PlayAgain")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let parent = homeNode?.parent {
            isHome = homeNode.contains(touch.location(in: parent))
        }
        
        if let parent = againNode?.parent {
            isAgain = againNode.contains(touch.location(in: parent))
        }
    }
}

// MARK: - Setups
extension HUDNode {
    private func updateBtn(node: SKNode, event: Bool) {
        var alpha: CGFloat = 1.0
        if event {
            alpha = 0.5
        }
        
        node.run(.fadeAlpha(to: alpha, duration: 0.1))
    }
    
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
    func setupGameOver() {
        gameOverShape = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight))
        gameOverShape.zPosition = 49.0
        gameOverShape.fillColor = UIColor(hex: 0x000000, alpha: 0.7)
        addChild(gameOverShape)
        
        isUserInteractionEnabled = true
        let scale: CGFloat = appDL.isIphoneX ? 0.6 : 0.7
        
        // TODO: - GameOverNode
        gameOverNode = SKSpriteNode(imageNamed: "panel-gameOver")
        gameOverNode.setScale(scale)
        gameOverNode.zPosition = 50.0
        gameOverNode.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        addChild(gameOverNode)
        
        // TODO: - HomeNode
        homeNode = SKSpriteNode(imageNamed: "icon-home")
        homeNode.setScale(scale)
        homeNode.zPosition = 55.0
        homeNode.position = CGPoint(
            x: gameOverNode.frame.minX + homeNode.frame.width / 2 + 30,
            y: gameOverNode.frame.minY + homeNode.frame.height / 2 + 30
        )
        homeNode.name = "Home"
        addChild(homeNode)
        
        // TODO: - PlayerAgainNode
        againNode = SKSpriteNode(imageNamed: "icon-playAgain")
        againNode.setScale(scale)
        againNode.zPosition = 55.0
        againNode.position = CGPoint(
            x: gameOverNode.frame.maxX - homeNode.frame.width / 2 -  30,
            y: gameOverNode.frame.minY + homeNode.frame.height / 2 + 30
        )
        againNode.name = "PlayAgain"
        addChild(againNode)
    }
}
