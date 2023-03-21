//
//  HardScene.swift
//  PraCima
//
//  Created by Silvanei  Martins on 21/03/23.
//

import SpriteKit
import GameplayKit

class HardScene: SKScene {
    
    // MARK: - Properties
    
    private let worldNode = SKNode()
    private var bgNode: SKSpriteNode!
    private let hudNode = HUDNode()
    
    private let playerNode = PlayerNode(diff: 0)
    private let wallNode = WallNode()
    private let leftNode = SideNode()
    private let rightNode = SideNode()
    private let obstaclesNode = SKNode()
    
    var firstTap = true
    private var posY: CGFloat = 0.0
    private var pairNum = 0
    private var score = 0
    
    lazy var colors: [ColorModel] = {
        return ColorModel.share()
    }()
    
    private let jumpSound = SKAction.playSoundFileNamed(SoundName.jump, waitForCompletion: false)
    private let superScoreSound = SKAction.playSoundFileNamed(SoundName.superScore, waitForCompletion: false)
    private let btnSound = SKAction.playSoundFileNamed(SoundName.btn, waitForCompletion: false)
    private let scoreSound = SKAction.playSoundFileNamed(SoundName.score, waitForCompletion: false)
    private let collisionSound = SKAction.playSoundFileNamed(SoundName.collision, waitForCompletion: false)
    
    private let notifyKey = "HardNotifyKey"
    private let scoreKey = "HardScoreKey"
    
    private let requestScore = 20
    private let btnName = "icon-continue"
    private let titleTxt = "Muito bom!!!"
    private let subTxt = """
Faltam 20 pontos para
VITÓRIA
"""
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        
        if firstTap {
            playerNode.activate(true)
            firstTap = false
        }
        
        let location = touch.location(in: self)
        let right = !(location.x > frame.width / 2)
        
        playerNode.jump(right)
        run(jumpSound)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if -playerNode.height() + frame.midY < worldNode.position.y {
            worldNode.position.y = -playerNode.height() + frame.midY
        }
        
        if posY - playerNode.height() < frame.midY {
            addObstacles()
        }
        
        obstaclesNode.children.forEach({
            let i = score - 2
            if $0.name == "Pair \(i)" {
                $0.removeFromParent()
                print("removeFromParent")
            }
        })
    }
}


// MARK: - Setups

extension HardScene {
    private func setupNodes() {
        backgroundColor = .white
        setupPhysics()
        
        // TODO: - BackgroundNode
        addBG()
        
        // TODO: - HUDNode
        addChild(hudNode)
        hudNode.skView = view
        hudNode.hardScene = self
        
        if !UserDefaults.standard.bool(forKey: notifyKey) {
            UserDefaults.standard.set(true, forKey: notifyKey)
            hudNode.setupPanel(subTxt: subTxt, titleTxt: titleTxt, btnName: btnName)
        }
        
        
        // TODO: - WorldNode
        addChild(worldNode)
        
        // TODO: - PlayerNode
        playerNode.position = CGPoint(x: frame.midX, y: frame.midY * 0.6)
        worldNode.addChild(playerNode)
        
        // TODO: - WallNode
        addWall()
        
        // TODO: - ObstaclesNode
        worldNode.addChild(obstaclesNode)
        addObstacles()
        posY = frame.midY
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -15.0)
        physicsWorld.contactDelegate = self
    }
}

// MARK: - BackgroundNode
extension HardScene {
    private func addBG() {
        bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgNode)
    }
}

// MARK: - WallNode
extension HardScene {
    private func addWall() {
        wallNode.position = CGPoint(x: frame.midX, y: 0.0)
        leftNode.position = CGPoint(x: playableRect.minX, y: frame.midY)
        rightNode.position = CGPoint(x: playableRect.maxX, y: frame.midY)
        
        addChild(wallNode)
        addChild(leftNode)
        addChild(rightNode)
    }
}

