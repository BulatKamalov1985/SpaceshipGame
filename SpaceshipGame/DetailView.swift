//
//  DetailView.swift
//  SpaceshipGame
//
//  Created by Bulat Kamalov on 13.08.2023.
//

import SwiftUI

struct DetailView: View {
    @State private var isDone = false
    let ship: ModelShip
    let gameScene = GameScene()
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(ship.imageName)
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            Button(action: {
                isDone.toggle()
                gameScene.createPlayer(playerType: ship.imageName)
            }) {
                Text(isDone ? "Done" : "Action Button")
                    .padding()
                    .background(isDone ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle(ship.name, displayMode: .inline)
    }
}
