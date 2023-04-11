//
//  Header.swift
//  voice-pick-frontend
//
//  Created by tama on 17/02/2023.
//

import SwiftUI

struct Header: View {
	var headerText: String
	var navigationButton: Button<Image>? = nil
	var actionButtons: [Button<Image>]? = nil
	
	var body: some View {
		HStack {
			if let navigationButton = navigationButton {
				navigationButton
			}
			Spacer()
			Text(headerText)
				.font(.button)
			Spacer()
			if let actionButtons = actionButtons {
				HStack {
					ForEach(0..<actionButtons.count, id: \.self) { index in
						actionButtons[index]
					}
				}
			}
		}
		.padding()
		.foregroundColor(.dark)
		.background(Color.traceLightYellow)
	}
}

struct Header_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Header(
				headerText: "Header",
				navigationButton: Button(action: {}, label: {
					Image(systemName: "chevron.left")
				}),
				actionButtons: [
					Button(action: {}, label: {
						Image(systemName: "plus")
					}),
					Button(action: {}, label: {
						Image(systemName: "pencil")
					})
				]
			)
			Header(
				headerText: "Header",
				actionButtons: [
					Button(action: {}, label: {
						Image(systemName: "plus")
					}),
					Button(action: {}, label: {
						Image(systemName: "pencil")
					})
				]
			)
			Header(
				headerText: "Header",
				navigationButton: Button(action: {}, label: {
					Image(systemName: "chevron.left")
				})
			)
			Header(
				headerText: "Header"
			)
		}
	}
}
