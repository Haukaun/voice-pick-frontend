//
//  AddLocationPage.swift
//  voice-pick-frontend
//
//  Created by tama on 22/04/2023.
//

import SwiftUI

struct AddLocationPage: View {
    
    @EnvironmentObject var authService: AuthenticationService
    
    @State private var code: String = ""
    @State private var controlDigits: String = ""
    @State private var locationType: String = "PRODUCT"
    
    @State private var codeErrorMsg: String?
    @State private var controlDigitsErrorMsg: String?
    @State private var locationTypeErrorMsg: String?
    
    @State var showAlert = false;
    @State var errorMessage = "";
    @Environment(\.dismiss) private var dismiss

    func handleSubmit() {
        var validForm = true
        resetErrorMessages()
        
        if code.isEmpty {
            validForm = false
            codeErrorMsg = "No empty fields"
        }
        
        if controlDigits.isEmpty {
            validForm = false
            controlDigitsErrorMsg = "No empty fields"
        }
        
        if locationType.isEmpty {
            validForm = false
            locationTypeErrorMsg = "No empty fields"
        }
        
        if validForm {
            let location = Location(code: code, controlDigits: Int(controlDigits) ?? 0, locationType: locationType)
            addLocationRequest(location: location)
            dismiss()
        }
    }
    
    func resetErrorMessages() {
        codeErrorMsg = nil
        controlDigitsErrorMsg = nil
        locationTypeErrorMsg = nil
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                AddLocationField(
                    label: "Hyllekode",
                    value: $code,
                    errorMsg: $codeErrorMsg)
                AddLocationField(
                    label: "Kontroll nummer",
                    value: $controlDigits,
                    errorMsg: $controlDigitsErrorMsg,
                    type: .numberPad)
                LocationType(selectedLocationType: $locationType)
                Spacer()
                DefaultButton("Legg til lokasjon", disabled: false, onPress: {
                    handleSubmit()
                })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(10)
            .background(Color.backgroundColor)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                    Text("Lokasjoner")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.traceLightYellow, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    
    func addLocationRequest(location: Location) {
        requestService.post(path: "/locations", token: authService.accessToken, body: location, responseType: String.self, completion: { result in
            switch result {
            case .success(_):
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
     error handling
     */
    func handleError(errorCode: Int) {
        print(errorCode)
        switch errorCode {
        case 401:
            showAlert = true
            errorMessage = "Noe gikk galt, du har ikke nok rettigheter."
            break
        case 500:
            showAlert = true
            errorMessage = "Noe gikk galt med verifiseringen av en bruker."
            break
        default:
            showAlert = true;
            errorMessage = "Noe gikk galt, vennligst lukk applikasjonen og prøv på nytt, eller rapporter hendelsen."
            break
        }
    }
}

struct AddLocationField: View {
    let label: String
    @Binding var value: String
    @Binding var errorMsg: String?
    var type: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            DefaultInput(inputLabel: label, text: $value, valid: true, keyboardType: type)
            if let errorMsg = errorMsg {
                Text(errorMsg)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}




struct AddLocationPage_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationPage()
    }
}
