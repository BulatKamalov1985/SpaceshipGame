//
//  ContentView.swift
//  SpaceshipGame
//
//  Created by Bulat Kamalov on 28.07.2023.
//
import SwiftUI
import SpriteKit


struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    let scene = GameScene()
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
            .onDisappear {
                // Вызывайте методы очистки вашей GameScene здесь
                scene.removeAllChildren()
                scene.stopTimers()
                scene.isCollisionOccurred = false
                scene.shotCount = 0
            }
            .navigationBarBackButtonHidden(true) // Скрываем кнопку "Назад"
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Создаем свою кнопку "Назад", которая закрывает текущий экран
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                    }
                }
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
