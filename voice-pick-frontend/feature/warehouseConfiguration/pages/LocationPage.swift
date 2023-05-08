//
//  LocationPage.swift
//  voice-pick-frontend
//
//  Created by tama on 22/04/2023.
//

import SwiftUI


struct LocationPage: View {
    @EnvironmentObject var authService: AuthenticationService
    @ObservedObject var requestService = RequestService()
    @State var locations: [Location] = []
    
    @State var searchField: String = ""
    
    @State private var selectedLocation: Location? = nil
    @State private var indexSetToDelete: IndexSet?
    @State private var showDeleteAlert = false
    @State private var showingAlert = false
    @State var errorMessage = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var filteredLocations: [Location] {
        if searchField.isEmpty {
            return locations
        } else {
            return locations.filter { location in
                location.code.localizedCaseInsensitiveContains(searchField)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DefaultInput(inputLabel: "Søk...", text: $searchField, valid: true)
                    .padding(5)
                List {
                    ForEach(filteredLocations, id: \.self) { location in
                        HStack {
                            Text(location.code)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                selectedLocation = location
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    showDeleteAlert = true
                                    indexSetToDelete = IndexSet(arrayLiteral: locations.firstIndex(of: location)!)
                                    selectedLocation = location
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }.tint(.red)
                            }
                    }
                    .listRowBackground(Color.backgroundColor)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .refreshable {
                    getLocations()
                }
                .onAppear {
                    getLocations()
                }
            }
            .background(Color.backgroundColor)
            .alert("Fjern lokasjon", isPresented: $showDeleteAlert, actions: {
                Button(role: .cancel) {} label: {
                    Text("Avbryt")
                }
                Button(role: .destructive){
                    
                    deleteLocation(locationId: selectedLocation?.code ?? "Not selected")
                    
                } label: {
                    Text("Slett")
                }
            }, message: {
                Text("Er du sikker på at du vil fjerne denne lokasjonen fra varehuset ditt?")
            })
        }
        .foregroundColor(Color.foregroundColor)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Lokasjoner")
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {dismiss()}) {
                    Label("Return", systemImage: "chevron.backward")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddLocationPage()) {
                    Image(systemName: "plus")
                }
            }
        }
        .foregroundColor(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.traceLightYellow, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .sheet(item: $selectedLocation, onDismiss: hideSheet) { location in
            UpdateLocationPage(location: location, locationCode: location.code)
        }
    }
    
    func hideSheet() {
        selectedLocation = nil
        getLocations()
    }
    
    func getLocations() {
        requestService.get(path: "/locations", token: authService.accessToken, responseType: [Location].self, completion: { result in
            switch result {
            case .success(let locations):
                self.locations = locations
            case .failure(let error as RequestError):
                handleError(errorCode: error.errorCode)
                break
            default:
                break
            }
        })
    }
    
    func deleteLocation(locationId: String) {
        requestService.delete(path: "/locations/" + locationId, token: authService.accessToken, responseType: String.self, completion: { result in
            switch result {
            case .success(_):
                selectedLocation = nil
                getLocations()
                break
            case .failure(let error as RequestError):
                handleError(errorCode: error.errorCode)
                break
            default:
                break
            }
        })
    }
    
    /**
     Error handling
     */
    func handleError(errorCode: Int) {
        switch errorCode {
        case 401:
            showingAlert = true
            errorMessage = "Noe gikk galt, du har ikke nok rettigheter."
            break
        case 500:
            showingAlert = true
            errorMessage = "Noe gikk galt med verifiseringen av en bruker."
            break
        default:
            showingAlert = true;
            errorMessage = "Noe gikk galt, vennligst lukk applikasjonen og prøv på nytt, eller rapporter hendelsen."
            break
        }
    }
    
}

struct LocationPage_Previews: PreviewProvider {
    static var previews: some View {
        LocationPage()
            .environmentObject(AuthenticationService())
    }
}
