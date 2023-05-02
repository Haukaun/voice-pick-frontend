//
//  WarehouseConfigurationPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 12/04/2023.
//

import SwiftUI

struct WarehouseConfigurationPage: View {
    
    let numberOfColumns = 2
    let numberOfRows = 2
    
    var body: some View {
        NavigationView {
            VStack {
                Header(headerText: "Varehus Konfigurasjon")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    NavigationLink(destination: ProductPage()) {
                        gridButton(label: "Produkter", icon: "shippingbox.fill")
                    }
									NavigationLink(destination: LocationPage()) {
                        gridButton(label: "Lokasjoner", icon: "map.fill")
                    }
                    NavigationLink(destination: EmployeesPage()) {
                        gridButton(label: "Brukere", icon: "person.fill")
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                Spacer()
            }
            .background(Color.backgroundColor)
        }
        .accentColor(.foregroundColor)
    }
    
    private func gridButton(label: String, icon: String) -> some View {
        Card {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                Text(label)
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            .foregroundColor(.foregroundColor)
        }
    }
    
}

struct WarehouseConfigurationPage_Previews: PreviewProvider {
    static var previews: some View {
        WarehouseConfigurationPage()
    }
}
