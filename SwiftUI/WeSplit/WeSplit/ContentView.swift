//
//  ContentView.swift
//  WeSplit
//
//  Created by Egor Chernakov on 10.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = 0
    @State private var tip = 2
    
    var totalAmount: Double {
        let tipPercentage = 1 + Double(tips[tip])/100
        let check = Double(checkAmount) ?? 0.0
        return check*tipPercentage
    }
    
    var totalPerPerson: Double {
        let people = Double(numberOfPeople + 2)
        let tipPercentage = 1 + Double(tips[tip])/100
        let check = Double(checkAmount) ?? 0.0
        return check*tipPercentage/people
    }
    
    let tips = [5, 10, 15, 20, 0]
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Check Amount: \(checkAmount)", text: $checkAmount)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("How many people?")) {
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    } .pickerStyle(WheelPickerStyle())
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip", selection: $tip) {
                        ForEach(0..<tips.count) {
                            Text("\(tips[$0]) %")
                        }
                    } .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total amount")) {
                    Text("\(totalAmount, specifier: "%.2f")₽")
                        .foregroundColor(tips[tip] == 0 ? .red : .black)
                }
                
                Section(header: Text("Amount per person")) {
                    Text("\(totalPerPerson, specifier: "%.2f")₽")
                }
            }
            .navigationTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
