//
//  SetupWarehouse.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 14/04/2023.
//

import SwiftUI

struct SetupWarehouse: View {
	
	@State var joinCodeValue = ""
	@State var warehouseName = ""
	@State var warehouseAddress = ""
	
	@State var showAlert = false
	@State var errorMessage = ""
	
	private let requestService = RequestService()
	
	private let defaultErrorMessage = "Noe gikk galt. Start appen på nytt, eller rapporter en bug."
	
	@EnvironmentObject var authenticationService: AuthenticationService
	
	/**
	 Sets the users warehouse information in the keychain.
	 - Parameters:
			- warehouse: warehouse information to add to users keychain.
	 */
	func setUserWarehouse(_ warehouse: WarehouseDto) {
		DispatchQueue.main.async {
			authenticationService.warehouseId = warehouse.id
			authenticationService.warehouseName = warehouse.name
			authenticationService.warehouseAddress = warehouse.address
		}
	}
	
	func createWareHouse() {
		let warehouse = AddWarehouseDto(name: warehouseName, address: warehouseAddress)
		requestService.post(path: "/warehouse", token: authenticationService.accessToken, body: warehouse, responseType: WarehouseDto.self, completion: { result in
			switch result {
			case .success(let warehouse):
				setUserWarehouse(warehouse)
			case .failure(let error as RequestError):
				if error.errorCode == 404 {
					showAlert = true
					errorMessage = "Bruker er ikke autentisert."
				}
			default:
				showAlert = true
				errorMessage = defaultErrorMessage
			}
		})
	}
	
	func joinWarehouse() {
		let verificationCodeInfo = VerifyRequestDto(verificationCode: joinCodeValue, email: authenticationService.email)
		requestService.post(path: "/warehouse/join", token: authenticationService.accessToken, body: verificationCodeInfo, responseType: WarehouseDto.self, completion: { result in
			switch result {
			case .success(let warehouse):
				setUserWarehouse(warehouse)
			case .failure(let error as RequestError):
				handleJoinError(error.errorCode)
			default:
				showAlert = true
				errorMessage = defaultErrorMessage
			}
		})
	}
	
	func handleJoinError(_ errorCode: Int) {
		switch errorCode {
		case 404:
			errorMessage = "Verifiserings koden er utgått, eller varehuset har blitt slettet."
		case 401:
			errorMessage = "Du er ikke autentisert. Prøv å logg ut og inn."
		default:
			errorMessage = defaultErrorMessage
		}
		showAlert = true
	}
	
	var body: some View {
		VStack {
			Title("Sett opp varehus")
			Spacer()
			VStack(alignment: .leading) {
				SubTitle("Bli med i varehus")
				DefaultInput(inputLabel: "PIN kode", text: $joinCodeValue, valid: true)
					.padding(.init(.bottom))
				DefaultButton("Bli med", onPress: joinWarehouse)
				HStack {
					VStack {
						Divider()
							.background(Color.foregroundColor)
					}
					Paragraph("eller")
					VStack {
						Divider()
							.background(Color.foregroundColor)
					}
				}
				.padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
				SubTitle("Opprett varehus")
				DefaultInput(inputLabel: "Varehus navn", text: $warehouseName, valid: true)
					.padding(.init(top: 0, leading: 0, bottom: 5, trailing: 0))
				DefaultInput(inputLabel: "Varehus addresse", text: $warehouseAddress, valid: true)
					.padding(.bottom)
				DefaultButton("Opprett", onPress: createWareHouse)
			}
			Spacer()
			
		}
		.padding(10)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.backgroundColor)
		.alert("Error", isPresented: $showAlert, actions: {}, message: { Text("\(errorMessage)") })
	}
}

struct SetupWarehouse_Previews: PreviewProvider {
	static var previews: some View {
		SetupWarehouse()
	}
}
