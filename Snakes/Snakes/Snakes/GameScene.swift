//
//  GameScene.swift
//  Snakes
//
//  Created by Hemang on 27/04/20.
//  Copyright © 2020 Hemang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    var company:SKLabelNode!
    var game: GameManager!
    
    var currentScore: SKLabelNode!
    var playerPositions: [(Int, Int)] = []
    var gameBG: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    
    var scorePos: CGPoint?
    
    
    
    override func didMove(to view: SKView) {
        initializeMenu()
        game = GameManager(scene: self)
        initializeGameView()
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        }
    
    @objc func swipeR() {
        game.swipe(ID: 3)
    }
    @objc func swipeL() {
        game.swipe(ID: 1)
    }
    @objc func swipeU() {
        game.swipe(ID: 2)
    }
    @objc func swipeD() {
        game.swipe(ID: 4)
    }
        

    
    override func update(_ currentTime: TimeInterval) {
        game.update(time: currentTime)
    }
    //3
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
            }
        }
    }
    
    //4
    private func startGame() {
        print("start game")
        gameLogo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
        self.gameLogo.isHidden = true
        }
        //2
        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }
        //3
        let bottomCorner = CGPoint(x: 0, y: (frame.size.height / -2) + 40)
        
        bestScore.run(SKAction.move(to: bottomCorner, duration: 0.4)) {
            self.gameBG.setScale(0)
        self.currentScore.setScale(0)
        self.gameBG.isHidden = false
        self.currentScore.isHidden = false
        self.gameBG.run(SKAction.scale(to: 1, duration: 0.4))
        self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
            self.game.initGame()
        }
    }
    
    
    private func initializeGameView() {
        //4
        currentScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        currentScore.zPosition = 1
        currentScore.position = CGPoint(x: 0, y: (frame.size.height / -2) + 80)
        currentScore.fontSize = 40
        currentScore.isHidden = true
        currentScore.text = "Score: 0"
        currentScore.fontColor = SKColor.white
        self.addChild(currentScore)
        //5
        let width = frame.size.width - 200
        let height = frame.size.height - 300
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        gameBG = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBG.fillColor = SKColor.darkGray
        gameBG.zPosition = 2
        gameBG.isHidden = true
        self.addChild(gameBG)
        //6
        createGameBoard(width: Int(Float(width)), height: Int(Float(height)))
    }
    
    private func createGameBoard(width: Int, height: Int) {
        let cellWidth: CGFloat = 27.3
        let numRows = 38
        let numCols = 20
        var x = CGFloat(width / -2) + (cellWidth / 2)
        var y = CGFloat(height / 2) - (cellWidth / 2)
        //loop through rows and columns, create cells
        for i in 0...numRows - 1 {
            for j in 0...numCols - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = SKColor.black
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
                //add to array of cells -- then add to game board
                gameArray.append((node: cellNode, x: i, y: j))
                gameBG.addChild(cellNode)
                //iterate x
                x += cellWidth
            }
            //reset x, iterate y
            x = CGFloat(width / -2) + (cellWidth / 2)
            y -= cellWidth
        }
    }
    //1
   
    //2
    
    //3
    private func initializeMenu() {
        //Create game title
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x:0, y: (frame.size.height / 2) - 600)
        gameLogo.fontSize = 60
        gameLogo.text = "SNAKES"
        gameLogo.fontColor = SKColor.red
        self.addChild(gameLogo)
        //Create best score label
        company = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        company.zPosition=1
        company.position = CGPoint(x:0,y:(frame.size.height/2)-120)
        company.fontSize=30
        company.text="HEMANG TECH"
        company.fontColor = SKColor.systemPink
        self.addChild(company)
        
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        //Create play button
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 600)
        playButton.fillColor = SKColor.green
        
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        
        playButton.path = path
        self.addChild(playButton)
    }
}
