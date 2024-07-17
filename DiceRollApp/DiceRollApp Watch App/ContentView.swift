//
//  ContentView.swift
//  DiceRollApp Watch App
//
//  Created by Ксандер Гусаров on 17.07.2024.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @State private var randomNumber = 0
    @State private var isShaking = false
    @State private var isShowingStartText = true
    @State private var timer: Timer?
    @State private var shakeTimer: Timer?
    @State private var motionManager = CMMotionManager()
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 150, height: 150)
                    .cornerRadius(32) // Добавляем закругление углов
                
                Text("Tap")
                    .font(.system(size: 48))
                    .fontWeight(.light)
                    .foregroundColor(isShowingStartText ? Color.white : Color.blue)
                    .multilineTextAlignment(.center)
                
                Image("dice\(randomNumber)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(randomNumber == 0 ? Color.clear : Color.white)
                
            }
            .scaleEffect(isShaking ? 0.8 : 1.0)
            .rotationEffect(.degrees(isShaking ? rotationAngle : 0))
            .onTapGesture {
                withAnimation {
                    self.performShake()
                }
            }
        }
        .padding()
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
            self.performShake()
        }
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
            withAnimation {
                self.isShaking = false
                self.generateRandomNumber()
            }
        }
    }
    
    func performShake() {
        self.isShaking = true
        self.isShowingStartText = false
        self.startTimer()
        self.startShakeTimer()
    }
    
    func startShakeTimer() {
        shakeTimer?.invalidate()
        shakeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation {
                if (self.isShaking) {
                    self.rotationAngle = Double.random(in: -10...10)
                }
            }
        }
    }

    func generateRandomNumber() {
        self.randomNumber = Int.random(in: 1...6)
        self.rotationAngle = Double.random(in: -20...20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Notification.Name {
    static let deviceDidShake = Notification.Name("deviceDidShake")
}
