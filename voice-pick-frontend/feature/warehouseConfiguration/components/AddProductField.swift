//
//  AddProductField.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 11/04/2023.
//

import SwiftUI

struct AddProductField: View {
	let label: String
	@Binding var value: String
	@Binding var errorMsg: String?
	var type: UIKeyboardType = .asciiCapable
	@State var editing = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			// Labels with error message
			HStack {
				DefaultLabel(label)
					.foregroundColor(errorMsg == nil ? Color.foregroundColor : Color.error)
				Spacer()
				if (errorMsg != nil) {
					Text(errorMsg ?? "")
						.foregroundColor(Color.error)
				}
			}
			// Value / input and toggle button
			HStack {
				if (editing) {
					DefaultInput(inputLabel: label, text: $value, valid: true, keyboardType: type)
				} else {
					Text(value)
						.bold()
						.foregroundColor(errorMsg == nil ? Color.foregroundColor : Color.error)
				}
				Spacer()
				Button(action: {
					withAnimation {
						self.editing = !self.editing
					}
				}, label: {
					Image(systemName: editing ? "checkmark" : "pencil")
						.foregroundColor(Color.foregroundColor)
				})
			}
		}
	}
}

struct AddProductField_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			AddProductField(
				label: "Produkt navn",
				value: .constant("Coca Cola"),
				errorMsg: .constant(nil)
			)
		}
		
	}
}

