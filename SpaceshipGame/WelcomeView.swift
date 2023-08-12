//
//  StartPage.swift
//  SpaceshipGame
//
//  Created by Bulat Kamalov on 01.08.2023.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isGameSceneActive = false
    @State private var isTableViewActive = false
    @State private var isSecondScreenActive = false


    var body: some View {
        VStack {
            Text("Welcome to the Game!")
                .font(.title)
                .padding()
            
            Button("Start Game", action: {
                isGameSceneActive = true
            })
            .font(.title)
            .padding()
            
            NavigationLink(
                destination: ContentView(),
                isActive: $isGameSceneActive,
                label: {
                    EmptyView()
                })
                .hidden()
            
            Button("Open Table View", action: {
                isTableViewActive = true
            })
            .font(.title)
            .padding()
            
            NavigationLink(
                destination: TableViewScreen(),
                isActive: $isTableViewActive,
                label: {
                    EmptyView()
                })
                .hidden()
            
            Button("Open Setting Screen", action: {
                isSecondScreenActive = true
            })
            .font(.title)
            .padding()
            
            NavigationLink(
                destination: SecondScreen(),
                isActive: $isSecondScreenActive,
                label: {
                    EmptyView()
                })
                .hidden()
        }
       
    }
}

