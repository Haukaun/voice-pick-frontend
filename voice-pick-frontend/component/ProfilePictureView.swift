//
//  ProfilePictureView.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 04/05/2023.
//

import SwiftUI

struct ProfilePictureView: View {
	
	@Binding var imageName: String
	
	var body: some View {
		Image(imageName)
			.resizable()
			.aspectRatio(contentMode: .fill)
			.frame(width: 110, height: 110)
			.clipShape(Circle())
			.overlay {
				Circle().stroke(.foreground, lineWidth: 2)
			}
	}
}

struct ProfilePictureView_Previews: PreviewProvider {
	static var previews: some View {
		ProfilePictureView(imageName: .constant("profile-1"))
	}
}
