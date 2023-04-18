//
//  EditableLabelInput.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 14/04/2023.
//

import SwiftUI

struct EditableLabelInput: View {
	
	let label: String
	
	@Binding var value: Any
	@Binding var isEditing: Bool
	
	var body: some View {
		VStack {
			DefaultLabel(label)
			if isEditing {
				switch value {
				case is String:
                    Paragraph(String(value as? String ?? ""))
                        .bold()
				case is Int:
					Paragraph(String(value as? Int ?? 0))
						.bold()
				case is Float:
					Paragraph(String(value as? Float ?? 0.0))
						.bold()
				default:
					Paragraph("Invalid value type")
						.bold()
				}
			} else {
				switch value {
				case is String:
					Paragraph(value as? String ?? "")
						.bold()
				case is Int:
					Paragraph(String(value as? Int ?? 0))
						.bold()
				case is Float:
					Paragraph(String(value as? Float ?? 0.0))
						.bold()
				default:
					Paragraph("Invalid value type")
						.bold()
				}
			}
		}
	}
}

struct EditableLabelInput_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			EditableLabelInput(label: "Test", value: .constant("MyValue"), isEditing: .constant(false))
			EditableLabelInput(label: "Test", value: .constant("MyValue"), isEditing: .constant(true))
		}
	}
}
