//
//  ProductPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 12/04/2023.
//

import SwiftUI

import SwiftUI

struct ProductPage: View {
	
	@EnvironmentObject var authenticationService: AuthenticationService
	@ObservedObject var requestService = RequestService()
	@State private var products: [ProductDto] = []
	
	@State var searchField: String = ""
	
	@State var selectedProduct: ProductDto?
	@State var isSheetPresent = false
	
	func fetchProducts() {
		requestService.get(path: "/products", token: authenticationService.accessToken, responseType: [ProductDto].self) { result in
			switch result {
			case .success(let fetchedProducts):
				self.products = fetchedProducts
			case .failure(let error as RequestError):
				print(error)
				// Handle the error here
				print("Error: \(error.localizedDescription)")
			default:
				break
			}
		}
	}
	
	var body: some View {
		NavigationView {
			VStack {
				DefaultInput(inputLabel: "Søk...", text: $searchField, valid: true)
				ForEach(products, id: \.self) { product in
					Card {
						HStack {
							Text(product.name)
							Spacer()
							Image(systemName: "chevron.up")
						}
						.frame(maxWidth: .infinity)
					}
					.onTapGesture {
						selectedProduct = product
						isSheetPresent.toggle()
					}
				}
				Spacer()
			}
			.padding(5)
		}
		.onAppear{
			fetchProducts()
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Produkter")
			}
			ToolbarItem(placement: .navigationBarTrailing) {
				NavigationLink(destination: AddProductPage()) {
					Image(systemName: "plus")
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(Color.traceLightYellow, for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.sheet(isPresented: $isSheetPresent) {
			if let selectedProduct = selectedProduct {
				UpdateProductPage(product: selectedProduct)
			} else {
				Text("Error")
			}
		}
	}
}


struct ProductPage_Previews: PreviewProvider {
	static var previews: some View {
		ProductPage()
	}
}