// MARK: - ObstaclesNode
extension HardScene {
    private func addObstacles() {
        let model = colors[Int(arc4random_uniform(UInt32(colors.count - 1)))]
        let model_1 = colors[Int(arc4random_uniform(UInt32(colors.count - 1)))]
        let randomX = CGFloat(arc4random() % UInt32(playableRect.width / 2))
        
        let piperPair = SKNode()
        piperPair.position = CGPoint(x: 0.0, y: posY)
        piperPair.zPosition = 1.0
        
        pairNum += 1
        piperPair.name = "Pair\(pairNum)"
        
        let size = CGSize(width: screenWidth, height: 50.0)
        let pipe_1 = SKSpriteNode(color: model.color, size: size)
        pipe_1.position = CGPoint(x: randomX - 270, y: 0.0)
        pipe_1.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe_1.physicsBody?.isDynamic = false
        pipe_1.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        let pipe_2 = SKSpriteNode(color: model.color, size: size)
        pipe_2.position = CGPoint(x: pipe_1.position.x + size.width + 270, y: 0.0)
        pipe_2.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe_2.physicsBody?.isDynamic = false
        pipe_2.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        let blockSize = CGSize(width: 30.0, height: 30.0)
        if piperPair.name != "Pair1" {
            let random = CGFloat(arc4random() % 4)
            let block = SKSpriteNode(color: model_1.color, size: blockSize)
            block.position = CGPoint(
                x: pipe_1.frame.maxX + ((random + 1) * 30),
                y: pipe_1.position.y + 170
            )
            block.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
            block.physicsBody?.isDynamic = false
            block.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
            piperPair.addChild(block)
            
            let pos = block.position.x < playableRect.width / 2 ? block.position.x + 150 : block.position.x - 150
            let moveAct_1 = SKAction.moveTo(x: pos < playableRect.width / 2 ? pos + 250 : pos - 250, duration: 1.5)
            let moveAct_2 = SKAction.moveTo(x: pos, duration: 1.5)
            block.run(.repeatForever(.sequence([moveAct_1, moveAct_2])))
        }
        
        let score = SKNode()
        score.position = CGPoint(x: 0.0, y: size.height)
        score.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: size.height))
        score.physicsBody?.isDynamic = false
        score.physicsBody?.categoryBitMask = PhysicsCategories.Score
        
        piperPair.addChild(pipe_1)
        piperPair.addChild(pipe_2)
        piperPair.addChild(score)
        
        obstaclesNode.addChild(piperPair)
        
        switch arc4random_uniform(100) {
        case 0...80: break
        default: addSuperScore()
        }
        
        posY += frame.midY * 0.7
    }
    
    private func addSuperScore() {
        let node = SuperScoreNode()
        let randomX = playableRect.midX + CGFloat(arc4random_uniform(UInt32(playableRect.width / 2))) + node.frame.width
        let randomY = posY + CGFloat(arc4random_uniform(UInt32(posY * 0.5))) + node.frame.height
        node.position = CGPoint(x: randomX, y: randomY)
        
        worldNode.addChild(node)
        node.bounce()
    }
}

// MARK: - GameState
extension HardScene {
    private func gameOver() {
        playerNode.over()
        
        var highscore = UserDefaults.standard.integer(forKey: scoreKey)
        if score > highscore {
            highscore = score
        }
        
        hudNode.setupGameOver(score, highscore)
        run(collisionSound)
    }
    
    private func success() {
        if score >= requestScore {
            playerNode.activate(false)
            hudNode.setupSuccess()
        }
    }
}

// MARK: - SKPhysicsContactDelegate
extension HardScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let body = contact.bodyA.categoryBitMask == PhysicsCategories.Player ? contact.bodyB : contact.bodyA
        
        switch body.categoryBitMask {
        case PhysicsCategories.Wall:
            gameOver()
        case PhysicsCategories.Side:
            playerNode.side()
        case PhysicsCategories.Obstacles:
            gameOver()
        case PhysicsCategories.Score:
            if let node = body.node {
                score += 1
                hudNode.updateScore(score)
                
                let highscore = UserDefaults.standard.integer(forKey: scoreKey)
                if score > highscore {
                    UserDefaults.standard.set(score, forKey: scoreKey)
                }
                
                run(scoreSound)
                
                node.removeFromParent()
                success()
            }
        case PhysicsCategories.SuperScore:
            if let node = body.node {
                score += 5
                hudNode.updateScore(score)
                
                let highscore = UserDefaults.standard.integer(forKey: scoreKey)
                if score > highscore {
                    UserDefaults.standard.set(score, forKey: scoreKey)
                }
                
                run(superScoreSound)
                
                node.removeFromParent()
                success()
            }
        default: break
        }
    }
}
