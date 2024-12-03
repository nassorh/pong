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
    let topPlayerColor = Color.red
    let bottomPlayerColor = Color.blue
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: viewModel.topPaddle.size.width, height: viewModel.topPaddle.size.height)
                .position(viewModel.topPaddle.position)
                .foregroundColor(topPlayerColor)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            viewModel.updateTopPaddlePosition(xPosition: value.location.x)
                            
                        }
                )
            
            Circle()
                .frame(width: viewModel.ball.size.width, height: viewModel.ball.size.height)
                .position(viewModel.ball.position)
                .foregroundColor(.white)
            
            Rectangle()
                .frame(width: viewModel.bottomPaddle.size.width, height: viewModel.bottomPaddle.size.height)
                .position(viewModel.bottomPaddle.position)
                .foregroundColor(bottomPlayerColor)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            viewModel.updateBottomPaddlePosition(xPosition: value.location.x)
                            
                        }
                )
            
            Text("\(viewModel.topPlayerScore)")
                .font(.largeTitle)
                .foregroundColor(topPlayerColor)
                .position(x: 50, y: 50)

            Text("\(viewModel.bottomPlayerScore)")
                .font(.largeTitle)
                .foregroundColor(bottomPlayerColor)
                .position(x: UIScreen.main.bounds.width - 50, y: 50)
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
