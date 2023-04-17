//
//  ImagePicker.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/04/2023.
//

import SwiftUI

import SwiftUI

struct ImagePicker: View {
	var images: [String] = ["profile-1", "profile-2", "profile-3", "profile-4", "profile-5", "profile-6", "profile-7", "profile-8", "profile-9", "profile-10", "profile-11", "profile-12", "profile-13", "profile-14", "profile-15", "profile-16", "profile-17", "profile-18", "profile-19", "profile-20", "profile-21"]
	@Binding var selectedImage: String
	@Environment(\.presentationMode) var presentationMode
	
	private let gridItems = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	var body: some View {
			VStack {
				Spacer()
				VStack{
					Title("Velg profilbilde")
				}
				VStack {
					ScrollView {
						LazyVGrid(columns: gridItems, spacing: 20) {
							ForEach(images, id: \.self) { image in
								Image(image)
									.resizable()
									.frame(width: 100, height: 100)
									.clipShape(Circle())
									.onTapGesture {
										selectedImage = image
										presentationMode.wrappedValue.dismiss()
									}
							}
						}
						.padding()
					}
				}
			}
		.background(Color.backgroundColor)
	}
}



struct ImagePicker_Previews: PreviewProvider {
	@State static private var selectedImage = ""
	
	static var previews: some View {
		ImagePicker(selectedImage: $selectedImage)
	}
}
