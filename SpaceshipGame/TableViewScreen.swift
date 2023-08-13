//
//  TableViewScreen.swift
//  SpaceshipGame
//
//  Created by Bulat Kamalov on 01.08.2023.

import SwiftUI

struct TableViewScreen: View {
    let ships: [ModelShip] = [
        ModelShip(name: "Ship 1", imageName: "ship1"),
        ModelShip(name: "Ship 2", imageName: "ship2"),
        ModelShip(name: "Ship 3", imageName: "ship3")
    ]
    
    var body: some View {
            List(ships) { ship in
                NavigationLink(destination: DetailView(ship: ship)) {
                    HStack {
                        Image(ship.imageName)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(ship.name)
                    }
                }
            }
            .navigationTitle("Ships")
    }
}


