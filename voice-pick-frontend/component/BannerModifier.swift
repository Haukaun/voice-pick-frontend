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
							VStack() {
								VStack(spacing: 5) {
									Text(data.title)
										.font(.title3)
										.bold()
									Text(data.detail)
										.font(.bannerLabel)
								}
								.padding(EdgeInsets(top: 15, leading: 15, bottom: 5, trailing: 15))
								Rectangle()
									.fill(data.type.tintColor)
									.frame(maxWidth: .infinity, maxHeight: 10)
									.background(data.type.tintColor)
							}
							
						}
						.foregroundColor(Color.backgroundColor)
						.background(Color.foregroundColor)
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
