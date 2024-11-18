//
//  ContentView.swift
//  pong
//
//  Created by Nassor, Hamad on 07/11/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: PongViewModel
    let timer = Timer.publish(every: 1/50, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: viewModel.leftPaddle.size.width, height: viewModel.leftPaddle.size.height)
                .position(viewModel.leftPaddle.position)
                .foregroundColor(.blue)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            viewModel.updateLeftPaddlePosition(xPosition: value.location.x)
                            
                        }
                )
            
            Circle()
                .frame(width: viewModel.ball.size.width, height: viewModel.ball.size.height)
                .position(viewModel.ball.position)
                .foregroundColor(.white)
            
            Rectangle()
                .frame(width: viewModel.rightPaddle.size.width, height: viewModel.rightPaddle.size.height)
                .position(viewModel.rightPaddle.position)
                .foregroundColor(.red)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            viewModel.updateRightPaddlePosition(xPosition: value.location.x)
                            
                        }
                )
        }
        .background(Color.black)
        .ignoresSafeArea()
        .onReceive(timer){ _ in
            viewModel.updateBallPosition()
        }
    }
}

#Preview {
    ContentView(viewModel: PongViewModel(screenBounds: UIScreen.main.bounds))
}
