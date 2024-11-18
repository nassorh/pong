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

    init(position: CGPoint, size: CGSize = CGSize(width: 75, height: 10)) {
        self.initialPosition = position
        self.position = position
        self.size = size
    }

    mutating func updatePaddlePosition(bounds: CGRect, xPosition: CGFloat) {
        position.x = min(max(xPosition, bounds.minX + size.width / 2), bounds.maxX - size.width / 2)
    }

    mutating func reset() {
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
        return position.y <= screenBounds.minY + verticalBoundaryTolerance || position.y >= screenBounds.maxY - verticalBoundaryTolerance
    }

    func isOutOfHorizontalBounds(screenBounds: CGRect) -> Bool {
        let horizontalBoundaryTolerance = size.width / 2
        return position.x <= screenBounds.minX + horizontalBoundaryTolerance || position.x >= screenBounds.maxX - horizontalBoundaryTolerance
    }

    mutating func reset() {
        position = initialPosition
        velocity = initialVelocity
    }
}
