//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Egor Chernakov on 17.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "Russia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var rotationValue = [0.0, 0.0, 0.0]
    @State private var opacityValue = [1.0, 1.0, 1.0]
    @State private var wrong = false
    
    @State private var score = 0

    struct FlagImage: View {
        let countryName: String
        var rotationValue = 0.0
        var opacityValue = 1.0
        var wrong = false
        
        var body: some View {
            Image("\(countryName)")
                .renderingMode(.original)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.black, lineWidth: 1.0))
                .shadow(radius: 5)
                .offset(x: wrong ? -5 : 0)
                .animation(Animation.default.repeatCount(5))
                .offset(x: wrong ? 0 : 5)
                .rotation3DEffect(Angle.degrees(rotationValue), axis: (x: 0.0, y: 1.0, z: 0.0))
                .opacity(opacityValue)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.orange, Color.green]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(countries[correctAnswer]).foregroundColor(.white)
                        .fontWeight(.black)
                        .font(.largeTitle)
                }
                
                ForEach(0..<3, id: \.self) { number in
                    Button(action: {
                        flagTapped(number)
                    }) {
                        FlagImage(countryName: countries[number], rotationValue: rotationValue[number], opacityValue: opacityValue[number], wrong: wrong)
                    }
                }
                
                Text("Your score: \(score)")
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("OK"), action: {askQuestion()}))
        }
    }
    
    func flagTapped(_ tappedNumber: Int) {
        if tappedNumber == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"
            withAnimation {
                rotationValue[tappedNumber] += 360.0
                for num in 0..<opacityValue.count {
                    if num != tappedNumber {
                        opacityValue[num] = 0.25
                    }
                }
            }
        } else {
            withAnimation {
            wrong = true
            }
            scoreTitle = "Wrong"
            scoreMessage = "That's the flag of \(countries[tappedNumber])"
            wrong = false
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityValue = Array(repeating: 1.0, count: 3)
        rotationValue = Array(repeating: 0.0, count: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
