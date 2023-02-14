//
//  DefaultInput.swift
//  voice-pick-frontend
//
//  Created by tama on 14/02/2023.
//

import SwiftUI

struct DefaultInput: View {
    @Binding var inputText: String
    @State var isPassword: Bool
    @State private var text = ""

    var body: some View {

        let view = isPassword ? AnyView(SecureField(
                inputText,
                text: $text
            )):
            AnyView(TextField(
                inputText,
                text: $text,
                onEditingChanged: { _ in print("changed") },
                onCommit: { print("commit") }
            ))
        
        return view
            .fontWeight(.bold)
            .font(.button)
            .padding()
            .foregroundColor(.mountain)
            .background(Color.snow)
            .shadow(radius: 5)
            .cornerRadius(5)
            .shadow(radius: 3)
    }
}
