//
//  ContentView.swift
//  pong
//
//  Created by Nassor, Hamad on 07/11/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = PongModel(screenBounds: UIScreen.main.bounds)
    let timer = Timer.publish(every: 1/50, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: model.leftPaddle.size.width, height: model.leftPaddle.size.height)
                .position(model.leftPaddle.position)
                .foregroundColor(.blue)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            model.updateLeftPaddlePosition(xPosition: value.location.x)
                            
                        }
                )
            
            Circle()
                .frame(width: model.ball.size.width, height: model.ball.size.height)
                .position(model.ball.position)
                .foregroundColor(.white)
            
            Rectangle()
                .frame(width: model.rightPaddle.size.width, height: model.rightPaddle.size.height)
                .position(model.rightPaddle.position)
                .foregroundColor(.red)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            model.updateRightPaddlePosition(xPosition: value.location.x)
                            
                        }
                )
        }
        .background(Color.black)
        .ignoresSafeArea()
        .onReceive(timer){ _ in
            model.updateBallPosition()
        }
    }
}

#Preview {
    ContentView()
}
