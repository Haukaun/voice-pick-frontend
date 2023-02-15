//
//  ContentView.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 10/02/2023.
//

import SwiftUI

struct ContentView: View {
    @State var emailInput = "Email"
    @State var passowrdInput = "Password"
    @State var buttonText = "Sign in"
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
						.font(.header1)
            DefaultInput(inputText: $emailInput, isPassword: false)
            DefaultInput(inputText: $passowrdInput, isPassword: true)
            DefaultButton(buttonText: $buttonText)
        }
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
