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
    private let hudNode = HUDNode()
    
    private let playerNode = PlayerNode(diff: 0)
    private let wallNode = WallNode()
    private let leftNode = SideNode()
    private let rightNode = SideNode()
    private let obstaclesNode = SKNode()
    
    private var firstTap = true
    private var posY: CGFloat = 0.0
    private var pairNum = 0
    private var score = 0
    
    private let easeScoreKey = "EaseScoreKey"
    
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

extension GameScene {
    private func setupNodes() {
        backgroundColor = .white
        setupPhysics()
        
        // TODO: - BackgroundNode
        addBG()
        
        // TODO: - HUDNode
        addChild(hudNode)
        hudNode.skView = view
        hudNode.easeScene = self
        
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
extension GameScene {
    private func addBG() {
        bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgNode)
    }
}

// MARK: - WallNode
extension GameScene {
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
extension GameScene {
    private func addObstacles() {
        let piperPair = SKNode()
        piperPair.position = CGPoint(x: 0.0, y: posY)
        piperPair.zPosition = 1.0
        
        pairNum += 1
        piperPair.name = "Pair\(pairNum)"
        
        let size = CGSize(width: screenWidth, height: 50.0)
        let pipe_1 = SKSpriteNode(color: .black, size: size)
        pipe_1.position = CGPoint(x: -250, y: 0.0)
        pipe_1.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe_1.physicsBody?.isDynamic = false
        pipe_1.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        let pipe_2 = SKSpriteNode(color: .black, size: size)
        pipe_2.position = CGPoint(x: pipe_1.position.x + size.width + 250, y: 0.0)
        pipe_2.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe_2.physicsBody?.isDynamic = false
        pipe_2.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        let score = SKNode()
        score.position = CGPoint(x: 0.0, y: size.height)
        score.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: size.height))
        score.physicsBody?.isDynamic = false
        score.physicsBody?.categoryBitMask = PhysicsCategories.Score
        
        piperPair.addChild(pipe_1)
        piperPair.addChild(pipe_2)
        piperPair.addChild(score)
        
        obstaclesNode.addChild(piperPair)
        posY += frame.midY * 0.7
    }
}

// MARK: - GameOver
extension GameScene {
    private func gameOver() {
        playerNode.over()
        
        var highscore = UserDefaults.standard.integer(forKey: easeScoreKey)
        if score > highscore {
            highscore = score
        }
        
        hudNode.setupGameOver(score, score)
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let body = contact.bodyA.categoryBitMask == PhysicsCategories.Player ? contact.bodyB : contact.bodyA
        
        switch body.categoryBitMask {
        case PhysicsCategories.Wall:
            gameOver()
        case PhysicsCategories.Side:
            playerNode.side()
        case PhysicsCategories.Obstacles:
            //gameOver()
            print("Obstacles")
        case PhysicsCategories.Score:
            if let node = body.node {
                score += 1
                hudNode.updateScore(score)
                
                let highscore = UserDefaults.standard.integer(forKey: easeScoreKey)
                if score > highscore {
                    UserDefaults.standard.set(score, forKey: easeScoreKey)
                }
                
                node.removeFromParent()
            }
        default: break
        }
    }
}
