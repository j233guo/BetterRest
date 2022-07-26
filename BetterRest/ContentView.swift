//
//  ContentView.swift
//  BetterRest
//
//  Created by Jiaming Guo on 2022-07-25.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeeAmount = 1
    
    func calculateBedTime() {
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper(value: $sleepAmount, in: 4.0...12.0, step: 0.25) {
                    Text("\(sleepAmount.formatted()) hours")
                }
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(value: $coffeeAmount, in: 1...20) {
                    Text(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups")
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
