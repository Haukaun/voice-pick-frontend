//
//  DetailedEmployeePage.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 27/04/2023.
//

import SwiftUI

struct DetailedEmployeePage: View {
	
	@State var employee: User
	
	var body: some View {
		VStack {
			Text("\(employee.firstName)")
			Text("\(employee.lastName)")
			ForEach(employee.roles) { role in
				Text("\(role.type.rawValue)")
			}
		}
	}
}

struct DetailedEmployeePage_Previews: PreviewProvider {
	static var previews: some View {
		DetailedEmployeePage(employee: User(uuid: "123", firstName: "Ola", lastName: "Nordmann", email: "ola.nordmann@123.no", roles: []))
	}
}
