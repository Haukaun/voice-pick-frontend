//
//  LocationType.swift
//  voice-pick-frontend
//
//  Created by tama on 22/04/2023.
//

import SwiftUI

struct LocationType: View {
    var locationTypes = ["PRODUCT", "PLUCK_LIST"]
    
    @EnvironmentObject private var pluckService: PluckService
    @Binding var selectedLocationType: String
    
    var body: some View {
        VStack {
            DisclosureGroup(content: {
                ScrollView {
                    VStack {
                        ForEach(locationTypes, id: \.self) { locationType in
                            locationTypeButton(title: locationType, action: { onSelectedString(locationType) })
                        }
                    }.padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                }
            }, label: {
                HStack {
                    Text("Type:")
                    Text(selectedLocationType)
                        .bold()
                        .foregroundColor(.foregroundColor)
                }
            })
            .accentColor(.mountain)
            .padding(15)
        }
        .background(Color.componentColor)
        .cornerRadius(5)
        
    }
    
    /**
     Set the string to the selected button
     */
    private func onSelectedString(_ locationType: String){
        selectedLocationType = locationType
    }
    
    /**
     Button for displaying the location type
     */
    func locationTypeButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Spacer()
            Text(title)
                .padding(15)
                .fontWeight(.bold)
                .font(.button)
                .foregroundColor(.snow)
            Spacer()
        }
        .background(Color.night)
        .cornerRadius(UIView.standardCornerRadius)
    }
}

struct LocationType_Previews: PreviewProvider {
    static var previews: some View {
        LocationType(locationTypes: ["PRODUCT", "PLUCK_LIST"], selectedLocationType: .constant(""))
            .environmentObject(PluckService())
    }
}
