//
//  CustomProgressView.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 04/05/2023.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
			ProgressView()
				.progressViewStyle(CircularProgressViewStyle())
				.scaleEffect(2)
				.frame(width: 100, height: 100)
				.background(Color.componentColor)
				.cornerRadius(20)
				.foregroundColor(.foregroundColor)
				.padding()
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
