//
//  ContentView.swift
//  ConversionApp
//
//  Created by Egor Chernakov on 11.02.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var value: String = ""
    @State private var selectedInputUnit = 0
    @State private var selectedOutputUnit = 0
    
    var result: Double {
        let input = Double(value) ?? 0.0
        var base = Measurement(value: 0.0, unit: UnitLength.meters)
        
        switch units[selectedInputUnit] {
        case "Feet":
            base = Measurement(value: input, unit: UnitLength.feet)
        case "Yards":
            base = Measurement(value: input, unit: UnitLength.yards)
        case "Miles":
            base = Measurement(value: input, unit: UnitLength.miles)
        default:
            base = Measurement(value: input, unit: UnitLength.meters)
        }
        
        var output: Double
        switch units[selectedOutputUnit] {
        case "Feet":
            output = base.converted(to: UnitLength.feet).value
        case "Yards":
            output = base.converted(to: UnitLength.yards).value
        case "Miles":
            output = base.converted(to: UnitLength.miles).value
        default:
            output = base.converted(to: UnitLength.meters).value
        }
        
        return output
    }
    
    private let units = ["Meters", "Feet", "Yards", "Miles"]
    
    var body: some View {
        Form {
            Section(header: Text("input value")) {
                TextField("Enter value", text: $value).keyboardType(.decimalPad)
                Picker("Units", selection: $selectedInputUnit) {
                    ForEach(0..<units.count) {
                        Text("\(units[$0])")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("output value")) {
                Text("\(result, specifier: "%.2f")")
                Picker("Units", selection: $selectedOutputUnit) {
                    ForEach(0..<units.count) {
                        Text("\(units[$0])")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
