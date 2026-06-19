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

    private let yellow = Color(red: 1, green: 204 / 255, blue: 0)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer().frame(height: 32)

            Text("Partner App")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.primary)

            Text("The buttons below launch flows powered by the Mozio SDK")
                .font(.system(size: 15))
                .foregroundStyle(Color(red: 99 / 255, green: 114 / 255, blue: 128 / 255))

            Divider()
                .padding(.vertical, 8)

            Button("Search Rides") {
                showSearch.toggle()
            }
            .font(.system(size: 17, weight: .bold))
            .buttonStyle(SamplePrimaryButtonStyle(primaryColor: yellow))

            Button("Find reservation") {
                MozioSDK.shared.findReservation()
            }
            .font(.system(size: 17, weight: .bold))
            .buttonStyle(SamplePrimaryButtonStyle(primaryColor: yellow))

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .fullScreenCover(isPresented: $showSearch) {
            MozioSDK.views.searchRideView(
                displayResultsWhileLoading: true
            )
        }
    }
}

private struct SamplePrimaryButtonStyle: ButtonStyle {
    let primaryColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(Color.black)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(primaryColor)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

#Preview {
    ContentView()
}
