//
//  AddExpenseView.swift
//  iExpense
//
//  Created by Egor Chernakov on 02.03.2021.
//

import SwiftUI

struct AddExpenseView: View {
    
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = "0"
    
    @State private var showingAlert = false
    
    private let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Pick", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    Text("$")
                    TextField("\(amount)", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add new expense")
            .navigationBarItems(trailing: Button(action: {
                if let price = Double(amount) {
                    expenses.items.append(Expense(name: name, type: type, amount: price))
                    showingAlert.toggle()
                }
            }) {
                Text("Save")
            })
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Expense saved"), message: nil, dismissButton: .default(Text("OK!")))
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(expenses: Expenses())
    }
}
