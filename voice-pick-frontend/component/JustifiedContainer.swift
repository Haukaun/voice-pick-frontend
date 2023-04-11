//
//  JustifiedContainer.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 17/03/2023.
//

import SwiftUI

struct JustifiedContainer<V: View>: View {
	let views: [V]
	
	init(_ views: V...) {
		self.views = views
	}
	
	init(_ views: [V]) {
		self.views = views
	}
	
	var body: some View {
		HStack {
			ForEach(views.indices, id: \.self) { i in
				views[i]
				if views.count > 1 && i < views.count - 1 {
					Spacer()
				}
			}
		}
	}
}

struct JustifiedContainer_Previews: PreviewProvider {
	static var previews: some View {
		JustifiedContainer([Text("YO"), Text("HELLO")])
	}
}
