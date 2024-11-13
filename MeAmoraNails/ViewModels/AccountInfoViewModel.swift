//
//  AccountInfoViewModel.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import SwiftUI

final class AccountInfoViewModel: ObservableObject {
    
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
    
    @Published var alertItem: AccountInfoAlertItem?
    
    @Published var isNextButtonActive: Bool = false
    
    @Published var showDeleteAccountPopUp: Bool = false
    
    @Published var showAccountInfoSaved: Bool = false
    
    @Published var showSomethingWrongPopUp: Bool = false
    
    var isValidForm: Bool {
        guard !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty else {
            return false
        }
        return true
    }
    
    func isActive() {
        if isValidForm {
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
    
    func saveData(id: Int, completion: @escaping (Bool, UserAuthObject?) -> Void) {
        guard isValidForm else {
            self.alertItem = AccountInfoAlertContext.invalidFields
            completion(false, nil)
            return
        }
        
        guard isValidEmail else {
            self.alertItem = AccountInfoAlertContext.invalidEmail
            completion(false, nil)
            return
        }
        
        guard let passwordData = KeyChainManager.shared.getPassword() else {
            self.showSomethingWrongPopUp = true
            completion(false, nil)
            return
        }
        
        guard let tokenData = KeyChainManager.shared.getToken() else {
            self.showSomethingWrongPopUp = true
            completion(false, nil)
            return
        }
        
        let password = String(decoding: passwordData, as: UTF8.self)
        let token = String(decoding: tokenData, as: UTF8.self)
        
        let user = User(active: true, firstname: firstName, lastname: lastName, id: id, password: password, email: email)
        
        APIServices.shared.updateUserAccount(user: user, completion: {
            [weak self] err, success in
            if success {
                self?.showAccountInfoSaved = true
                let userAuthObject = UserAuthObject(active: true, email: self?.email, firstname: self?.firstName, id: id, lastname: self?.lastName, password: password, token: token)
                KeyChainManager.shared.saveUserObject(userObject: userAuthObject, password: password)
                completion(true, userAuthObject)
            } else {
                self?.showSomethingWrongPopUp = true
                completion(false, nil)
            }

        })
    }
    
    
    
}
