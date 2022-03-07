//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Teague Cole on 2/16/22.
//

import SwiftUI

extension Image {
    func flagImage() -> some View {
            self
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore: Bool = false
    @State private var showingGameOver: Bool = false
    @State private var scoreTitle: String = ""
    @State private var gameOverTitle: String = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland" ,"Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer: Int = Int.random(in: 0...2)
    @State private var correctScore: Int = 0
    @State private var incorrectScore: Int = 0
    @State private var alertMessage: String = ""
    @State private var guesses: Int = 0
    @State private var selectedFlag = -1
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button() {
                            guesses += 1
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .flagImage()
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                                .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.75)
                                .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                                .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                                .animation(.default, value: selectedFlag)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Correct: \(correctScore)\n Wrong: \(incorrectScore)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Spacer()
            
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert(gameOverTitle, isPresented: $showingGameOver) {
            Button("New Game", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
    }
    
    
    func flagTapped (_ number: Int) {
        selectedFlag = number
        if guesses == 8 {
            gameOverTitle = "Game Over"
            let grade = (Float(correctScore) / Float(guesses)) * 100
            if number == correctAnswer {
                alertMessage = "Congrats, that was the flag of \(countries[correctAnswer]). You scored \(grade)%"
            } else {
                alertMessage = "Sorry, you tapped \(countries[number]). You scored \(grade)%"
            }
            reset()
            showingGameOver = true
            return
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            alertMessage = "Congrats, that was the flag of \(countries[correctAnswer])"
            correctScore += 1
        } else {
            scoreTitle = "Wrong"
            alertMessage = "Try again, you tapped \(countries[number])"
            incorrectScore += 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
    }
    
    func reset() {
        correctScore = 0
        incorrectScore = 0
        guesses = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
