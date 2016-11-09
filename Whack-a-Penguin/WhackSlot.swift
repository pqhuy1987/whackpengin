//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by Alex on 6/18/16.
//  Copyright © 2016 Alex Barcenas. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    // The node for the peguin.
    var charNode: SKSpriteNode!
    // The visibility of the penguin.
    var visible = false
    // Keeps track of whether or not the penguin has been hit.
    var isHit = false
    
    /*
     * Function Name: configureAtPosition
     * Parameters: pos - the position that the WhackSlot will be placed.
     * Purpose: This method creates a WhackSlot at the specified position that is passed to the method and
     *   also creates a peguin for the slot as well.
     * Return Value: None
     */
    
    func configureAtPosition(_ pos: CGPoint) {
        position = pos
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    /*
     * Function Name: show
     * Parameters: hideTime - helps determine the amount of time until the penguin hides again.
     * Purpose: This method reveals a hidden penguin and randomly chooses what type of penguin it will be.
     *   After a delay, the penguin will hide itself again.
     * Return Value: None
     */
    
    func show(hideTime: Double) {
        if visible { return }
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        visible = true
        isHit = false
        
        if RandomInt(min: 0, max: 2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        RunAfterDelay(hideTime * 3.5) { [unowned self] in
            self.hide()
        }
    }
    
    /*
     * Function Name: hide
     * Parameters: None
     * Purpose: This method hides a revealed penguin.
     * Return Value: None
     */
    
    func hide() {
        if !visible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y:-80, duration:0.05))
        visible = false
    }
    
    /*
     * Function Name: hit
     * Parameters: None
     * Purpose: This method hides a revealed penguin that has been hit by the user.
     * Return Value: None
     */
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y:-80, duration:0.5)
        let notVisible = SKAction.run { [unowned self] in self.visible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
}
