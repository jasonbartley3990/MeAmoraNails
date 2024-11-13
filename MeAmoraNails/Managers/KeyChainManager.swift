//
//  KeyChainManager.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
enum KeyChainErrors: Error {
    case duplicateEntry
    case unknownError(OSStatus)
    case itemNotFound
}

final class KeyChainManager {
    static let shared = KeyChainManager()

    private init() {}
    
    private let passwordService: String = "KissUsaNailAppPasswordKey"
    private let emailService: String = "KissUsaNailAppEmailKey"
    private let firstNameService: String = "KissUsaNailAppFirstNameKey"
    private let lastNameService: String = "KissUsaNailAppLastNameKey"
    private let tokenService: String = "KissUsaNailAppTokenKey"
    private let currentUser: String = "currentUserKissUsaNailAppKey"
    private let idService: String = "KissUsaNailAppIdKey"

    public func saveEmail(email: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.emailService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: email as AnyObject,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            throw KeyChainErrors.duplicateEntry
        }

        guard status == errSecSuccess else {
            print("email save error")
            throw KeyChainErrors.unknownError(status)
        }

        print("key chain save successful")
    }

    public func getEmail() -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.emailService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String:kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

        print("status \(status)")

        return result as? Data
    }

    public func savePassword(account: String, password: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.passwordService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            throw KeyChainErrors.duplicateEntry
        }

        guard status == errSecSuccess else {
            print("password save error")
            throw KeyChainErrors.unknownError(status)
        }

        print("key chain save successful")
    }

    public func getPassword() -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.passwordService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String:kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

        print("status \(status)")

        return result as? Data
    }
    
    public func logOffEmail(email: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.emailService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: email as AnyObject,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeyChainErrors.unknownError(status)
        }
        
        print("email reset successful")
    }
    
    public func resetPassword(password: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.passwordService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeyChainErrors.unknownError(status)
        }
        
        print("password reset successful")
    }
    
    public func saveFistName(name: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.firstNameService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: name as AnyObject,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            throw KeyChainErrors.duplicateEntry
        }

        guard status == errSecSuccess else {
            print("First name save error")
            throw KeyChainErrors.unknownError(status)
        }

        print("key chain save successful")
    }

    public func getFirstName() -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.firstNameService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String:kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

        print("status \(status)")

        return result as? Data
    }
    
    public func resetFirstName(name: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.firstNameService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: name as AnyObject,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeyChainErrors.unknownError(status)
        }
        
        print("first name reset successful")
    }
    
    public func saveLastName(name: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.lastNameService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: name as AnyObject,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            throw KeyChainErrors.duplicateEntry
        }

        guard status == errSecSuccess else {
            print("Last name save error")
            throw KeyChainErrors.unknownError(status)
        }

        print("key chain save successful")
    }

    public func getLastName() -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.lastNameService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String:kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

        print("status \(status)")

        return result as? Data
    }
    
    public func resetLastName(name: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.lastNameService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: name as AnyObject,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeyChainErrors.unknownError(status)
        }
        
        print("Last name reset successful")
    }
    
    
    public func saveToken(token: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.tokenService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: token as AnyObject,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            throw KeyChainErrors.duplicateEntry
        }

        guard status == errSecSuccess else {
            print("token save error")
            throw KeyChainErrors.unknownError(status)
        }

        print("key chain save successful")
    }

    public func getToken() -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.tokenService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String:kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

        print("status \(status)")

        return result as? Data
    }
    
    public func resetToken(token: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.tokenService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: token as AnyObject,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeyChainErrors.unknownError(status)
        }
        
        print("token reset successful")
    }
    
    public func saveUserId(id: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.idService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: id as AnyObject,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status != errSecDuplicateItem else {
            throw KeyChainErrors.duplicateEntry
        }

        guard status == errSecSuccess else {
            print("id save error")
            throw KeyChainErrors.unknownError(status)
        }

        print("key chain save successful")
    }

    public func getId() -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.idService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String:kSecMatchLimitOne
        ]

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

        print("status \(status)")

        return result as? Data
    }
    
    public func resetId(id: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: self.idService as AnyObject,
            kSecAttrAccount as String: self.currentUser as AnyObject,
            kSecValueData as String: id as AnyObject,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeyChainErrors.unknownError(status)
        }
        
        print("id reset successful")
    }
    
    public func saveUserObject(userObject: UserAuthObject, password: String) -> Bool {
        
        guard let email = userObject.email else {return false}
        guard let emailData = userObject.email?.data(using: .utf8) else {return false}
        guard let passwordData = password.data(using: .utf8) else {return false}
        guard let firstNameData = userObject.firstname?.data(using: .utf8) else {return false}
        guard let lastNameData = userObject.lastname?.data(using: .utf8) else {return false}
        guard let id = userObject.id else {return false}
        let userIdString = String(id)
        guard let userIdData = userIdString.data(using: .utf8) else {return false}
        guard let tokenData = userObject.token?.data(using: .utf8) else {return false}
        
        do {
            try saveEmail(email: emailData)
            try savePassword(account: email, password: passwordData)
            try saveFistName(name: firstNameData)
            try saveLastName(name: lastNameData)
            try saveUserId(id: userIdData)
            try saveToken(token: tokenData)
        } catch {
            print("Could not save data: \(error)")
            return false
        }
        
        print("saved all data successfully")
        return true
    }
    
    
    
    public func getUserObject() -> UserAuthObject? {
        guard let emailData = self.getEmail() else {return nil}
        let email = String(decoding: emailData, as: UTF8.self)
        
        guard let passwordData = self.getPassword() else {return nil}
        guard let firstNameData = self.getFirstName() else {return nil}
        guard let lastNameData = self.getLastName() else {return nil}
        guard let tokenData = self.getToken() else {return nil}
        guard let idData = self.getId() else {return nil}
        
        let password = String(decoding: passwordData, as: UTF8.self)
        let firstName = String(decoding: firstNameData, as: UTF8.self)
        let lastName = String(decoding: lastNameData, as: UTF8.self)
        let token = String(decoding: tokenData, as: UTF8.self)
        let idString = String(decoding: idData, as: UTF8.self)
        
        guard let id = Int(idString) else {return nil}
        
        let userObject = UserAuthObject(active: true, email: email, firstname: firstName, id: id, lastname: lastName, password: password, token: token)
        return userObject
    }
    
    public func logInUser(completion: @escaping (Bool, UserObject?) -> Void) {
        print("here")
        guard let emailData = self.getEmail() else {
            completion(false, nil)
            return
        }
        let email = String(decoding: emailData, as: UTF8.self)
        print(email)
        
        guard let passwordData = self.getPassword() else {
            completion(false, nil)
            return
        }
        let password = String(decoding: passwordData, as: UTF8.self)
        print(password)
        
        let signInData = SignInData(email: email, password: password)
        APIServices.shared.loginUser(data: signInData, email: email, password: password, completion: { success, errorMsg, user, isValidCredentials in
             if success {
                 print("logged in user")
                 completion(true, user)
                 return
             } else {
                 print(errorMsg)
                 completion(false, nil)
                 return
             }
         })
    }
    
    public func signOutUser(completion: @escaping (Bool) -> Void) {
        if let emailData = self.getEmail() {
            do {
                try logOffEmail(email: emailData)
            } catch {
                print("could not log off user: \(error)")
                completion(false)
            }
        }
        
        if let passwordData = self.getPassword() {
            do {
                try resetPassword(password: passwordData)
            } catch {
                print("Could not reset password: \(error)")
                completion(false)
            }
        }
        if let firstNameData = self.getFirstName() {
            do {
                try resetFirstName(name: firstNameData)
            } catch {
                print("Could not reset first name: \(error)")
                completion(false)
            }
        }
        if let lastNameData = self.getLastName() {
            do {
                try resetLastName(name: lastNameData)
            } catch {
                print("Could not reset last name \(error)")
                completion(false)
            }
        }
        if let tokenData = self.getToken() {
            do {
                try resetToken(token: tokenData)
            } catch {
                print("Could not reset token: \(error)")
                completion(false)
            }
        }
        if let idData = self.getId() {
            do {
                try resetId(id: idData)
            } catch {
                print(" could not reset id: \(error)")
                completion(false)
            }
        }
        
        print("all data reset successfully")
        print("Logged off")
        completion(true)
    }
    
}
