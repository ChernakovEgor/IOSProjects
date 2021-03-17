//
//  ContentView.swift
//  RockPaperScissorsGame
//
//  Created by Egor Chernakov on 19.02.2021.
//

import SwiftUI

struct CardView: View {
    let name: String
    var body: some View {
        Image("\(name)")
            .resizable()
            .frame(width: 100, height: 150, alignment: .center)
            .cornerRadius(7)
    }
}

struct ContentView: View {
    
    let moves = ["rock", "paper", "scissors"]
    
    @State private var computerMove = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var gameIsOver = false
    @State private var questionNumber = 1
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.black, .blue, .black, .gray, .gray]), center: .top)
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30)  {
                Text("Your Score: \(score)")
                HStack {
                    Text("\(shouldWin ? "WIN" : "LOSE")")
                    Text("against")
                    Text("\(moves[computerMove].uppercased())")
                }.font(Font.headline.weight(.heavy))
                HStack {
                    ForEach(0..<3) { move in
                        Button(action: {
                            let playerHasWon = hasPlayerWon(withMove: moves[move], against: moves[computerMove])
                            if shouldWin {
                                score += playerHasWon ? 1 : -1
                            } else {
                                score += playerHasWon ? -1 : 1
                            }
                            computerMove = Int.random(in: 0...2)
                            shouldWin = Bool.random()
                            questionNumber += 1
                            if questionNumber == 11 {
                                gameIsOver = true
                            }
                        }) {
                            CardView(name: "\(moves[move])")
                        }
                    }
                }
                Spacer()
            }
            .alert(isPresented: $gameIsOver) {
                Alert(title: Text("Game Over"), message: Text("Your Score Is \(score)"), dismissButton: .default(Text("Play Again")) {
                        score = 0
                        questionNumber = 1
                })
            }
        }
    }
    
    func hasPlayerWon(withMove: String, against move: String) -> Bool {
        let winScenarios = ["rockscissors", "scissorspaper", "paperrock"]
        return winScenarios.contains("\(withMove)\(move)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
