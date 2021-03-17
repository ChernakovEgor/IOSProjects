//
//  ContentView.swift
//  Animations
//
//  Created by Egor Chernakov on 23.02.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationValue: CGFloat = 1.0
    @State private var color = UIColor.systemPink
    @State private var rotation = 0.0
    
    var body: some View {
        Button("Tap me") {
            color = color == UIColor.systemPink ? UIColor.systemBlue : UIColor.systemPink
            withAnimation {
                rotation += 350.0
            }
        }
        .padding(50)
        .background(Color(color))
        .foregroundColor(.white)
        .clipShape(Circle())
        .rotation3DEffect(.degrees(rotation), axis: (x: 1.0, y: 1.0, z: 0.0))
        .overlay(
            Circle()
                .stroke(Color(color), lineWidth: 3.0)
                .scaleEffect(animationValue)
                .opacity(Double(5-animationValue))
                .animation(
                    Animation.easeOut(duration: 1)
                        .repeatForever(autoreverses: false)
                )
        )
        .onAppear {
            animationValue = 5
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
