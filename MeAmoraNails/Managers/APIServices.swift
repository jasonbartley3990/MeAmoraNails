//
//  APIServices.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import Alamofire

enum APIRoutes: String {
    case register = "/auth/register"
    case login = "/auth/login"
}

enum MLAPIRoutes: String {
    case newMeasurement = "/inference/newNailMeasurement"
    case MLHealth = "/inference/health"
}

//github

//https://github.com/Invonto-Development/Kiss-Nail-Measurement/blob/ml_update_tatyana/api/api_documentation.md
//https://github.com/Invonto-Development/Kiss-Nail-Measurement/blob/ml_update_tatyana/ml/api/mlapi/Mlapi_doc.md


class APIServices {
    
    public static let shared = APIServices()
    
    //qa
    private let MLBASE_URL_STRING = "https://kissnailqa.invontolabs.com/mlapi"
    private let BASE_URL_STRING = "https://kissnailqa.invontolabs.com/api"
    private let BASE_TRYON_ENDPOINT = "https://kissnailqa.invontolabs.com/tryOn/predict"
    
    //new dev url
//    private let BASE_URL_STRING = "https://kissnaildev.invontolabs.com/api"
//    private let MLBASE_URL_STRING = "https://kissnaildev.invontolabs.com/mlapi"
//    private let BASE_TRYON_ENDPOINT = "https://kissnaildev.invontolabs.com/tryOn/predict"
    
    var currentImagesStagedToSubmit: ImageData = ImageData()
    
    var currentCustomNailImageToSubmit: Data?
    
    var device: String = "iOS"
    
    func createUser(data: SignUpData, completion: @escaping (Bool, String?, UserAuthObject?) -> Void) {
        let parameters: Parameters = ["email": data.email ?? "", "firstname": data.firstName ?? "", "lastname": data.lastName ?? "", "password": data.password ?? ""]
        let url = URL(string: "\(BASE_URL_STRING)\(APIRoutes.register.rawValue)")
        
        AF.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: UserAuthObject.self) { (response) in
            switch response.result {
            case .success(let userObject):
                if (200...299).contains(response.response!.statusCode) {
                    guard let token = userObject.token else {
                        completion(false, "Something went wrong please try again", nil)
                        return
                    }
                    guard let firstName = userObject.firstname else {
                        completion(false, "Something went wrong please try again", nil)
                        return
                    }
                    guard let lastName = userObject.lastname else {
                        completion(false, "Something went wrong please try again", nil)
                        return
                    }
                    
                    guard let id = userObject.id else {
                        completion(false, "Something went wrong please try again", nil)
                        return
                    }
                    
                    guard let password = data.password else {
                        completion(false, "Something went wrong please try again", nil)
                        return
                    }
                    
                    let newUserObject = UserAuthObject(active: true, email: data.email, firstname: firstName, id: id, lastname: lastName, password: data.password, token: token)
                    KeyChainManager.shared.signOutUser(completion: {
                        success in
                        print("success: \(success)")
                    })
                    KeyChainManager.shared.saveUserObject(userObject: newUserObject,password: password)
                    completion(true, nil, newUserObject)
                } else {
                    completion(false, "Error logging in", nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false, "Error in creating account, please try again.", nil)
            }
        }
    }
    
