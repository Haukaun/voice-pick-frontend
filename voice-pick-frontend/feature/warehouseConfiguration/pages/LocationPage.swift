//
//  LocationPage.swift
//  voice-pick-frontend
//
//  Created by tama on 22/04/2023.
//

import SwiftUI

let requestService = RequestService()

struct LocationPage: View {
    @EnvironmentObject var authService: AuthenticationService
    
    @State var locations: [Location] = []
    
    @State var searchField: String = ""
    
    @State var selectedLocation: Location?
    @State var isSheetPresent = false
    @State private var indexSetToDelete: IndexSet?
    @State private var showingAlert = false
    @State var errorMessage = ""
    @State var locationDeletedFromDb = false
    
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
                List {
                    ForEach(filteredLocations, id: \.self) { location in
                        HStack {
                            Text(location.code)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                selectedLocation = location
                                print(location)
                                isSheetPresent.toggle()
                                    
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    showingAlert = true
                                    indexSetToDelete = IndexSet(arrayLiteral: locations.firstIndex(of: location)!)
                                    selectedLocation = location
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }.tint(.red)
                            }
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    getLocations()
                }
                .onAppear {
                    getLocations()
                }
            }
            .padding(5)
            .alert("Fjern lokasjon", isPresented: $showingAlert, actions: {
                Button(role: .cancel) {} label: {
                    Text("Avbryt")
                }
                Button(role: .destructive){
                    if let indexSetToDelete = indexSetToDelete {
                        deleteLocation(locationId: selectedLocation?.code ?? "no location selected")
                        if locationDeletedFromDb {
                            locations.remove(atOffsets: indexSetToDelete)
                        }
                        locationDeletedFromDb = false
                    }
                } label: {
                    Text("Slett")
                }
            }, message: {
                Text("Er du sikker på at du vil fjerne denne lokasjonen fra varehuset ditt?")
            })
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Lokasjoner")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddLocationPage()) {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.traceLightYellow, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $isSheetPresent) {

            if (selectedLocation != nil) {
                LocationDetailsPage(
                    code: selectedLocation!.code,
                    controlDigits: selectedLocation!.controlDigits,
                    locationType: selectedLocation!.locationType
                )
            } else {
                Text("Error")
            }
        }
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
    
    func getLocationEntities(code: String) {
        requestService.get(path: "/locations/" + code, token: authService.accessToken, responseType: [Location].self, completion: { result in
            switch result {
            case .success(let locations):
                print(result)
                self.locations = locations
            case .failure(let error as RequestError):
                print(result)
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
                locationDeletedFromDb = true
                break
            case .failure(let error as RequestError):
                locationDeletedFromDb = false
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
    }
}
