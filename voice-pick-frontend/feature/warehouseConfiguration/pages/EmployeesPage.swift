//
//  EmployeesView.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 21/04/2023.
//

import SwiftUI

struct EmployeesPage: View {
	
	private let requestService = RequestService()
	@EnvironmentObject var authenticationService: AuthenticationService
	
	@Environment(\.dismiss) private var dismiss
	
	@State var employees: [User] = []
	
	@State var searchValue = ""
	@State var userToInvite = ""
	
	@State var selectedEmployee: User?
	
	@State var showAlert = false
	@State var indexSet: IndexSet = []
	
	@State var bannerData = BannerModifier.BannerData(title: "Feil", detail: "Noe gikk galt.", type: .Error)
	@State var showBanner = false
	
	var filteredEmployees: [User] {
		if searchValue.isEmpty {
			return employees.filter { employee in
				employee.uuid != authenticationService.uuid
			}
		} else {
			return employees.filter { employee in
				(
					employee.firstName.localizedCaseInsensitiveContains(searchValue)
					|| employee.lastName.localizedCaseInsensitiveContains(searchValue)
				)
				&&
				employee.uuid != authenticationService.uuid
			}
		}
	}
	
	func handleError(_ errorCode: Int) {
		switch errorCode {
		case 400:
			bannerData.detail = "Du hører ikke til et varehus."
		case 401:
			bannerData.detail = "Brukeren er ikke autentisert for denne handlingen."
		case 404:
			bannerData.detail = "Kunne ikke finne bruker i databasen."
		default:
			bannerData.detail = "Noe gikk galt."
		}
		showBanner = true
	}
	
	func delete(_ employeeToRemove: String) {
		requestService.delete(path: "/warehouse/users/\(employeeToRemove)", token: authenticationService.accessToken, responseType: String.self, completion: { result in
			switch result {
			case .success(_):
				employees.remove(atOffsets: indexSet)
			case .failure(let error as RequestError):
				handleError(error.errorCode)
			default:
				showBanner = true
			}
		})
	}
	
	func getEmployees() {
		requestService.get(path: "/warehouse/users", token: authenticationService.accessToken, responseType: [User].self, completion: { result in
			switch result {
			case .success(let employees):
				self.employees = employees
			case .failure(let error as RequestError):
				handleError(error.errorCode)
			default:
				showBanner = true
			}
		})
	}
	
	var body: some View {
		NavigationView {
			VStack {
				DefaultInput(inputLabel: "Søk...", text: $searchValue, valid: true)
					.padding(5)
				List {
					ForEach(filteredEmployees, id: \.uuid) { employee in
						HStack {
							Text(employee.firstName)
							Text(employee.lastName)
							Spacer()
							Image(systemName: "chevron.right")
						}
						.onTapGesture {
							selectedEmployee = employee
						}
						.swipeActions(edge: .trailing) {
							Button {
								showAlert = true
								indexSet = IndexSet(arrayLiteral: employees.firstIndex(of: employee)!)
								selectedEmployee = employee
							} label: {
								Label("Fjern", systemImage: "trash")
							}
							.tint(.red)
						}
					}
					.listRowBackground(Color.backgroundColor)
				}
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
				.onAppear(perform: getEmployees)
				.alert("Fjern ansatt", isPresented: $showAlert, actions: {
					Button(role: .cancel) {} label: {
						Text("Avbryt")
					}
					Button(role: .destructive) {
						if let employee = selectedEmployee {
							delete(employee.uuid)
						}
					} label: {
						Text("OK")
					}
				}, message: {
					Text("Er du sikker på at du vil fjerne denne brukeren fra varehuset ditt?")
				})
			}
			.background(Color.backgroundColor)
		}
		.foregroundColor(.foregroundColor)
		.banner(data: $bannerData, show: $showBanner)
		.toolbar {
			ToolbarItem(placement: .principal) {
				Text("Ansatte")
			}
			ToolbarItem(placement: .navigationBarLeading) {
				Button(action: {dismiss()}) {
					Label("Return", systemImage: "chevron.backward")
				}
			}
			ToolbarItem(placement: .navigationBarTrailing) {
				NavigationLink(destination: AddEmployeePage()) {
					Image(systemName: "plus")
				}
			}
		}
		.navigationBarBackButtonHidden(true)
		.foregroundColor(Color.night)
		.navigationBarTitleDisplayMode(.inline)
		.toolbarBackground(Color.traceLightYellow, for: .navigationBar)
		.toolbarBackground(.visible, for: .navigationBar)
		.sheet(item: $selectedEmployee, content: { employee in
			DetailedEmployeePage(employee: employee)
		})
	}
}

struct EmployeesView_Previews: PreviewProvider {
	static var previews: some View {
		EmployeesPage(employees: [
			User(uuid: "1", firstName: "Ola", lastName: "Nordmann", email: "ola@nordmann.no", roles: []),
			User(uuid: "2", firstName: "Henrik", lastName: "Ibsen", email: "henrik@ibsen.no", roles: [])
		])
		.environmentObject(AuthenticationService())
	}
}

