//
//  ContentView.swift
//  MultiplicationApp
//
//  Created by Egor Chernakov on 01.03.2021.
//

import SwiftUI

struct SettingsView: View {
    
    let numberOfQuestions = ["5", "10", "15", "20", "All"]
    let colors = [UIColor.green, UIColor.cyan, UIColor.systemIndigo, UIColor.orange, UIColor.systemRed]
    
    @State private var questionsSelected = 0
    @State private var multiTable = 1
    
    @State private var rotationValue = 0.0
    
    var body: some View {
        ZStack {
            Color(colors[questionsSelected])
                .edgesIgnoringSafeArea(.all)
                .opacity(0.7)
                .animation(.default)
            VStack(alignment: .center, spacing: 40) {
                    
                    Text("The Game")
                        .font(.largeTitle)
                        .colorInvert()
                    
                    Stepper(value: $multiTable, in: 1...12, step: 1,
                            onEditingChanged: ({ _ in
                                withAnimation {
                                    rotationValue += 360
                                }
                            })) {
                            Text("Table: \(multiTable)")
                                .font(.title)
                                .rotation3DEffect(Angle.degrees(rotationValue), axis: (x: 0.0, y: 1.0, z: 0.0))
                                .colorInvert()
                    }
                    .padding(20)
                    .background(Color(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .padding()
                
                    Picker("bruh", selection: $questionsSelected) {
                        ForEach(0..<numberOfQuestions.count) { num in
                            Text("\(numberOfQuestions[num])")
                                .colorInvert()
                                
                        }
                    }
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .padding()
                    
                    Button(action: {
                        
                    }) {
                        Text("Start!")
                            .colorInvert()
                            .font(.title)
                            .padding()
                    }
                    .background(Color(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .padding()
                    Spacer()
            }
            .foregroundColor(Color(colors[questionsSelected]))
            .shadow(radius: 5)
        }
    }
}

struct GameView: View {
    var body: some View {
        Text("game")
    }
}

struct ContentView: View {
    
    @State private var isPlaying = false
    
    var body: some View {
        Group {
            if isPlaying {
                GameView()
            } else {
                SettingsView()
            }
        }
    }
    
    func startGame() {
        isPlaying = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
