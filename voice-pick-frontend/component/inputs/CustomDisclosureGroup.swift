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
	
	@Binding var isColorEnabled: Bool
	
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
								.foregroundColor(Color.backgroundColor)
							Spacer()
						}
						.background(Color.foregroundColor)
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
		.padding(EdgeInsets(.init(top: 5, leading: isColorEnabled ? 15 : 0, bottom: 5, trailing: isColorEnabled ? 15 : 0)))
		.accentColor(.foregroundColor)
		.background(isColorEnabled ? Color.componentColor : Color.backgroundColor)
		.cornerRadius(5)
		.shadow(color: isColorEnabled ? Color.black.opacity(0.2) : Color.clear, radius: isColorEnabled ? 5 : 0, y: isColorEnabled ? 5 : 0)
	}
}

struct CustomDisclosureGroup_preview: PreviewProvider {
	@State static var isEnabled: Bool = false
	@State static var isForegroundEnabled: Bool = false
	
	static var previews: some View {
		VStack{
			CustomDisclosureGroup(
				title: "Valgt type:",
				selectedValue: "ANkara",
				list: ProductType.allCases.map { $0.rawValue },
				action: { selectedType in
					print("Ankara")
				},
				isColorEnabled: $isEnabled
			)
		}
		.frame(maxHeight: .infinity)
		.background(Color.backgroundColor)
	}
}

