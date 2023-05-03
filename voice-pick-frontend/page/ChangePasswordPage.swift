//
//  ChangePasswordPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 26/04/2023.
//

import SwiftUI

struct ChangePasswordPage: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authService: AuthenticationService
    
    @State var currentPasswordField = ""
    @State var validCurrentPassword = true
    @State var newPasswordField = ""
    @State var validNewPassword = true
    
    @State var showAlert = false
    @State var alertMsg = ""
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var requestService = RequestService()
    let validator = Validator.shared
    
    func handleChangePassword() {
        validCurrentPassword = true
        validNewPassword = true
        
        if !validator.isValidPassword(currentPasswordField) {
            validCurrentPassword = false
        }
        
        if !validator.isValidPassword(newPasswordField) {
            validNewPassword = false
        }
        
        if validCurrentPassword && validNewPassword {
            requestService.post(
                path: "/auth/users/\(authService.uuid)/change-password",
                token: authService.accessToken,
                body: ChangePasswordRequest(
                    email: authService.email,
                    currentPassword: currentPasswordField,
                    newPassword: newPasswordField),
                responseType: LoginResponse.self,
                completion: { result in
                switch result {
                case .success(let loginResponse):
                    // Update tokens
                    DispatchQueue.main.async {
                        authService.accessToken = loginResponse.accessToken
                        authService.refreshToken = authService.refreshToken
                        presentationMode.wrappedValue.dismiss()
                    }
                case .failure(let error as RequestError):
                    if error.errorCode == 403 {
                        alertMsg = "Passordet er ugylig. Prøv på nytt"
                    } else if error.errorCode == 400 {
                        alertMsg = "Fant ikke bruker. Logg inn på nytt og prøv igjen"
                    } else {
                        alertMsg = "Noe gikk galt. Prøv på nytt"
                    }
                    showAlert = true
                case .failure(_):
                    alertMsg = "Noe gikk galt. Prøv på nytt"
                    showAlert = true
                }
            })
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("Tips: Hvis du har fått en kode gjennom 'glemt passord' kan du bruke den koden her til å velge nytt passord")
                        .opacity(0.6)
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
                VStack(alignment: .leading) {
                    PasswordInput(placeholder: "Nåværende passord", value: $currentPasswordField, valid: validCurrentPassword)
                    PasswordInput(placeholder: "Nytt passord", value: $newPasswordField, valid: validNewPassword)
                    if !validNewPassword {
                        DefaultLabel("Passord må minst inneholde 6 tegn!")
                            .foregroundColor(Color.error)
                    }
                    Divider()
                    DefaultButton("Endre passord", disabled: requestService.isLoading, onPress: {
                        handleChangePassword()
                    })
                }
            }
            .frame(maxHeight: .infinity)
            .padding(15)
            .background(Color.backgroundColor)
            .foregroundColor(Color.foregroundColor)

            if requestService.isLoading {
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
        .alert("Noe gikk galt", isPresented: $showAlert, actions: {}, message: { Text(alertMsg)}
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Endre password")
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {dismiss()}) {
                    Label("Return", systemImage: "chevron.backward")
                }
            }
        }
        .foregroundColor(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.traceLightYellow, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)

    }
}

struct ChangePasswordPage_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordPage()
    }
}
