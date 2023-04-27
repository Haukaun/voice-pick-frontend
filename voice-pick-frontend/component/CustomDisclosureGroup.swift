//
//  CustomDisclosureGroup.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 26/04/2023.
//

import Foundation

import SwiftUI

struct CustomDisclosureGroup: View {
	let title: String
	let selectedValue: String
	let list: [String]
	let action: (String) -> Void
	
	var body: some View {
		DisclosureGroup(content: {
			ScrollView {
				VStack {
					ForEach(list, id: \.self) { item in
						Button(action: {
							action(item)
						}) {
							Spacer()
							Text(item)
								.padding(15)
								.fontWeight(.bold)
								.font(.button)
								.foregroundColor(.snow)
							Spacer()
						}
						.background(Color.night)
						.cornerRadius(UIView.standardCornerRadius)
					}
				}.padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
			}
		}, label: {
			VStack (alignment: .leading) {
				Text(title)
				Text(selectedValue)
					.bold()
					.foregroundColor(.foregroundColor)
			}
		})
		.padding(EdgeInsets(.init(top: 5, leading: 15, bottom: 5, trailing: 15)))
		.accentColor(.foregroundColor)
		.background(Color.componentColor)
		.cornerRadius(5)
		.shadow(color: Color.black.opacity(0.2), radius: 5, y: 5)
	}
}

struct CustomDisclosureGroup_preview: PreviewProvider {
	static var previews: some View {
		VStack{
			CustomDisclosureGroup(
				title: "Valgt type:",
				selectedValue: "ANkara",
				list: ProductType.allCases.map { $0.rawValue }
			) { selectedType in
				print("Ankarar")
			}
		}
		.frame(maxHeight: .infinity)
		.background(Color.backgroundColor)
	}
}
