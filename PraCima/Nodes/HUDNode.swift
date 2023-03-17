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
    
    private var scoreTitleLbl: SKLabelNode!
    private var scoreLbl: SKLabelNode!
    private var highscoreTitleLbl: SKLabelNode!
    private var highscoreLbl: SKLabelNode!
    
    private var continueNode: SKSpriteNode!
    private var nextNode: SKSpriteNode!
    
    var easeScene: GameScene?
    var skView: SKView!
    
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
    
    private var isContinue = false {
        didSet {
            updateBtn(node: continueNode, event: isContinue)
        }
    }
    
    private var isNext = false {
        didSet {
            updateBtn(node: nextNode, event: isNext)
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
        
        if node.name == "Continue" && !isContinue {
            isContinue = true
        }
        
        if node.name == "Next" && !isNext {
            isNext = true
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
            
            if let _ = easeScene {
                let scene = GameScene(size: CGSize(width: screenWidth, height: screenHeight))
                scene.scaleMode = .aspectFill
                skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
            }
        }
        
        if isContinue {
            isContinue = false
            removeNode()
        }
        
        if isNext {
            isNext = false
            
            if let _ = easeScene {
                //let scene = GameScene(size: CGSize(width: screenWidth, height: screenHeight))
                //scene.scaleMode = .aspectFill
                //skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
            }
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
        
        if let parent = continueNode?.parent {
            isContinue = continueNode.contains(touch.location(in: parent))
        }
        
        if let parent = nextNode?.parent {
            isNext = nextNode.contains(touch.location(in: parent))
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
    
    private func removeNode() {
        gameOverShape?.removeFromParent()
        gameOverNode?.removeFromParent()
        continueNode?.removeFromParent()
        nextNode?.removeFromParent()
    }
}
 

// MARK: - GameOver
extension HUDNode {
    
    private func createGameOverShape() {
        gameOverShape = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight))
        gameOverShape.zPosition = 49.0
        gameOverShape.fillColor = UIColor(hex: 0x000000, alpha: 0.7)
        addChild(gameOverShape)
    }
    
    private func createGamePanel(_ name: String) {
        let scale: CGFloat = appDL.isIphoneX ? 0.6 : 0.7
        
        // TODO: - GameOverNode
        gameOverNode = SKSpriteNode(imageNamed: name)
        gameOverNode.setScale(scale)
        gameOverNode.zPosition = 50.0
        gameOverNode.position = CGPoint(x: screenWidth/2, y: screenHeight/2)
        addChild(gameOverNode)
    }
    
    func setupGameOver(_ score: Int, _ highscore: Int) {
        createGameOverShape()
        
        isUserInteractionEnabled = true
        let scale: CGFloat = appDL.isIphoneX ? 0.6 : 0.7
        
        // TODO: - GameOverNode
        createGamePanel("panel-gameOver")
        
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
        
        // TODO: - ScoreTitleLbl
        scoreTitleLbl = SKLabelNode(fontNamed: FontName.wheaton)
        scoreTitleLbl.fontSize = 60.0
        scoreTitleLbl.text = "Score: "
        scoreTitleLbl.fontColor = .white
        scoreTitleLbl.zPosition = 55.0
        scoreTitleLbl.position = CGPoint(
            x: gameOverNode.frame.minX + scoreTitleLbl.frame.width / 2 + 30,
            y: screenHeight / 2
        )
        addChild(scoreTitleLbl)
        
        // TODO: - ScoreLbl
        scoreLbl = SKLabelNode(fontNamed: FontName.wheaton)
        scoreLbl.fontSize = 60.0
        scoreLbl.text = "\(score)"
        scoreLbl.fontColor = .white
        scoreLbl.zPosition = 55.0
        scoreLbl.position = CGPoint(
            x: gameOverNode.frame.maxX - scoreLbl.frame.width / 2 - 30,
            y: scoreTitleLbl.position.y
        )
        addChild(scoreLbl)
        
        // TODO: - HighScoreTitleLbl
        highscoreTitleLbl = SKLabelNode(fontNamed: FontName.wheaton)
        highscoreTitleLbl.fontSize = 60.0
        highscoreTitleLbl.text = "HighScore: "
        highscoreTitleLbl.fontColor = .white
        highscoreTitleLbl.zPosition = 55.0
        highscoreTitleLbl.position = CGPoint(
            x: gameOverNode.frame.minX + highscoreTitleLbl.frame.width / 2 + 30,
            y: screenHeight / 2 - highscoreTitleLbl.frame.height * 2
        )
        addChild(highscoreTitleLbl)
        
        // TODO: - HighScoreTitleLbl
        highscoreLbl = SKLabelNode(fontNamed: FontName.wheaton)
        highscoreLbl.fontSize = 60.0
        highscoreLbl.text = "\(highscore)"
        highscoreLbl.fontColor = .white
        highscoreLbl.zPosition = 55.0
        highscoreLbl.position = CGPoint(
            x: gameOverNode.frame.maxX - highscoreLbl.frame.width / 2 - 30,
            y: highscoreTitleLbl.position.y
        )
        addChild(highscoreLbl)
    }
}


// MARK: - Success
extension HUDNode {
    func setupSuccess() {
        createGameOverShape()
        
        isUserInteractionEnabled = true
        let scale: CGFloat = appDL.isIphoneX ? 0.6 : 0.7
        
        // TODO: - GameOverNode
        createGamePanel("panel-success")
        
        // TODO: - ContinueNode
        continueNode = SKSpriteNode(imageNamed: "icon-continue")
        continueNode.setScale(scale)
        continueNode.zPosition = 55.0
        continueNode.position = CGPoint(
            x: gameOverNode.frame.minX + continueNode.frame.width / 2 + 30,
            y: gameOverNode.frame.minY + continueNode.frame.height / 2 + 30
        )
        continueNode.name = "Continuar"
        addChild(continueNode)
        
        // TODO: - NextNode
        nextNode = SKSpriteNode(imageNamed: "icon-next")
        nextNode.setScale(scale)
        nextNode.zPosition = 55.0
        nextNode.position = CGPoint(
            x: gameOverNode.frame.maxX - nextNode.frame.width / 2 -  30,
            y: gameOverNode.frame.minY + nextNode.frame.height / 2 + 30
        )
        nextNode.name = "Próximo"
        addChild(nextNode)
    }
}
