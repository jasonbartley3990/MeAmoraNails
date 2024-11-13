//
//  CreateAccountViewModel.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

final class CreateAccountViewModel: ObservableObject {
    
    @Published var firstName: String = "" {
        didSet {
            self.isActive()
        }
    }
    
    @Published var lastName: String = "" {
        didSet {
            self.isActive()
        }
    }
    
    @Published var email: String = "" {
        didSet {
            self.isActive()
        }
    }
    
    @Published var password: String = "" {
        didSet {
            self.isActive()
        }
    }
    
    @Published var confirmPassword: String = "" {
        didSet {
            self.isActive()
        }
    }
    
    @Published var alertItem: AccountCreationAlertItem?
    
    @Published var passwordHidden = true
    
    @Published var confirmPasswordHidden = true
    
    @Published var showCharacterScreen: Bool = false
    
    @Published var selectedCharacter: CharacterSelection = .one {
        didSet {
            didSelectCharacter()
        }
    }
    
    @Published var selectedCharacterName: String = "No Character Selected"
    
    @Published var selectedCharacterImage: String = "WaitingPageImage5"
    
    @Published var selectedCharacterId: Int = 0
    
    @Published var isNextButtonActive: Bool = false
    
    var isValidForm: Bool {
        guard !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            return false
        }
        return true
    }
    
    func isActive() {
        if self.isValidForm {
            self.isNextButtonActive = true
        } else {
            self.isNextButtonActive = false
        }
    }
    
    var isValidEmail: Bool  {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: email)
    }
    
    var isValidPasswordCount: Bool {
        if password.count < 8 {
            return false
        }
        return true
    }
    
    var passwordContainsADigit: Bool {
        if password.count < 5 {
            return false
        }
        return true
    }
    
    var passwordContainsUppercase: Bool {
        if containsUpperCase(password) {
            return false
        }
        return true
    }
    
    var passwordsMatch: Bool {
        if password == confirmPassword {
            return true
        } else {
            return false
        }
    }
    
    func createAccount(completion: @escaping (Bool, UserAuthObject?) -> Void) {
        guard isValidForm else {
            self.alertItem = AccountCreationAlertContext.invalidFields
            completion(false, nil)
            return
        }
        
        guard isValidEmail else {
            self.alertItem = AccountCreationAlertContext.invalidEmail
            completion(false, nil)
            return
        }
        
        guard isValidPasswordCount else {
            self.alertItem = AccountCreationAlertContext.passwordNotLongEnough
            completion(false, nil)
            return
        }
        
        guard passwordsMatch else {
            self.alertItem = AccountCreationAlertContext.passwordsDoNotMatch
            completion(false, nil)
            return
        }
        
        guard passwordContainsUppercase else {
            self.alertItem = AccountCreationAlertContext.passwordMustHaveAnUppercase
            completion(false, nil)
            return
        }
        
        guard self.selectedCharacter != .none else {
            self.alertItem = AccountCreationAlertContext.noCharacterChoosen
            completion(false, nil)
            return
        }
        
        let newData = SignUpData(firstName: firstName, lastName: lastName, email: email, password: password)
        
        APIServices.shared.createUser(data: newData) { [weak self] success, errMessage, user in
            if success {
                completion(true, user)
                self?.updateCharacter()
            } else {
                print(errMessage)
                completion(false, nil)
                self?.alertItem = AccountCreationAlertContext.unableToCreateAccount
            }
        }
    }
    
    func updateCharacter() {
        var id: Int = 1
        
        switch self.selectedCharacter {
        case .none:
            id = 1
        case .one:
            id = 1
        case .two:
            id = 2
        case .three:
            id = 3
        case .four:
            id = 4
        case .five:
            id = 5
        }
        
        print("Id to update \(id)")
        
        APIServices.shared.updateProfileCharacter(character: id, completion: {
            success in
            print("Successfully updated character...")
        })
    }
        
    func containsDigits(_ value: String) -> Bool {
        let regularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
    }
        
    func containsUpperCase(_ value: String) -> Bool {
        let regularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func didSelectCharacter() {
        switch self.selectedCharacter {
        case .none:
            self.selectedCharacterName = "No Character Selected"
        case .one:
            self.selectedCharacterName = "Feminine"
            self.selectedCharacterImage = "WaitingPageImage5"
            selectedCharacterId = 1
        case .two:
            self.selectedCharacterName = "Edgy"
            self.selectedCharacterImage = "WaitingPageImage1"
            selectedCharacterId = 2
        case .three:
            self.selectedCharacterName = "Humble"
            self.selectedCharacterImage = "WaitingPageImage2"
            self.selectedCharacterId = 3
        case .five:
            self.selectedCharacterName = "Laidback"
            self.selectedCharacterImage = "WaitingPageImage3"
            self.selectedCharacterId = 5
        case .four:
            self.selectedCharacterName = "Balance"
            self.selectedCharacterImage = "WaitingPageImage4"
            self.selectedCharacterId = 4
        }
    }
}
