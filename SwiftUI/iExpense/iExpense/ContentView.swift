//
//  ContentView.swift
//  iExpense
//
//  Created by Egor Chernakov on 01.03.2021.
//

import SwiftUI

struct Expense: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [Expense]() {
        didSet {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(items) {
                UserDefaults.standard.set(data, forKey: "Items")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Expense].self, from: data) {
                items = decoded
                return
            }
        }
        items = []
    }
}

struct ContentView: View {

    @ObservedObject var expenses = Expenses()
    
    @State private var showingAddExpenseView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack(alignment: .bottom) {
                        Text("\(item.name)")
                            .font(.headline)
                        Text("\(item.type)")
                        Spacer()
                        Text("$\(item.amount, specifier: "%g")")
                    }
                    .animation(.default)
                }
                .onDelete(perform: { indexSet in
                    expenses.items.remove(atOffsets: indexSet)
                })
            }
            .navigationTitle("iExpense")
            .navigationBarItems(trailing:
                                    HStack {
                                        EditButton()
                                        Spacer()
                                        Button(action: {
                                            showingAddExpenseView.toggle()
                                        }) {
                                            Image(systemName: "plus")
                                        }
                                    }
            )
            .sheet(isPresented: $showingAddExpenseView){
                AddExpenseView(expenses: self.expenses)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
