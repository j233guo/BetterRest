//
//  ContentView.swift
//  BetterRest
//
//  Created by Jiaming Guo on 2022-07-25.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var bedTime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            return "\(sleepTime.formatted(date: .omitted, time: .shortened))"
        } catch {
            return "Error"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                }
                
                Section {
                    Stepper(value: $sleepAmount, in: 4.0...12.0, step: 0.25) {
                        Text("\(sleepAmount.formatted()) hours")
                    }
                } header: {
                    Text("Desired amount of sleep")
                }
                
                Section {
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        Text(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups")
                    }
                } header: {
                    Text("Daily coffee intake")
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text(bedTime != "Error" ? "You ideal bed time is: " : "There was en error in calculating your ideal bedtime")
                        HStack {
                            Spacer()
                            Text(bedTime)
                                .font(.title.bold())
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
