//
//  PongModel.swift
//  pong
//
//  Created by Nassor, Hamad on 07/11/2024.
//

import Foundation

struct Paddle {
    let initialPosition: CGPoint
   
    var position: CGPoint
    let size: CGSize

    init(position: CGPoint, size: CGSize = CGSize(width: 75, height: 10)){
        self.initialPosition = position
        
        self.position = position
        self.size = size
    }
    
    mutating func updatePaddlePosition(bounds: CGRect, xPosition: CGFloat){
        position.x = min(xPosition, bounds.maxX - size.height)
    }
    
    mutating func reset(){
        position = initialPosition
    }
}

struct Ball {
    let initialPosition: CGPoint
    let initialVelocity: CGVector
    
    var position: CGPoint
    var size: CGSize
    var velocity: CGVector
    
    init(position: CGPoint, size: CGSize = CGSize(width: 20, height: 20), velocity: CGVector = CGVector(dx: 0, dy: 5)) {
        self.initialPosition = position
        self.initialVelocity = velocity
        
        self.position = position
        self.size = size
        self.velocity = velocity
    }
    
    mutating func updatePosition() {
        position.x += velocity.dx
        position.y += velocity.dy
    }
    
    func isOutOfVerticalBounds(screenBounds: CGRect) -> Bool {
        let verticalBoundaryTolerance = size.height / 2
        if position.y <= screenBounds.minY + verticalBoundaryTolerance  || position.y >= screenBounds.maxY - size.height / 2 {
            return true
        }
        return false
    }
    
    func isOutOfHorizontalBounds(screenBounds: CGRect) -> Bool {
        let horizontalBoundaryTolerance = size.width / 2
        if position.x <= screenBounds.minX + horizontalBoundaryTolerance || position.x >= screenBounds.maxX - horizontalBoundaryTolerance {
            return true
        }
        return false
    }
    
    mutating func reset(){
        position = initialPosition
        velocity = initialVelocity
    }
}

class PongModel: ObservableObject {
    var leftPaddle: Paddle
    var rightPaddle: Paddle
    var ball: Ball
    var screenBounds: CGRect
    
    init(screenBounds: CGRect) {
        let paddleMargin = CGFloat(75)

        self.leftPaddle = Paddle(position: CGPoint(x: screenBounds.midX, y: screenBounds.minY + paddleMargin))
        self.rightPaddle = Paddle(position: CGPoint(x: screenBounds.midX, y: screenBounds.maxY - paddleMargin))
            
        
        self.ball = Ball(position: CGPoint(x: screenBounds.midX, y: screenBounds.midY))
        self.screenBounds = screenBounds
    }
    
    //TODO: Same Code
    func updateLeftPaddlePosition(xPosition: CGFloat){
        leftPaddle.updatePaddlePosition(bounds: screenBounds, xPosition: xPosition)
        objectWillChange.send() //TODO: Hacky work around for now
    }
    
    func updateRightPaddlePosition(xPosition: CGFloat){
        rightPaddle.updatePaddlePosition(bounds: screenBounds, xPosition: xPosition)
        objectWillChange.send() //TODO: Hacky work around for now
    }
    //TODO: Same Code
    
    func updateBallPosition() {
        ball.updatePosition()
        checkForCollisions()
        objectWillChange.send() //TODO: Hacky work around for now
    }
    
    func checkForCollisions(){
        if isCollidingWithPaddle(ball: ball, paddle: leftPaddle) {
            handlePaddleCollision(paddle: leftPaddle)
        } else if isCollidingWithPaddle(ball: ball, paddle: rightPaddle) {
            handlePaddleCollision(paddle: rightPaddle)
        }


        if ball.isOutOfHorizontalBounds(screenBounds: screenBounds) {
           ball.velocity.dx *= -1
        }

        if ball.isOutOfVerticalBounds(screenBounds: screenBounds){
            resetGame()
        }
    }

    private func handlePaddleCollision(paddle: Paddle) {
        ball.velocity.dy *= -1
        
        let distanceFromPaddleCenter = ball.position.x - paddle.position.x
        let normalizationFactor = paddle.size.height / 4
        let offsetFromCenter = distanceFromPaddleCenter / normalizationFactor
        
        let bounceAngleMultiplier = 2.0
        ball.velocity.dx += offsetFromCenter * bounceAngleMultiplier
        
        // Limit the vertical velocity to prevent excessive angles: CHATGPT
        let maxVerticalSpeed: CGFloat = 8
        ball.velocity.dx = min(max(ball.velocity.dx, -maxVerticalSpeed), maxVerticalSpeed)
    }
    
    func isCollidingWithPaddle(ball: Ball, paddle: Paddle) -> Bool {
        // Axis-Aligned Distance Collision Algorithm
        let horizontalDistance = abs(ball.position.x - paddle.position.x)
        let verticalDistance = abs(ball.position.y - paddle.position.y)
        
        let allowedHorizontalDistance = (paddle.size.width / 2 + ball.size.width / 2)
        let allowedVerticalDistance = (paddle.size.height / 2 + ball.size.height / 2)
        
        let horizontalCollision =  horizontalDistance <= allowedHorizontalDistance
        let verticalCollision = verticalDistance <= allowedVerticalDistance
        
        return horizontalCollision && verticalCollision
    }
    
    private func resetGame(){
        leftPaddle.reset()
        rightPaddle.reset()
        ball.reset()
    }
}
