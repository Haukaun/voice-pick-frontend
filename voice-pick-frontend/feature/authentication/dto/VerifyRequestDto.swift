//
//  EmailVerificationCode.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 30/03/2023.
//

import Foundation


struct VerifyRequestDto: Codable {
    let verificationCode: String
    let email: String
}
