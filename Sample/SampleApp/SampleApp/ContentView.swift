//
//  ContentView.swift
//  SampleApp
//
//  Created by Yiannis Josephides on 27/01/2025.
//

import SwiftUI
import Mozio

struct ContentView: View {
    @State private var showSearch: Bool = false
    
    var body: some View {
        VStack {
            Button("Search Rides") {
                showSearch.toggle()
            }
        }
        .fullScreenCover(isPresented: $showSearch, content: {
            MozioSDK.views.searchRideView()
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
