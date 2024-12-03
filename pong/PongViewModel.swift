//
//  PongViewModel.swift
//  pong
//
//  Created by Nassor, Hamad on 17/11/2024.
//

import SwiftUI

class PongViewModel: ObservableObject {
    @Published var bottomPaddle: Paddle
    @Published var topPaddle: Paddle
    @Published var ball: Ball
    @Published var bottomPlayerScore: Int = 0
    @Published var topPlayerScore: Int = 0
    private let screenBounds: CGRect

    init(screenBounds: CGRect) {
        let paddleMargin = CGFloat(75)

        self.bottomPaddle = Paddle(position: CGPoint(x: screenBounds.midX, y: screenBounds.minY + paddleMargin))
        self.topPaddle = Paddle(position: CGPoint(x: screenBounds.midX, y: screenBounds.maxY - paddleMargin))
        self.ball = Ball(position: CGPoint(x: screenBounds.midX, y: screenBounds.midY))
        self.screenBounds = screenBounds
    }

    func updateBottomPaddlePosition(xPosition: CGFloat) {
        bottomPaddle.updatePaddlePosition(bounds: screenBounds, xPosition: xPosition)
        objectWillChange.send()
    }

    func updateTopPaddlePosition(xPosition: CGFloat) {
        topPaddle.updatePaddlePosition(bounds: screenBounds, xPosition: xPosition)
        objectWillChange.send()
    }

    func updateBallPosition() {
        ball.updatePosition()
        checkForCollisions()
        objectWillChange.send()
    }

    private func checkForCollisions() {
        if isCollidingWithPaddle(ball: ball, paddle: bottomPaddle) {
            handlePaddleCollision(paddle: bottomPaddle)
        } else if isCollidingWithPaddle(ball: ball, paddle: topPaddle) {
            handlePaddleCollision(paddle: topPaddle)
        }

        if ball.isOutOfHorizontalBounds(screenBounds: screenBounds) {
            ball.velocity.dx *= -1
        }

        let verticalBoundStatus = ball.checkVerticalBounds(screenBounds: screenBounds)
        switch verticalBoundStatus {
        case .top:
            bottomPlayerScore += 1
            resetGame()
        case .bottom:
            topPlayerScore += 1
            resetGame() 
        case .none:
            break
        }
    }

    private func handlePaddleCollision(paddle: Paddle) {
        ball.velocity.dy *= -1

        let distanceFromPaddleCenter = ball.position.x - paddle.position.x
        let normalizationFactor = paddle.size.width / 4
        let offsetFromCenter = distanceFromPaddleCenter / normalizationFactor

        let bounceAngleMultiplier: CGFloat = 2.0
        ball.velocity.dx += offsetFromCenter * bounceAngleMultiplier

        let maxVerticalSpeed: CGFloat = 8
        ball.velocity.dx = min(max(ball.velocity.dx, -maxVerticalSpeed), maxVerticalSpeed)
    }

    private func isCollidingWithPaddle(ball: Ball, paddle: Paddle) -> Bool {
        let horizontalDistance = abs(ball.position.x - paddle.position.x)
        let verticalDistance = abs(ball.position.y - paddle.position.y)

        let allowedHorizontalDistance = paddle.size.width / 2 + ball.size.width / 2
        let allowedVerticalDistance = paddle.size.height / 2 + ball.size.height / 2

        return horizontalDistance <= allowedHorizontalDistance && verticalDistance <= allowedVerticalDistance
    }

    private func resetGame() {
        bottomPaddle.reset()
        topPaddle.reset()
        ball.reset()
    }
}

