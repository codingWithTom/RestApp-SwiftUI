//
//  ContentView.swift
//  OrderAppClip
//
//  Created by Tomas Trujillo on 2021-09-13.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @State private var openedFromURL: String?
    @StateObject private var viewModel = ContentViewModel()
    @State private var isPresentingAppStoreOverlay = false
    
    var body: some View {
        VStack {
            Image(viewModel.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 500)
            Text(
                "Lorem Ipsum Dolor Lorem Ipsum Dolor Lorem Ipsum Dolor Lorem Ipsum Dolor Lorem Ipsum Dolor"
            )
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: { isPresentingAppStoreOverlay.toggle() }) {
                Text("Order Free Sample")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.purple)
            .clipShape(Capsule())
        }
        .ignoresSafeArea(.container, edges: .top)
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
            viewModel.handle(activity: activity)
        }
        .appStoreOverlay(isPresented: $isPresentingAppStoreOverlay) {
            SKOverlay.AppClipConfiguration(position: .bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