    func loginUser(data: SignInData, email: String, password: String, completion: @escaping (Bool, String?, UserObject?, Bool) -> Void) {
        let parameters: Parameters = ["email": data.email ?? "", "password": data.password ?? ""]
        let url = URL(string: "\(BASE_URL_STRING)\(APIRoutes.login.rawValue)")
        
        AF.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: UserObject.self) { (response) in
            switch response.result {
            case .success(let userObject):
                if ((200...299).contains(response.response!.statusCode)) {
                    guard let token = userObject.token else {
                        completion(false, "Error decoding token", nil, false)
                        return
                    }
                    guard let firstName = userObject.firstname else {
                        completion(false, "Error decoding first name", nil, false)
                        return
                    }
                    guard let lastName = userObject.lastname else {
                        completion(false, "Error decoding last name", nil, false)
                        return
                    }
                    
                    guard let id = userObject.id else {
                        completion(false, "Error decoding id", nil, false)
                        return
                    }
                    
                    print("userObject: \(userObject)")
                    
                    var valid: Bool = false
                    var avatarId: Int = 1
                    var avatarName: String = ""
                    var avatarPath: String = ""
                    
                    if let validBool = userObject.valid_measurements {
                        valid = validBool
                    }
                    
                    if let avId = userObject.avatar_id {
                        avatarId = avId
                        print("avatar id: \(avId)")
                    }
                    
                    print("AVATAR name: \(userObject.avatar_name)")
                    
                    if let avName = userObject.avatar_name {
                        avatarName = avName
                    }
                    
                    if let avPath = userObject.avatar_path {
                        avatarPath = avPath
                    }
                    
                    
                    let newUserObject = UserAuthObject(active: true, email: email, firstname: firstName, id: id, lastname: lastName, password: password, token: token)
                    let newUserObject2 = UserObject(id: id, active: true, email: email, firstname: firstName, lastname: lastName, password: password, token: token, valid_measurements: valid, avatar_id: avatarId , avatar_name: avatarName, avatar_path: avatarPath)
                    KeyChainManager.shared.signOutUser(completion: {
                        success in
                        print("success: \(success)")
                    })
                    KeyChainManager.shared.saveUserObject(userObject: newUserObject, password: password)
                    completion(true, nil, newUserObject2, false)
                } else {
                        // return true on last boolean to indicate that email password combo is incoorect
                    completion(false, "Email password combo is incorrect", nil, true)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false, "Something went wrong", nil, false)
            }
        }
    }
    
    func uploadImages(retake: Bool, selectedNail: nailSelection, measurement: Int?, completion: @escaping (String?, UpdatedSaveNailImageResponse?) -> Void) {
        
        guard let url = URL(string: MLBASE_URL_STRING + MLAPIRoutes.newMeasurement.rawValue) else {
            return
        }
        
        guard let userObject = KeyChainManager.shared.getUserObject() else {
            completion("No logged in user.", nil)
            return
        }
        
        guard let userID = userObject.id else {
            completion("No logged in user id found.", nil)
            return
        }
        
        if !retake {
            
            AF.upload(multipartFormData: { multipartFormData in
                if let image = self.currentImagesStagedToSubmit.right_hand {
                    multipartFormData.append(image, withName: "right_hand_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                    
                }
                
                if let image = self.currentImagesStagedToSubmit.right_thumb {
                    multipartFormData.append(image, withName: "right_thumb_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                }
                
                if let image = self.currentImagesStagedToSubmit.left_hand {
                    multipartFormData.append(image, withName: "left_hand_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                }
                
                if let image = self.currentImagesStagedToSubmit.left_thumb {
                    multipartFormData.append(image, withName: "left_thumb_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                }
                
                multipartFormData.append(Data(String(userID).utf8), withName: "userid")
                multipartFormData.append(Data(String(self.device).utf8), withName: "device")
                multipartFormData.append(Data(String("iOS \(UIDevice.current.systemVersion)").utf8), withName: "deviceos")
                
                print(multipartFormData)
                
            }, to: url).responseDecodable(of: UpdatedSaveNailImageResponse.self) { response in
                switch response.result {
                case .success(let object):
                    print("new photo upload success")
                    completion(nil, object)
                case .failure(let error):
                    print("new photo upload failure")
                    completion(error.localizedDescription, nil)
                }
            }
        } else {
            guard let measurementId = measurement else {
                completion("no measurement id", nil)
                return
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                switch selectedNail {
                case .rightHand:
                    if let image = self.currentImagesStagedToSubmit.right_hand {
                        multipartFormData.append(image, withName: "right_hand_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                        multipartFormData.append(Data(String("").utf8), withName: "Right_thumb_file")
                        multipartFormData.append(Data(String("").utf8), withName: "left_hand_file")
                        multipartFormData.append(Data(String("").utf8), withName: "left_thumb_file")
                    }
                case .rightThumb:
                    if let image = self.currentImagesStagedToSubmit.right_thumb {
                        multipartFormData.append(image, withName: "right_thumb_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                        multipartFormData.append(Data(String("").utf8), withName: "Right_hand_file")
                        multipartFormData.append(Data(String("").utf8), withName: "left_hand_file")
                        multipartFormData.append(Data(String("").utf8), withName: "left_thumb_file")
                    }
                    
                case .leftHand:
                    if let image = self.currentImagesStagedToSubmit.left_hand {
                        multipartFormData.append(image, withName: "left_hand_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                        multipartFormData.append(Data(String("").utf8), withName: "Right_thumb_file")
                        multipartFormData.append(Data(String("").utf8), withName: "right_hand_file")
                        multipartFormData.append(Data(String("").utf8), withName: "left_thumb_file")
                    }
                    
                case .leftThumb:
                    if let image = self.currentImagesStagedToSubmit.left_thumb {
                        multipartFormData.append(image, withName: "left_thumb_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                        multipartFormData.append(Data(String("").utf8), withName: "Right_thumb_file")
                        multipartFormData.append(Data(String("").utf8), withName: "left_hand_file")
                        multipartFormData.append(Data(String("").utf8), withName: "right_hand_file")
                    }
                    
                }
                
                multipartFormData.append(Data(String(userID).utf8), withName: "userid")
                multipartFormData.append(Data(String(self.device).utf8), withName: "device")
                multipartFormData.append(Data(String("iOS \(UIDevice.current.systemVersion)").utf8), withName: "deviceos")
                multipartFormData.append(Data(String("\(measurementId)").utf8), withName: "measurementid")
                
            }, to: url).responseDecodable(of: UpdatedSaveNailImageResponse.self) { response in
                switch response.result {
                case .success(let object):
                    print("new photo upload success")
                    completion(nil, object)
                case .failure(let error):
                    print("new photo upload failure")
                    completion(error.localizedDescription, nil)
                }
            }
        }
        
    }
    
    /// If get measurements is true, this func will return your most recent manual measurements if they exist
    func getPostManualMeasurements(getMeasurements: Bool = false, measurements: Parameters?, completion: @escaping (String?, SaveNailImagesResponse?) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            completion("No logged in user", nil)
            return
        }
        
        var url: URL = URL(string: "\(BASE_URL_STRING)/nails/savemanualmeasurement")!
        var method: HTTPMethod = .post
        
        if getMeasurements == true {
            url = URL(string: "\(BASE_URL_STRING)/nails/getmanualmeasurement/\(currentUser.id ?? 0)")!
            method = .get
        }
        
        print("url : \(url)")
        
        AF.request(url, method: method, parameters: measurements, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? ""]).responseDecodable(of: SaveNailImagesResponse.self) { (response) in
            print("request \(response.request)")
            switch response.result {
            case .success(let previousMeasurements):
                if (200...299).contains(response.response!.statusCode) {
                    print("Success in getting post manual measurements")
                    completion(nil, previousMeasurements)
                } else {
                    var errorMessage = "Error getting previous measurement data for user. It's possible it doesn't exist."
                    if getMeasurements == false {
                        errorMessage = "Error posting new measurement data"
                    }
                    completion(errorMessage, nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil)
            }
        }
    }
    
    func getAllPreviousMeasurements(completion: @escaping (String?, PreviousSavedNailImageResponsesItem?) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            return
        }
        
        guard let id = currentUser.id else {
            return
        }

        var url = URLComponents(string: "\(BASE_URL_STRING)/nails/getallmeasurements")!
        
        //https://kissnaildev.invontolabs.com/api/nails/getallmeasurements"
        
        let queryItems = [URLQueryItem(name: "pgNum", value: "1"), URLQueryItem(name: "numPerPage", value: "10"), URLQueryItem(name: "errorSize", value: "0"), URLQueryItem(name: "userid", value: "\(id)")]
        url.queryItems = queryItems
        
        let result = url.url!

        let method: HTTPMethod = .get

        AF.request(result, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? ""]).responseDecodable(of: PreviousSavedNailImageResponsesItem.self) {
            (response) in
            switch response.result {
            case .success(let previousMeasurements):
                if (200...299).contains(response.response!.statusCode) {
                    print("Success in getting all previous measurements")
                    completion(nil, previousMeasurements)
                } else {
                    var errorMessage = "Error getting previous measurement data for user. It's possible it doesn't exist."
                    completion(errorMessage, nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil)
            }
        }
    }
    
    //gets all of a users successful measurements, omits the measurements with upload error.
    
    func getAllUsersSuccessfulMeasurements(completion: @escaping (SuccessfulMeasurements?, Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            return
        }
        
        guard let id = currentUser.id else {
            return
        }

        var url = URLComponents(string: "\(BASE_URL_STRING)/nails/getusermeasurements/\(id)")!
        
        //https://kissnaildev.invontolabs.com/api/nails/getusermeasurements/\(id)"
        
        let result = url.url!
        
        let method: HTTPMethod = .get
        
        AF.request(result, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? ""]).responseDecodable(of: SuccessfulMeasurements.self) {
            (response) in
            switch response.result {
            case .success(let previousMeasurements):
                if (200...299).contains(response.response!.statusCode) {
                    print("completion got successful measurements")
                    completion(previousMeasurements, true)
                } else {
                    print("got response back, but something is wrong")
                    completion(nil, false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil, false)
            }
        }
    }
    
    func updateUserAccount(user: User, completion: @escaping (String?, Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {return}
        let urlString = "\(BASE_URL_STRING)/user/update_user"
        
        if let url = URL(string: urlString) {
            let body: [String: Any] = [
                "id": user.id,
                "firstname" : user.firstname,
                "lastname": user.lastname,
                "email": user.email
            ]
            
            var request: URLRequest = try! URLRequest(url: url, method: .post)
            request.headers = ["Authorization": currentUser.token ?? "",  "Content-Type" : "application/json"]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            let dtt = try? JSONSerialization.data(withJSONObject: body)
            let task = URLSession.shared.uploadTask(with: request, from: dtt) {
                data, response, err in
                guard err == nil else {
                    completion(err?.localizedDescription, false)
                    return
                }
                guard let data = data else {
                    completion("something went wrong", false)
                    return
                }
                completion(nil, true)
            }.resume()
        }
    }
    
    func updateProfileCharacter(character: Int, completion: @escaping (Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {return}
        let urlString = "\(BASE_URL_STRING)/user/update_user"
        guard let id = currentUser.id else {
            completion(false)
            return
        }
        
        if let url = URL(string: urlString) {
            let body: [String: Any] = [
                "id": id,
                "avatar_id": character
            ]
            
            var request: URLRequest = try! URLRequest(url: url, method: .post)
            request.headers = ["Authorization": currentUser.token ?? "",  "Content-Type" : "application/json"]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            let dtt = try? JSONSerialization.data(withJSONObject: body)
            let task = URLSession.shared.uploadTask(with: request, from: dtt) {
                data, response, err in
                guard err == nil else {
                    print("error: \(err?.localizedDescription)")
                    completion(false)
                    return
                }
                guard let data = data else {
                    completion(false)
                    return
                }
                
                completion(true)
            }.resume()
        }
        
    }
    
    func resetPassword(newPassword: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {return}
        let urlString = "\(BASE_URL_STRING)/user/update_user"
        
        if let url = URL(string: urlString) {
            let body: [String: Any] = [
                "id": currentUser.id,
                "password": newPassword
            ]
            
            var request: URLRequest = try! URLRequest(url: url, method: .post)
            request.headers = ["Authorization": currentUser.token ?? "",  "Content-Type" : "application/json"]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            let dtt = try? JSONSerialization.data(withJSONObject: body)
            let task = URLSession.shared.uploadTask(with: request, from: dtt) {
                data, response, err in
                guard err == nil else {
                    completion(false)
                    return
                }
                guard let data = data else {
                    completion(false)
                    return
                }
                completion(true)
            }.resume()
        }
        
    }
    
    func getAllAvatars(completion: @escaping (AvatarList?, Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            completion(nil, false)
            return
        }
        let urlString = "\(BASE_URL_STRING)/user/getallavatars"
        var url: URL = URL(string: urlString)!
        let method: HTTPMethod = .get
        
        AF.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? ""]).responseDecodable(of: AvatarList.self) { (response)  in
            guard response.error == nil else {
                print(response.error?.localizedDescription)
                completion(nil, false)
                return
            }
            completion(response.value, true)
        }
        
    }
    
    func getNailSizes(completion: @escaping (NailSizesResponse?, Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            completion(nil, false)
            return
        }
        let urlString = "\(BASE_URL_STRING)/nails/getnailsizes"
        var url: URL = URL(string: urlString)!
        let method: HTTPMethod = .get
        
        //good code
        
        AF.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? ""]).responseDecodable(of:NailSizesResponse.self) { (response)  in
            guard response.error == nil else {
                completion(nil, false)
                return
            }
            
            print("success in nail sizes")
            completion(response.value, true)
        }
    }
    
    func tryOnPredict(completion: @escaping(Bool, String, UIImage?) -> Void) {
        
        guard let url = URL(string: BASE_TRYON_ENDPOINT) else {
            completion(false, "Could not get url", nil)
            return
        }
        
        
        guard let userObject = KeyChainManager.shared.getUserObject() else {
            completion(false, "No logged in user.", nil)
            return
        }
        
        guard let userID = userObject.id else {
            completion(false, "No logged in user id found.", nil)
            return
        }
        
        let parameters: Parameters = ["user_id": userObject.id, "device" : "iOS", "deviceos": "iOS", "hand_type": "NA"]
        
        AF.upload(multipartFormData: { multipartFormData in
            if let image = self.currentCustomNailImageToSubmit {
                multipartFormData.append(image, withName: "file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
            }
            
            multipartFormData.append(Data(String(userID).utf8), withName: "user_id")
            
            multipartFormData.append(Data(String(self.device).utf8), withName: "device")
            
            multipartFormData.append(Data(String("iOS \(UIDevice.current.systemVersion)").utf8), withName: "deviceos")
            
            multipartFormData.append(Data(String("NA").utf8), withName: "hand_type")
            
        }, to: url).response(completionHandler: {
            response in
            
            guard let data = response.data else {
                completion(false, "unable to get data from response", nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(false, "unable to convert into an image", nil)
                return
            }
            
            completion(true, "success", image)
            
        })
    }
    
    func getMarkedMeasurement(completion: @escaping (MarkedMeasurement?, Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            completion(nil, false)
            return
        }
        let urlString = "\(BASE_URL_STRING)/nails/getmarkedmeasurement/\(currentUser.id)"
        var url: URL = URL(string: urlString)!
        let method: HTTPMethod = .get
        
        AF.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? ""]).responseDecodable(of: MarkedMeasurement.self) { (response)  in

            guard response.error == nil else {
                print("marked meaz error: \(response.error?.localizedDescription)")
                completion(nil, false)
                return
            }
            
            completion(response.value, true)
        }
    }
    
    func markMeasurement(measurementId: Int, completion: @escaping (Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            completion(false)
            return
        }
        
        let urlString = "\(BASE_URL_STRING)/nails/markmeasurement"
        if let url: URL = URL(string: urlString) {
            let body: [String: Any] = [
                "user_id": currentUser.id,
                "measurements_id" : measurementId
            ]
            
            var request: URLRequest = try! URLRequest(url: url, method: .post)
            request.headers = ["Authorization": currentUser.token ?? "",  "Content-Type" : "application/json"]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            let dtt = try? JSONSerialization.data(withJSONObject: body)
            let task = URLSession.shared.uploadTask(with: request, from: dtt) {
                data, response, err in
                guard err == nil else {
                    completion(false)
                    return
                }
                guard data != nil else {
                    completion(false)
                    return
                }
                print("success in marking measurement")
                completion(true)
            }.resume()
        }
    }
    
    func testSpeed()  {
        let url = URL(string: "https://google.com")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let startTime = Date()
        
        let task = session.dataTask(with: request) { (data, resp, error) in
            let elapsed = CGFloat( Date().timeIntervalSince(startTime))
            
            guard error == nil && data != nil else{
                print("connection error or data is nill")
                return
            }
            
            guard resp != nil else{
                print("respons is nill")
                return
            }
            
            let mb  = CGFloat( (resp?.expectedContentLength)!) / 1000000.0
            
            print(mb)
            print("elapsed: \(elapsed)")
            
            print("Speed: \(mb/elapsed) Mb/sec")
        }
        
        task.resume()
        
    }
    
    //MARK: Legacy code (not in use in this app)

    func loginUserOld(data: SignInData, email: String, password: String, completion: @escaping (Bool, String?, UserAuthObject?, Bool) -> Void) {
        
        //MARK: no longer valid function
        
        let parameters: Parameters = ["email": data.email ?? "", "password": data.password ?? ""]
        let url = URL(string: "\(BASE_URL_STRING)\(APIRoutes.login.rawValue)")
        
        AF.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: UserAuthObject.self) { (response) in
            switch response.result {
            case .success(let userObject):
                if ((200...299).contains(response.response!.statusCode)) {
                    guard let token = userObject.token else {
                        completion(false, "Error decoding token", nil, false)
                        return
                    }
                    guard let firstName = userObject.firstname else {
                        completion(false, "Error decoding first name", nil, false)
                        return
                    }
                    guard let lastName = userObject.lastname else {
                        completion(false, "Error decoding last name", nil, false)
                        return
                    }
                    
                    guard let id = userObject.id else {
                        completion(false, "Error decoding id", nil, false)
                        return
                    }
                    
                    let newUserObject = UserAuthObject(active: true, email: email, firstname: firstName, id: id, lastname: lastName, password: password, token: token)
                    KeyChainManager.shared.signOutUser(completion: {
                        success in
                        print("success: \(success)")
                    })
                    KeyChainManager.shared.saveUserObject(userObject: newUserObject, password: password)
                    completion(true, nil, newUserObject, false)
                } else {
                        // return true on last boolean to indicate that email password combo is incoorect
                    completion(false, "Email password combo is incorrect", nil, true)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false, "Something went wrong", nil, false)
            }
        }
    }
    
    func uploadImagesOld(completion: @escaping (String?, SaveNailImagesResponse?) -> Void) {
        guard let url = URL(string: MLBASE_URL_STRING + MLAPIRoutes.newMeasurement.rawValue) else {
            return
        }
        
        guard let userObject = KeyChainManager.shared.getUserObject() else {
            completion("No logged in user.", nil)
            return
        }
        
        guard let userID = userObject.id else {
            completion("No logged in user id found.", nil)
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            if let image = self.currentImagesStagedToSubmit.right_hand {
                multipartFormData.append(image, withName: "right_hand_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
            }

            if let image = self.currentImagesStagedToSubmit.right_thumb {
                multipartFormData.append(image, withName: "right_thumb_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
            }

            if let image = self.currentImagesStagedToSubmit.left_hand {
                multipartFormData.append(image, withName: "left_hand_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
            }

            if let image = self.currentImagesStagedToSubmit.left_thumb {
                multipartFormData.append(image, withName: "left_thumb_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
            }

            multipartFormData.append(Data(String(userID).utf8), withName: "userid")
        }, to: url).responseDecodable(of: SaveNailImagesResponse.self) { response in
            switch response.result {
            case .success(let object):
                print("new photo upload success")
                completion(nil, object)
            case .failure(let error):
                print("new photo upload failure")
                completion(error.localizedDescription, nil)
            }
        }
    }
    
    //MARK: nail collections
    
    func SaveNailCollection(collection: SaveNailCollectionItem, completion: @escaping (Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            print("could not get current user")
            return
        }
        
        let urlString = "\(BASE_URL_STRING)/nails/savecollections"
        
        if let url = URL(string: urlString) {
            let body: [String: Any] = [
                "userid": collection.userid,
                "name": collection.name,
                "imageurl": collection.imageurl,
                "leftthumbcolor": collection.leftthumbcolor,
                "leftindexcolor": collection.leftindexcolor,
                "leftmiddlecolor": collection.leftmiddlecolor,
                "leftringcolor": collection.leftringcolor,
                "leftpinkycolor": collection.leftpinkycolor,
                "rightthumbcolor": collection.rightthumbcolor,
                "rightindexcolor": collection.rightindexcolor,
                "rightmiddlecolor": collection.rightmiddlecolor,
                "rightringcolor": collection.rightringcolor,
                "rightpinkycolor": collection.rightpinkycolor,
                "status": collection.status,
                "glossy": collection.glossy,
                "skintone": collection.skintone
            ]
            
            var request: URLRequest = try! URLRequest(url: url, method: .post)
            request.headers = ["Authorization": currentUser.token ?? "",  "Content-Type" : "application/json"]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            let dtt = try? JSONSerialization.data(withJSONObject: body)
            let task = URLSession.shared.uploadTask(with: request, from: dtt) {
                data, response, err in
                guard err == nil else {
                    print("error: \(err?.localizedDescription)")
                    completion(false)
                    return
                }
                guard let data = data else {
                    completion(false)
                    return
                }
                
                completion(true)
            }.resume()
        } else {
            print("not an url")
        }
    }
    
    func saveNailCollection2(collection: Parameters, completion: @escaping (Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            completion(false)
            return
        }
        
        var url: URL = URL(string:"\(BASE_URL_STRING)/nails/savecollections")!
        var method: HTTPMethod = .post
        
        print("url : \(url)")
        
        AF.request(url, method: method, parameters: collection, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? ""]).responseDecodable(of: NewSaveCollectionResponseItem.self) { (response) in
            switch response.result {
            case .success(let previousMeasurements):
                if (200...299).contains(response.response!.statusCode) {
                    print("Success in saving nail collection")
                    completion(true)
                } else {
                    print("Error posting new measurement data")
                   completion(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
        
        
    }
    
    func GetSavedNailCollections(completion: @escaping (CollectionList?, Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            completion(nil, false)
            return
        }
        
        guard let id = currentUser.id else {
            return
        }
        
        let urlString = "\(BASE_URL_STRING)/nails/getcollections/\(id)"
        let method: HTTPMethod = .get
        
        if let url =  URL(string: urlString) {
            AF.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? "", "Content-Type" : "application/json"]).responseDecodable(of: CollectionList.self) { (response)  in
                guard response.error == nil else {
                    completion(nil, false)
                    return
                }
                
                completion(response.value, true)
            }
        } else {
            print("could not convert url")
        }
        
    }
    
    //MARK: products
    
    func getAllProducts(completion: @escaping (ProductList?, Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            print("could not get current user")
            return
        }
        let urlString = "\(BASE_URL_STRING)/nails/getproducts"
        
        print(urlString)
        let method: HTTPMethod = .get
        
        if let url = URL(string: urlString) {
            AF.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? "", "Content-Type" : "application/json"]).responseDecodable(of: ProductList.self) { (response)  in
                guard response.error == nil else {
                    completion(nil, false)
                    return
                }
                
                completion(response.value, true)
            }
        } else {
            print("failed to get products")
            completion(nil, false)
        }
    }
    
    func deleteMeasurement(id: Int, completion: @escaping (DeleteMessage?, Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            print("could not get current user")
            completion(nil, false)
            return
        }
        let urlString = "\(BASE_URL_STRING)/nails/delete_measurement/\(id)"
        
        print(urlString)
        let method: HTTPMethod = .delete
        
        if let url = URL(string: urlString) {
            AF.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? "", "Content-Type" : "application/json"]).responseDecodable(of: DeleteMessage.self) { (response)  in
                guard response.error == nil else {
                    completion(nil, false)
                    return
                }
                
                completion(response.value, true)
            }
        } else {
            print("failed to delete")
            completion(nil, false)
        }
        
    }
    
    func createMeasurementId(completion: @escaping (MeasurementIdResponse?, Bool, String) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            print("could not get current user")
            return
        }
        
        guard let currentUserId = currentUser.id else {
            return
        }
        
        let urlString = "\(MLBASE_URL_STRING)/inference/createNewMeasurementId"
   
        let method: HTTPMethod = .post
        
        if let url = URL(string: urlString) {
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(String(currentUserId).utf8), withName: "userid")
                multipartFormData.append(Data(String(self.device).utf8), withName: "device")
                multipartFormData.append(Data(String("iOS \(UIDevice.current.systemVersion)").utf8), withName: "deviceos")
                multipartFormData.append(Data(String("12.0").utf8), withName: "focal_length")
                multipartFormData.append(Data(String("12.0").utf8), withName: "effective_focal_length")
                
            }, to: url).responseDecodable(of: MeasurementIdResponse.self) { response in
                switch response.result {
                case .success(let object):
                    print("new photo upload success")
                    completion(object, true, "got back id")
                case .failure(let error):
                    print("new photo upload failure")
                    completion(nil, false, "response failure")
                }
            }
        } else {
            print("failed to delete")
            completion(nil, false, "not a valid url")
            
        }
        
    }
    
    func newNailMeasurement(id: Int, nail: nailSelection, selfCapture: String, completion: @escaping(NewNailMeasurementResponse?, Bool, String?) -> Void) {
        guard let url = URL(string: "\(MLBASE_URL_STRING)/inference/newNailMeasurement") else {
            return
        }
    
        guard let userObject = KeyChainManager.shared.getUserObject() else {
            completion(nil, false, "Error")
            return
        }
    
        guard let userID = userObject.id else {
            completion(nil, false, "error")
            return
        }
    
        
        AF.upload(multipartFormData: { multipartFormData in
            if nail == .rightHand {
                if let image = self.currentImagesStagedToSubmit.right_hand {
                    multipartFormData.append(image, withName: "right_hand_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                }
            }
            
            if nail == .rightThumb {
                if let image = self.currentImagesStagedToSubmit.right_thumb {
                    multipartFormData.append(image, withName: "right_thumb_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                }
            }
            
            if nail == .leftHand {
                if let image = self.currentImagesStagedToSubmit.left_hand {
                    multipartFormData.append(image, withName: "left_hand_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                }
            }
            
            if nail == .leftThumb {
                if let image = self.currentImagesStagedToSubmit.left_thumb {
                    multipartFormData.append(image, withName: "left_thumb_file", fileName: "\(UUID().uuidString).png", mimeType: "image/png")
                }
            }
            
            multipartFormData.append(Data(String(userID).utf8), withName: "userid")
            multipartFormData.append(Data(String(self.device).utf8), withName: "device")
            multipartFormData.append(Data(String("iOS \(UIDevice.current.systemVersion)").utf8), withName: "deviceos")
            multipartFormData.append(Data(String("12.0").utf8), withName: "focal_length")
            multipartFormData.append(Data(String("12.0").utf8), withName: "effective_focal_length")
            multipartFormData.append(Data(String("\(id)").utf8), withName: "measurementid")
            //new
            multipartFormData.append(Data(String(selfCapture).utf8), withName: "self_capture")
            
            //new
            multipartFormData.append(Data(String("2").utf8), withName: "app_type")
            
        }, to: url).responseDecodable(of: NewNailMeasurementResponse.self) { response in
            switch response.result {
            case .success(let object):
                print("new photo upload success")
                completion(object, true, "success")
            case .failure(let error):
                print("new photo upload failure")
                completion(nil, false, error.localizedDescription)
            }
        }
    }
    
    func getHandPhotos(completion: @escaping (HandPhotoList?, Bool) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            print("could not get current user")
            completion(nil, false)
            return
        }
        let urlString = "\(BASE_URL_STRING)/nails/gethandphotos"
        
        let method: HTTPMethod = .get
        
        if let url = URL(string: urlString) {
            AF.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? "", "Content-Type" : "application/json"]).responseDecodable(of: HandPhotoList.self) { (response)  in
                guard response.error == nil else {
                    print("error: \(response.error)")
                    completion(nil, false)
                    return
                }
                        
                completion(response.value, true)
            }
        } else {
            print("failed to get hand photos")
            completion(nil, false)
        }
        
    }
    
    func deleteUser(completion: @escaping (Bool, String?) -> Void) {
        guard let currentUser = KeyChainManager.shared.getUserObject() else {
            print("could not get current user")
            completion(false, nil)
            return
        }
        
        let urlString = "\(BASE_URL_STRING)/user/delete_user/\(currentUser.id ?? 0)"
        
        let method: HTTPMethod = .delete
        
        if let url = URL(string: urlString) {
            AF.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": currentUser.token ?? "", "Content-Type" : "application/json"]).responseDecodable(of: DeleteMessage.self) { (response)  in
                guard response.error == nil else {
                    print("error: \(response.error)")
                    completion(false, nil)
                    return
                }
                        
                completion(true, response.value?.message)
            }
        } else {
            print("failed to get hand photos")
            completion(false, nil)
        }
        
        
    }
    
}

//MARK: Reset password




//MARK: json decoder helper

//            do {
//                let decoder = JSONDecoder()
//                let json = try JSONSerialization.jsonObject(with: data.value!!)
//                print(json)
//                let data = decoder.decode(SaveNailImagesResponse, from: data)
//            } catch {
//                print("unable to get json")
//            }

