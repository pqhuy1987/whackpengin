//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by Alex on 6/18/16.
//  Copyright (c) 2016 Alex Barcenas. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Keeps track of the number of rounds that have been played.
    var numRounds = 0
    // Keeps track of how fast enemies are made.
    var popupTime = 0.85
    // The WhackSlots that have been created.
    var slots = [WhackSlot]()
    // The label displaying the user's score.
    var gameScore: SKLabelNode!
    // Keeps track of the user's score.
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    /*
     * Function Name: didMoveToView
     * Parameters: view - the view that called this method.
     * Purpose: This method sets up the visual environment of the game and starts the game by creating
     *   enemies after a time delay.
     * Return Value: None
     */
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 140)) }
        
        RunAfterDelay(1) { [unowned self] in
            self.createEnemy()
        }
    }
    
    /*
     * Function Name: touchesBegan
     * Parameters: touches - the touches that occurred and are associated with the method call.
     *   event - the event the touches belong to.
     * Purpose: This method handles when the user taps within the game. Visible peguins will be hidden
     *   when they are tapped and the score will be updated depending on what type of penguin they are.
     *   A sound will also be played depending on what type of penguin they are.
     * Return Value: None
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            
            for node in nodes {
                // The user has whacked the wrong penguin.
                if node.name == "charFriend" {
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.visible { continue }
                    if whackSlot.isHit { continue }
                    
                    whackSlot.hit()
                    score -= 5
                    
                    run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
                }
                // The user has whacked the correct penguin.
                else if node.name == "charEnemy" {
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.visible { continue }
                    if whackSlot.isHit { continue }
                    
                    whackSlot.charNode.xScale = 0.85
                    whackSlot.charNode.yScale = 0.85
                    
                    whackSlot.hit()
                    score += 1
                    
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
                }
            }
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    /*
     * Function Name: createSlotAt
     * Parameters: pos - the position that the WhackSlot will be placed.
     * Purpose: This method calls a method to create a WhackSlot and displays that slot in the scene.
     * Return Value: None
     */
    
    func createSlotAt(_ pos: CGPoint) {
        let slot = WhackSlot()
        slot.configureAtPosition(pos)
        addChild(slot)
        slots.append(slot)
    }
    
    /*
     * Function Name: createEnemy
     * Parameters: None
     * Purpose: This method randomly chooses five slots and makes enemies appear in at least one of those
     *   slots. The method calls itself after a delay. This method will also cause a game over if the method
     *   has been called 30 times already.
     * Return Value: None
     */
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            return
        }
        
        popupTime *= 0.991
        
        slots = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: slots) as! [WhackSlot]
        slots[0].show(hideTime: popupTime)
        
        if RandomInt(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 8 {    slots[2].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime)    }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        
        RunAfterDelay(RandomDouble(min: minDelay, max: maxDelay)) { [unowned self] in
            self.createEnemy()
        }
    }
}
