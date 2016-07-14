//
//  GameScene.swift
//  9.81
//
//  Created by Michael Hsieh on 7/11/16.
//  Copyright (c) 2016 Michael Hsieh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var scrollLayer: SKNode!
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 360
    var obstacleLayer: SKNode!
    var spawnTimer: CFTimeInterval = 0
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        scrollLayer = self.childNodeWithName("scrollLayer")
        obstacleLayer = self.childNodeWithName("obstacleLayer")

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        scrollWorld()
    }
    
    func scrollWorld() {
        /* Scroll World */
        scrollLayer.position.y += scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for sky in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let skyPosition = scrollLayer.convertPoint(sky.position, toNode: self)
            
            /* Check if ground sprite has left the scene */
            if skyPosition.y >= (sky.size.height / 2) + self.size.height {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPointMake( skyPosition.x, -(self.size.height / 2))
                
                /* Convert new node position back to scroll layer space */
                sky.position = self.convertPoint(newPosition, toNode: scrollLayer)
            }
        }
    }
    
    func updateObstacles() {
        /* Update Obstacles */
        
        obstacleLayer.position.y -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through obstacle layer nodes */
        for obstacle in obstacleLayer.children as! [SKReferenceNode] {
            
            /* Get obstacle node position, convert node position to scene space */
            let obstaclePosition = obstacleLayer.convertPoint(obstacle.position, toNode: self)
            
            /* Check if obstacle has left the scene */
            if obstaclePosition.y <= 0 {
                
                /* Remove obstacle node from obstacle layer */
                obstacle.removeFromParent()
            }
            
        }
        
    }
    
}
