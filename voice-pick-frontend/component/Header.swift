//
//  Header.swift
//  voice-pick-frontend
//
//  Created by tama on 17/02/2023.
//

import SwiftUI

import SwiftUI

struct Header: View {
		var headerText: String
		var leftButton: Button<Image>? = nil
		var rightButtons: [Button<Image>]? = nil
		
		var body: some View {
						let gridSize = [GridItem(.fixed(40)), GridItem(.flexible()), GridItem(.fixed(40))]
						
					
						LazyVGrid(columns: gridSize, alignment: .center, spacing: 0) {
								if let leftButton = leftButton {
										leftButton
								} else {
										Spacer()
								}
								Text(headerText)
										.font(.button)
							
								if let rightButtons = rightButtons {
										HStack {
												ForEach(0..<rightButtons.count, id: \.self) { index in
														rightButtons[index]
												}
										}
								} else {
										Spacer()
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
				leftButton: Button(action: {}, label: {
					Image(systemName: "chevron.left")
				}),
				rightButtons: [
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
				rightButtons: [
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
				leftButton: Button(action: {}, label: {
					Image(systemName: "chevron.left")
				})
			)
			Header(
				headerText: "Header"
			)
		}
	}
}
