//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Egor Chernakov on 18.02.2021.
//

import SwiftUI

struct WaterMark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text("\(text)")
                .padding(5)
                .background(Color.black)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(5)
        }
    }
}

extension View {
    func waterMarked(text: String) -> some View {
        self.modifier(WaterMark(text: text))
    }
}

struct GridView<Content: View>: View {
    let row: Int
    let column: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        HStack {
            ForEach(0..<column) {c in
                VStack(alignment: .leading) {
                    ForEach(0..<row) {r in
                        content(r, c)
                    }
                }
                .background(Color.green)
            }
        }
    }
}

struct ContentView: View {
    
    @State private var useRedColor = false
    
    var body: some View {
        GridView(row: 4, column: 4) {r, c in
            HStack(alignment: .top) {
                Image(systemName: "\(r*4 + c).square")
                Text("\(r) : \(c)")
            }
            .font(.headline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
