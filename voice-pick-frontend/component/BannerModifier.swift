//
//  BannerModifier.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 11/04/2023.
//

import Foundation
import SwiftUI

enum BannerType {
	case Success
	case Error
	
	var tintColor: Color {
		switch self {
		case .Success:
			return Color.success
		case .Error:
			return Color.error
		}
	}
}

struct BannerModifier: ViewModifier {
	
	struct BannerData {
		var title: String
		var detail: String
		var type: BannerType
	}
	
	@Binding var data: BannerData
	@Binding var show: Bool
	
	func body(content: Content) -> some View {
		ZStack {
			content
			if show {
				ZStack {
					VStack {
						HStack {
							// Banner content
							VStack(alignment: .leading, spacing: 2) {
								Text(data.title)
									.bold()
								Text(data.detail)
							}
							Spacer()
						}
						.foregroundColor(Color.white)
						.padding(12)
						.background(data.type.tintColor)
						.cornerRadius(UIView.standardCornerRadius)
						Spacer()
					}
					.padding()
					.transition(AnyTransition.move(edge: .top).combined(with: .opacity))
					.onTapGesture {
						withAnimation {
							self.show = false
						}
					}
					.onAppear(perform: {
						DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
							withAnimation {
								self.show = false
							}
						}
					})
				}
				.zIndex(1)
			}
		}
	}
}

extension View {
	func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
		self.modifier(BannerModifier(data: data, show: show))
	}
}
