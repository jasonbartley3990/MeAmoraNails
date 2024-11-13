//
//  Models.swift
//  MeAmoraNails
//
//  Created by Jason bartley on 11/1/24.
//

import Foundation
import UIKit

struct SignUpData {
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
}

struct SignInData {
    var email: String?
    var password: String?
}

struct UserObject: Codable {
    let id: Int?
    let active: Bool?
    let email: String?
    let firstname: String?
    let lastname: String?
    let password: String?
    let token: String?
    let valid_measurements: Bool?
    var avatar_id: Int?
    let avatar_name: String?
    let avatar_path: String?
    
}

struct ImageData {
    var right_hand: Data?
    var right_thumb: Data?
    var left_hand: Data?
    var left_thumb: Data?
}

enum Fingers: Int {
    case thumb
    case index
    case middle
    case ring
    case pinky
    
    var name: String {
        switch self {
        case .thumb:
            return "Thumb"
        case .index:
            return "Index"
        case .middle:
            return "Middle"
        case .ring:
            return "Ring"
        case .pinky:
            return "Pinky"
        }
    }
}

struct CustomNailCollection {
    let name: String
}

// MARK: - SaveNailImagesResponse

//old data model

struct SaveNailImagesResponse: Codable {
    var createddate, device, deviceos: String?
    var id: Int?
    var lastmodifieddate, leftHandImage, leftHandMarkedImage: String?
    var leftHandProcessingIssue: String?
    var leftIndexLength: Double?
    var leftIndexSize: Int?
    var leftIndexWidth: Double?
    var leftMiddleLength: Double?
    var leftMiddleSize: Int?
    var leftMiddleWidth: Double?
    var leftPinkyLength: Double?
    var leftPinkySize: Int?
    var leftPinkyWidth: Double?
    var leftRingLength: Double?
    var leftRingSize: Int?
    var leftRingWidth: Double?
    var leftThumbImage: String?
    var leftThumbLength: Double?
    var leftThumbMarkedImage: String?
    var leftThumbProcessingIssue: String?
    var leftThumbSize: Int?
    var leftThumbWidth: Double?
    var measurementsid: Int?
    var rightHandImage, rightHandMarkedImage: String?
    var rightHandProcessingIssue: String?
    var rightIndexLength: Double?
    var rightIndexSize: Int?
    var rightIndexWidth: Double?
    var rightMiddleLength: Double?
    var rightMiddleSize: Int?
    var rightMiddleWidth: Double?
    var rightPinkyLength: Double?
    var rightPinkySize: Int?
    var rightPinkyWidth: Double?
    var rightRingLength: Double?
    var rightRingSize: Int?
    var rightRingWidth: Double?
    var rightThumbImage: String?
    var rightThumbLength: Double?
    var rightThumbMarkedImage: String?
    var rightThumbProcessingIssue: String?
    var rightThumbSize: Int?
    var rightThumbWidth: Double?
    var usersid: MetadataType?

    enum CodingKeys: String, CodingKey {
        case createddate, device, deviceos, id, lastmodifieddate
        case leftHandImage = "left_hand_image"
        case leftHandMarkedImage = "left_hand_marked_image"
        case leftHandProcessingIssue = "left_hand_processing_issue"
        case leftIndexLength = "left_index_length"
        case leftIndexSize = "left_index_size"
        case leftIndexWidth = "left_index_width"
        case leftMiddleLength = "left_middle_length"
        case leftMiddleSize = "left_middle_size"
        case leftMiddleWidth = "left_middle_width"
        case leftPinkyLength = "left_pinky_length"
        case leftPinkySize = "left_pinky_size"
        case leftPinkyWidth = "left_pinky_width"
        case leftRingLength = "left_ring_length"
        case leftRingSize = "left_ring_size"
        case leftRingWidth = "left_ring_width"
        case leftThumbImage = "left_thumb_image"
        case leftThumbLength = "left_thumb_length"
        case leftThumbMarkedImage = "left_thumb_marked_image"
        case leftThumbProcessingIssue = "left_thumb_processing_issue"
        case leftThumbSize = "left_thumb_size"
        case leftThumbWidth = "left_thumb_width"
        case measurementsid
        case rightHandImage = "right_hand_image"
        case rightHandMarkedImage = "right_hand_marked_image"
        case rightHandProcessingIssue = "right_hand_processing_issue"
        case rightIndexLength = "right_index_length"
        case rightIndexSize = "right_index_size"
        case rightIndexWidth = "right_index_width"
        case rightMiddleLength = "right_middle_length"
        case rightMiddleSize = "right_middle_size"
        case rightMiddleWidth = "right_middle_width"
        case rightPinkyLength = "right_pinky_length"
        case rightPinkySize = "right_pinky_size"
        case rightPinkyWidth = "right_pinky_width"
        case rightRingLength = "right_ring_length"
        case rightRingSize = "right_ring_size"
        case rightRingWidth = "right_ring_width"
        case rightThumbImage = "right_thumb_image"
        case rightThumbLength = "right_thumb_length"
        case rightThumbMarkedImage = "right_thumb_marked_image"
        case rightThumbProcessingIssue = "right_thumb_processing_issue"
        case rightThumbSize = "right_thumb_size"
        case rightThumbWidth = "right_thumb_width"
        case usersid
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createddate = try container.decodeIfPresent(String.self, forKey: .createddate)
        self.device = try container.decodeIfPresent(String.self, forKey: .device)
        self.deviceos = try container.decodeIfPresent(String.self, forKey: .deviceos)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.lastmodifieddate = try container.decodeIfPresent(String.self, forKey: .lastmodifieddate)
        self.leftHandImage = try container.decodeIfPresent(String.self, forKey: .leftHandImage)
        self.leftHandMarkedImage = try container.decodeIfPresent(String.self, forKey: .leftHandMarkedImage)
        do {
            self.leftHandProcessingIssue = try container.decodeIfPresent(String.self, forKey: .leftHandProcessingIssue)
        } catch {
            self.leftHandProcessingIssue = nil
        }
        self.leftIndexLength = try container.decodeIfPresent(Double.self, forKey: .leftIndexLength)
        self.leftIndexSize = try container.decodeIfPresent(Int.self, forKey: .leftIndexSize)
        self.leftIndexWidth = try container.decodeIfPresent(Double.self, forKey: .leftIndexWidth)
        self.leftMiddleLength = try container.decodeIfPresent(Double.self, forKey: .leftMiddleLength)
        self.leftMiddleSize = try container.decodeIfPresent(Int.self, forKey: .leftMiddleSize)
        self.leftMiddleWidth = try container.decodeIfPresent(Double.self, forKey: .leftMiddleWidth)
        self.leftPinkyLength = try container.decodeIfPresent(Double.self, forKey: .leftPinkyLength)
        self.leftPinkySize = try container.decodeIfPresent(Int.self, forKey: .leftPinkySize)
        self.leftPinkyWidth = try container.decodeIfPresent(Double.self, forKey: .leftPinkyWidth)
        self.leftRingLength = try container.decodeIfPresent(Double.self, forKey: .leftRingLength)
        self.leftRingSize = try container.decodeIfPresent(Int.self, forKey: .leftRingSize)
        self.leftRingWidth = try container.decodeIfPresent(Double.self, forKey: .leftRingWidth)
        self.leftThumbImage = try container.decodeIfPresent(String.self, forKey: .leftThumbImage)
        self.leftThumbLength = try container.decodeIfPresent(Double.self, forKey: .leftThumbLength)
        self.leftThumbMarkedImage = try container.decodeIfPresent(String.self, forKey: .leftThumbMarkedImage)
        do {
            self.leftThumbProcessingIssue = try container.decodeIfPresent(String.self, forKey: .leftThumbProcessingIssue)
        } catch {
            self.leftThumbProcessingIssue = nil
        }
        self.leftThumbSize = try container.decodeIfPresent(Int.self, forKey: .leftThumbSize)
        self.leftThumbWidth = try container.decodeIfPresent(Double.self, forKey: .leftThumbWidth)
        self.measurementsid = try container.decodeIfPresent(Int.self, forKey: .measurementsid)
        self.rightHandImage = try container.decodeIfPresent(String.self, forKey: .rightHandImage)
        self.rightHandMarkedImage = try container.decodeIfPresent(String.self, forKey: .rightHandMarkedImage)
        do {
            self.rightHandProcessingIssue = try container.decodeIfPresent(String.self, forKey: .rightHandProcessingIssue)
        } catch {
            self.rightHandProcessingIssue = nil
        }
        
        self.rightIndexLength = try container.decodeIfPresent(Double.self, forKey: .rightIndexLength)
        self.rightIndexSize = try container.decodeIfPresent(Int.self, forKey: .rightIndexSize)
        self.rightIndexWidth = try container.decodeIfPresent(Double.self, forKey: .rightIndexWidth)
        self.rightMiddleLength = try container.decodeIfPresent(Double.self, forKey: .rightMiddleLength)
        self.rightMiddleSize = try container.decodeIfPresent(Int.self, forKey: .rightMiddleSize)
        self.rightMiddleWidth = try container.decodeIfPresent(Double.self, forKey: .rightMiddleWidth)
        self.rightPinkyLength = try container.decodeIfPresent(Double.self, forKey: .rightPinkyLength)
        self.rightPinkySize = try container.decodeIfPresent(Int.self, forKey: .rightPinkySize)
        self.rightPinkyWidth = try container.decodeIfPresent(Double.self, forKey: .rightPinkyWidth)
        self.rightRingLength = try container.decodeIfPresent(Double.self, forKey: .rightRingLength)
        self.rightRingSize = try container.decodeIfPresent(Int.self, forKey: .rightRingSize)
        self.rightRingWidth = try container.decodeIfPresent(Double.self, forKey: .rightRingWidth)
        self.rightThumbImage = try container.decodeIfPresent(String.self, forKey: .rightThumbImage)
        self.rightThumbLength = try container.decodeIfPresent(Double.self, forKey: .rightThumbLength)
        self.rightThumbMarkedImage = try container.decodeIfPresent(String.self, forKey: .rightThumbMarkedImage)
        do {
            self.rightThumbProcessingIssue = try container.decodeIfPresent(String.self, forKey: .rightThumbProcessingIssue)
        } catch {
            self.rightThumbProcessingIssue = nil
        }
        self.rightThumbSize = try container.decodeIfPresent(Int.self, forKey: .rightThumbSize)
        self.rightThumbWidth = try container.decodeIfPresent(Double.self, forKey: .rightThumbWidth)
        self.usersid = try container.decodeIfPresent(MetadataType.self, forKey: .usersid)
    }
}

struct UpdatedSaveNailImageResponse: Codable {
    let id: Int?
    let userid: Int?
    let left_hand_image: String?
    let left_thumb_image: String?
    let right_hand_image: String?
    let right_thumb_image: String?
    let left_hand_marked_image: String?
    let left_thumb_marked_image: String?
    let right_hand_marked_image: String?
    let right_thumb_marked_image: String?
    let left_hand_processing_issue: String?
    let left_thumb_processing_issue: String?
    let right_hand_processing_issue: String?
    let right_thumb_processing_issue: String?
    let device: String?
    let deviceos: String?
    let createddate: String?
    let lastmodifieddate: String?
    let usersid: MetadataType? //Int?
    let measurementsid: Int?
    let left_pinky_width: Double?
    let left_ring_width: Double?
    let left_middle_width: Double?
    let left_index_width: Double?
    let left_thumb_width: Double?
    let right_pinky_width: Double?
    let right_ring_width: Double?
    let right_middle_width: Double?
    let right_index_width: Double?
    let right_thumb_width: Double?
    let left_pinky_length: Double?
    let left_ring_length: Double?
    let left_middle_length: Double?
    let left_index_length: Double?
    let left_thumb_length: Double?
    let right_pinky_length: Double?
    let right_ring_length: Double?
    let right_middle_length: Double?
    let right_index_length: Double?
    let right_thumb_length: Double?
    let left_pinky_size: Int?
    let left_ring_size: Int?
    let left_middle_size: Int?
    let left_index_size: Int?
    let left_thumb_size: Int?
    let right_pinky_size: Int?
    let right_ring_size: Int?
    let right_middle_size: Int?
    let right_index_size: Int?
    let right_thumb_size: Int?
    let card_seg_model: String?
    let nails_seg_model: String?
    let git_commit_id: String?
    let processed_time: Double?
    
    enum CodingKeys: CodingKey {
        case id
        case userid
        case left_hand_image
        case left_thumb_image
        case right_hand_image
        case right_thumb_image
        case left_hand_marked_image
        case left_thumb_marked_image
        case right_hand_marked_image
        case right_thumb_marked_image
        case left_hand_processing_issue
        case left_thumb_processing_issue
        case right_hand_processing_issue
        case right_thumb_processing_issue
        case device
        case deviceos
        case createddate
        case lastmodifieddate
        case usersid
        case measurementsid
        case left_pinky_width
        case left_ring_width
        case left_middle_width
        case left_index_width
        case left_thumb_width
        case right_pinky_width
        case right_ring_width
        case right_middle_width
        case right_index_width
        case right_thumb_width
        case left_pinky_length
        case left_ring_length
        case left_middle_length
        case left_index_length
        case left_thumb_length
        case right_pinky_length
        case right_ring_length
        case right_middle_length
        case right_index_length
        case right_thumb_length
        case left_pinky_size
        case left_ring_size
        case left_middle_size
        case left_index_size
        case left_thumb_size
        case right_pinky_size
        case right_ring_size
        case right_middle_size
        case right_index_size
        case right_thumb_size
        case card_seg_model
        case nails_seg_model
        case git_commit_id
        case processed_time
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.userid = try container.decodeIfPresent(Int.self, forKey: .userid)
        self.left_hand_image = try container.decodeIfPresent(String.self, forKey: .left_hand_image)
        self.left_thumb_image = try container.decodeIfPresent(String.self, forKey: .left_thumb_image)
        self.right_hand_image = try container.decodeIfPresent(String.self, forKey: .right_hand_image)
        self.right_thumb_image = try container.decodeIfPresent(String.self, forKey: .right_thumb_image)
        self.left_hand_marked_image = try container.decodeIfPresent(String.self, forKey: .left_hand_marked_image)
        self.left_thumb_marked_image = try container.decodeIfPresent(String.self, forKey: .left_thumb_marked_image)
        self.right_hand_marked_image = try container.decodeIfPresent(String.self, forKey: .right_hand_marked_image)
        self.right_thumb_marked_image = try container.decodeIfPresent(String.self, forKey: .right_thumb_marked_image)
        
        
        do {
            self.left_hand_processing_issue = try container.decodeIfPresent(String.self, forKey: .left_hand_processing_issue)
        } catch {
            self.left_hand_processing_issue = nil
        }
        
        
        do {
            self.left_thumb_processing_issue = try container.decodeIfPresent(String.self, forKey: .left_thumb_processing_issue)
        } catch {
            self.left_thumb_processing_issue = nil
        }
        
        
        do {
            self.right_hand_processing_issue = try container.decodeIfPresent(String.self, forKey: .right_hand_processing_issue)
        } catch {
            self.right_hand_processing_issue = nil
        }
        
        do {
            self.right_thumb_processing_issue = try container.decodeIfPresent(String.self, forKey: .right_thumb_processing_issue)
        } catch {
            self.right_thumb_processing_issue = nil
        }
        
        self.device = try container.decodeIfPresent(String.self, forKey: .device)
        self.deviceos = try container.decodeIfPresent(String.self, forKey: .deviceos)
        self.createddate = try container.decodeIfPresent(String.self, forKey: .createddate)
        self.lastmodifieddate = try container.decodeIfPresent(String.self, forKey: .lastmodifieddate)
        self.usersid = try container.decodeIfPresent(MetadataType.self, forKey: .usersid)
        self.measurementsid = try container.decodeIfPresent(Int.self, forKey: .measurementsid)
        self.left_pinky_width = try container.decodeIfPresent(Double.self, forKey: .left_pinky_width)
        self.left_ring_width = try container.decodeIfPresent(Double.self, forKey: .left_ring_width)
        self.left_middle_width = try container.decodeIfPresent(Double.self, forKey: .left_middle_width)
        self.left_index_width = try container.decodeIfPresent(Double.self, forKey: .left_index_width)
        self.left_thumb_width = try container.decodeIfPresent(Double.self, forKey: .left_thumb_width)
        self.right_pinky_width = try container.decodeIfPresent(Double.self, forKey: .right_pinky_width)
        self.right_ring_width = try container.decodeIfPresent(Double.self, forKey: .right_ring_width)
        self.right_middle_width = try container.decodeIfPresent(Double.self, forKey: .right_middle_width)
        self.right_index_width = try container.decodeIfPresent(Double.self, forKey: .right_index_width)
        self.right_thumb_width = try container.decodeIfPresent(Double.self, forKey: .right_thumb_width)
        self.left_pinky_length = try container.decodeIfPresent(Double.self, forKey: .left_pinky_length)
        self.left_ring_length = try container.decodeIfPresent(Double.self, forKey: .left_ring_length)
        self.left_middle_length = try container.decodeIfPresent(Double.self, forKey: .left_middle_length)
        self.left_index_length = try container.decodeIfPresent(Double.self, forKey: .left_index_length)
        self.left_thumb_length = try container.decodeIfPresent(Double.self, forKey: .left_thumb_length)
        self.right_pinky_length = try container.decodeIfPresent(Double.self, forKey: .right_pinky_length)
        self.right_ring_length = try container.decodeIfPresent(Double.self, forKey: .right_ring_length)
        self.right_middle_length = try container.decodeIfPresent(Double.self, forKey: .right_middle_length)
        self.right_index_length = try container.decodeIfPresent(Double.self, forKey: .right_index_length)
        self.right_thumb_length = try container.decodeIfPresent(Double.self, forKey: .right_thumb_length)
        self.left_pinky_size = try container.decodeIfPresent(Int.self, forKey: .left_pinky_size)
        self.left_ring_size = try container.decodeIfPresent(Int.self, forKey: .left_ring_size)
        self.left_middle_size = try container.decodeIfPresent(Int.self, forKey: .left_middle_size)
        self.left_index_size = try container.decodeIfPresent(Int.self, forKey: .left_index_size)
        self.left_thumb_size = try container.decodeIfPresent(Int.self, forKey: .left_thumb_size)
        self.right_pinky_size = try container.decodeIfPresent(Int.self, forKey: .right_pinky_size)
        self.right_ring_size = try container.decodeIfPresent(Int.self, forKey: .right_ring_size)
        self.right_middle_size = try container.decodeIfPresent(Int.self, forKey: .right_middle_size)
        self.right_index_size = try container.decodeIfPresent(Int.self, forKey: .right_index_size)
        self.right_thumb_size = try container.decodeIfPresent(Int.self, forKey: .right_thumb_size)
        self.card_seg_model = try container.decodeIfPresent(String.self, forKey: .card_seg_model)
        self.nails_seg_model = try container.decodeIfPresent(String.self, forKey: .nails_seg_model)
        self.git_commit_id = try container.decodeIfPresent(String.self, forKey: .git_commit_id)
        self.processed_time = try container.decodeIfPresent(Double.self, forKey: .processed_time)
    }

}

enum MetadataType: Codable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .int(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .string(container.decode(String.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(MetadataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }
}

// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


// MARK: - ImageNames
struct ImageNames: Codable {
    let leftHand, leftThumb, rightHand, rightThumb: String

    enum CodingKeys: String, CodingKey {
        case leftHand = "left_hand"
        case leftThumb = "left_thumb"
        case rightHand = "right_hand"
        case rightThumb = "right_thumb"
    }
}

enum NailNames: String {
    case left_pinky = "left_hand_0"
    case left_ring = "left_hand_1"
    case left_middle = "left_hand_2"
    case left_index = "left_hand_3"
    case right_pinky = "right_hand_3"
    case right_ring = "right_hand_2"
    case right_middle = "right_hand_1"
    case right_index = "right_hand_0"
    case right_thumb = "right_thumb_0"
    case left_thumb = "left_thumb_0"
}

enum FingerImageCategories: Int {
    case left_four
    case left_thumb
    case right_four
    case right_thumb

    static let count: Int = {
        var max: Int = 0
        while let _ = FingerImageCategories(rawValue: max) { max += 1 }
        return max
    }()
    
    var name: String {
        switch self {
        case .left_four:
            return "Left Four Fingers"
        case .left_thumb:
            return "Left Thumb"
        case .right_four:
            return "Right Four Fingers"
        case .right_thumb:
            return "Right Thumb"
        }
    }
    
    var apiKey: String {
        switch self {
        case .left_four:
            return "left_hand_file"
        case .left_thumb:
            return "left_thumb_file"
        case .right_four:
            return "right_hand_file"
        case .right_thumb:
            return "right_thumb_file"
        }
    }
}

// MARK: - UserLoginResponse
// Assumption: The success response from both Auth calls are the same type object.

struct User: Codable {
    let active: Bool?
    let firstname: String?
    let lastname: String?
    let id: Int?
    let password: String?
    let email: String?
}

struct UserAuthObject: Codable {
    let active: Bool?
    let email, firstname: String?
    let id: Int?
    let lastname, password, token: String?
}

struct AccountSection {
    let title: String
    let options : [AccountOption]
}

struct AccountOption {
    let title: String
    let image: UIImage?
    let color: UIColor
    let handler: (() -> Void)
}

struct FingerData {
    let length: Double
    let size: Int
    let fingerLabel: String
}

struct UserInfo: Codable {
    let active: Bool?
    let email: String?
    let firstname: String?
    let id: Int?
    let lastname: String?
    let password: String?
}

struct ManualMeasurement: Codable {
    let createddate: String?
    let id: Int?
    let lastmodifieddate: String?
    let left_index_length: Double?
    let left_index_size: Int?
    let left_index_width: Double?
    let left_middle_length: Double?
    let left_middle_size: Int?
    let left_middle_width: Double?
    let left_pinky_length: Double?
    let left_pinky_size: Int?
    let left_pinky_width: Double?
    let left_ring_length: Double?
    let left_ring_size: Int?
    let left_ring_width: Double?
    let left_thumb_length: Double?
    let left_thumb_size: Int?
    let left_thumb_width: Double?
    let right_index_length: Double?
    let right_index_size: Int?
    let right_index_width: Double?
    let right_middle_length: Double?
    let right_middle_size: Int?
    let right_middle_width: Double?
    let right_pinky_length: Double?
    let right_pinky_size: Int?
    let right_pinky_width: Double?
    let right_ring_length: Double?
    let right_ring_size: Int?
    let right_ring_width: Double?
    let right_thumb_length: Double?
    let right_thumb_size: Int?
    let right_thumb_width: Double?
    let usersid: Int?
}

struct PreviousSavedNailImageResponsesItem: Codable {
    let measurements: [Measurements]?
    let totalNumberOfItems: Int?
}

struct Measurements: Codable, Identifiable {
    let createddate: String?
    let device: String?
    let deviceos: String?
    let id: Int?
    let lastmodifieddate: String?
    let left_hand_image: String?
    let left_hand_marked_image: String?
    let left_hand_processing_issue: String?
    let left_index_length: Double?
    let left_index_size: Int?
    let left_index_width: Double?
    let left_middle_length: Double?
    let left_middle_size: Int?
    let left_middle_size_diff: Int?
    let left_middle_width: Double?
    let left_pinky_length: Double?
    let left_pinky_size: Int?
    let left_pinky_width: Double?
    let left_ring_length: Double?
    let left_ring_size: Int?
    let left_ring_width: Double?
    let left_thumb_image: String?
    let left_thumb_length: Double?
    let left_thumb_marked_image: String?
    let left_thumb_processing_issue: String?
    let left_thumb_size: Int?
    let left_thumb_size_diff: Int?
    let left_thumb_width: Double?
    let maunualmeasurement: ManualMeasurement?
    let measurementsid: Int?
    let right_hand_image: String?
    let right_hand_marked_image: String?
    let right_hand_processing_issue: String?
    let right_index_length: Double?
    let right_index_size: Int?
    let right_index_width: Double?
    let right_middle_length: Double?
    let right_middle_size: Int?
    let right_middle_width: Double?
    let right_pinky_length: Double?
    let right_pinky_size: Int?
    let right_pinky_width: Double?
    let right_ring_length: Double?
    let right_ring_size: Int?
    let right_ring_width: Double?
    let right_thumb_image: String?
    let right_thumb_length: Double?
    let right_thumb_marked_image: String?
    let right_thumb_processing_issue: String?
    let right_thumb_size: Int?
    let right_thumb_width: Double?
    let user_info: UserInfo
    let userid: Int?
    let usersid: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createddate = try container.decodeIfPresent(String.self, forKey: .createddate)
        self.device = try container.decodeIfPresent(String.self, forKey: .device)
        self.deviceos = try container.decodeIfPresent(String.self, forKey: .deviceos)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.lastmodifieddate = try container.decodeIfPresent(String.self, forKey: .lastmodifieddate)
        self.left_hand_image = try container.decodeIfPresent(String.self, forKey: .left_hand_image)
        self.left_hand_marked_image = try container.decodeIfPresent(String.self, forKey: .left_hand_marked_image)
        //self.left_hand_processing_issue = try container.decodeIfPresent(String.self, forKey: .left_hand_processing_issue)
        do {
            self.left_hand_processing_issue = try container.decodeIfPresent(String.self, forKey: .left_hand_processing_issue)
        } catch {
            self.left_hand_processing_issue = nil
        }
        
        
        self.left_index_length = try container.decodeIfPresent(Double.self, forKey: .left_index_length)
        self.left_index_size = try container.decodeIfPresent(Int.self, forKey: .left_index_size)
        self.left_index_width = try container.decodeIfPresent(Double.self, forKey: .left_index_width)
        self.left_middle_length = try container.decodeIfPresent(Double.self, forKey: .left_middle_length)
        self.left_middle_size = try container.decodeIfPresent(Int.self, forKey: .left_middle_size)
        self.left_middle_size_diff = try container.decodeIfPresent(Int.self, forKey: .left_middle_size_diff)
        self.left_middle_width = try container.decodeIfPresent(Double.self, forKey: .left_middle_width)
        self.left_pinky_length = try container.decodeIfPresent(Double.self, forKey: .left_pinky_length)
        self.left_pinky_size = try container.decodeIfPresent(Int.self, forKey: .left_pinky_size)
        self.left_pinky_width = try container.decodeIfPresent(Double.self, forKey: .left_pinky_width)
        self.left_ring_length = try container.decodeIfPresent(Double.self, forKey: .left_ring_length)
        self.left_ring_size = try container.decodeIfPresent(Int.self, forKey: .left_ring_size)
        self.left_ring_width = try container.decodeIfPresent(Double.self, forKey: .left_ring_width)
        self.left_thumb_image = try container.decodeIfPresent(String.self, forKey: .left_thumb_image)
        self.left_thumb_length = try container.decodeIfPresent(Double.self, forKey: .left_thumb_length)
        self.left_thumb_marked_image = try container.decodeIfPresent(String.self, forKey: .left_thumb_marked_image)
        do {
            self.left_thumb_processing_issue = try container.decodeIfPresent(String.self, forKey: .left_thumb_processing_issue)
        } catch {
            self.left_thumb_processing_issue = nil
        }
        self.left_thumb_size = try container.decodeIfPresent(Int.self, forKey: .left_thumb_size)
        self.left_thumb_size_diff = try container.decodeIfPresent(Int.self, forKey: .left_thumb_size_diff)
        self.left_thumb_width = try container.decodeIfPresent(Double.self, forKey: .left_thumb_width)
        self.maunualmeasurement = try container.decodeIfPresent(ManualMeasurement.self, forKey: .maunualmeasurement)
        self.measurementsid = try container.decodeIfPresent(Int.self, forKey: .measurementsid)
        self.right_hand_image = try container.decodeIfPresent(String.self, forKey: .right_hand_image)
        self.right_hand_marked_image = try container.decodeIfPresent(String.self, forKey: .right_hand_marked_image)
        do {
            self.right_hand_processing_issue = try container.decodeIfPresent(String.self, forKey: .right_hand_processing_issue)
        } catch {
            self.right_hand_processing_issue = nil
        }
        self.right_index_length = try container.decodeIfPresent(Double.self, forKey: .right_index_length)
        self.right_index_size = try container.decodeIfPresent(Int.self, forKey: .right_index_size)
        self.right_index_width = try container.decodeIfPresent(Double.self, forKey: .right_index_width)
        self.right_middle_length = try container.decodeIfPresent(Double.self, forKey: .right_middle_length)
        self.right_middle_size = try container.decodeIfPresent(Int.self, forKey: .right_middle_size)
        self.right_middle_width = try container.decodeIfPresent(Double.self, forKey: .right_middle_width)
        self.right_pinky_length = try container.decodeIfPresent(Double.self, forKey: .right_pinky_length)
        self.right_pinky_size = try container.decodeIfPresent(Int.self, forKey: .right_pinky_size)
        self.right_pinky_width = try container.decodeIfPresent(Double.self, forKey: .right_pinky_width)
        self.right_ring_length = try container.decodeIfPresent(Double.self, forKey: .right_ring_length)
        self.right_ring_size = try container.decodeIfPresent(Int.self, forKey: .right_ring_size)
        self.right_ring_width = try container.decodeIfPresent(Double.self, forKey: .right_ring_width)
        self.right_thumb_image = try container.decodeIfPresent(String.self, forKey: .right_thumb_image)
        self.right_thumb_length = try container.decodeIfPresent(Double.self, forKey: .right_thumb_length)
        self.right_thumb_marked_image = try container.decodeIfPresent(String.self, forKey: .right_thumb_marked_image)
        do {
            self.right_thumb_processing_issue = try container.decodeIfPresent(String.self, forKey: .right_thumb_processing_issue)
        } catch {
            self.right_thumb_processing_issue = nil
        }
        self.right_thumb_size = try container.decodeIfPresent(Int.self, forKey: .right_thumb_size)
        self.right_thumb_width = try container.decodeIfPresent(Double.self, forKey: .right_thumb_width)
        self.user_info = try container.decode(UserInfo.self, forKey: .user_info)
        self.userid = try container.decodeIfPresent(Int.self, forKey: .userid)
        self.usersid = try container.decodeIfPresent(Int.self, forKey: .usersid)
    }
    
}

struct NailSizesResponse: Codable {
    let NailSizes: [NailSizeGroupResponse]
}

struct NailSizeGroupResponse: Codable {
    let size: Int
    let width: Double
}

struct AvatarList: Codable {
    let Avatars_list: [Avatar]
}

struct Avatar: Codable {
    let id: Int
    let avatar_name: String
    let avatar_path: String
}

struct MarkedMeasurement: Codable {
    let message: String?
    let preferred_measurement: String?
    let status: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.message = try container.decodeIfPresent(String.self, forKey: .message)
        } catch {
            self.message = nil
        }
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        do {
            self.preferred_measurement = try container.decodeIfPresent(String.self, forKey: .preferred_measurement)
        } catch {
            self.preferred_measurement = nil
        }
    }
    
}

struct SuccessfulMeasurements: Codable {
    let measurements: [SuccessfulMeasurementsResponseItem]
}

struct SuccessfulMeasurementsResponseItem: Codable, Identifiable {
    let createddate: String?
    let id: Int?
    let left_index_length: Double?
    let left_index_size: Int?
    let left_index_width: Double?
    let left_middle_length: Double?
    let left_middle_size: Int?
    let left_middle_width: Double?
    let left_pinky_length: Double?
    let left_pinky_size: Int?
    let left_pinky_width: Double?
    let left_ring_length: Double?
    let left_ring_size: Int?
    let left_ring_width: Double?
    let left_thumb_length: Double?
    let left_thumb_size: Int?
    let left_thumb_width: Double?
    let measurementsid: Int
    let right_index_length: Double?
    let right_index_size: Int?
    let right_index_width: Double?
    let right_middle_length: Double?
    let right_middle_size: Int?
    let right_middle_width: Double?
    let right_pinky_length: Double?
    let right_pinky_size: Int?
    let right_pinky_width: Double?
    let right_ring_length: Double?
    let right_ring_size: Int?
    let right_ring_width: Double?
    let right_thumb_length: Double?
    let right_thumb_size: Int?
    let right_thumb_width: Double?
    let userid: Int?
    
}

struct SaveNailCollectionItem: Codable {
    let userid: Int
    let name: String
    let imageurl: String
    let leftthumbcolor: String
    let leftindexcolor: String
    let leftmiddlecolor: String
    let leftringcolor: String
    let leftpinkycolor: String
    let rightthumbcolor: String
    let rightindexcolor: String
    let rightmiddlecolor: String
    let rightringcolor: String
    let rightpinkycolor: String
    let status: String
    let glossy: Bool
    let skintone: String?
}

struct SaveCollectionResponseItem: Codable {
    let createddate: String?
    let glossy: Bool?
    let id: Int?
    let imageurl: String?
    let lastmodifieddate: String?
    let leftindexcolor: String?
    let leftmiddlecolor: String?
    let leftpinkycolor: String?
    let leftringcolor: String?
    let leftthumbcolor: String?
    let name: String?
    let rightindexcolor: String?
    let rightmiddlecolor: String?
    let rightpinkycolor: String?
    let rightringcolor: String?
    let rightthumbcolor: String?
    let skintone: String?
    let status: Int?
    let userid: Int?
}

struct NewSaveCollectionResponseItem: Codable {
    let createddate: String?
      let glossy: Bool?
      let handphotoid: Int?
      let id: Int?
      let imageurl: String?
      let lastmodifieddate: String?
      let leftindexproductid: Int?
      let leftmiddleproductid: Int?
      let leftpinkyproductid: Int?
      let leftringproductid: Int?
      let leftthumbproductid: Int?
      let name: String?
      let rightindexproductid: Int?
      let rightmiddleproductid: Int?
      let rightpinkyproductid: Int?
      let rightringproductid: Int?
      let rightthumbproductid: Int?
      let skintoneid: Int?
      let status: Int?
      let userid: Int?
    
    
}

struct SaveNailCollectionResponseItem: Codable {
    let userid: Int?
    let id: Int?
    let glossy: Bool?
    let createddate: String?
    let imageurl: String?
    let lastmodifieddate: String?
    let leftindexcolor: String?
    let leftmiddlecolor: String?
    let leftpinkycolor: String?
    let leftringcolor: String?
    let leftthumbcolor: String?
    let name: String?
    let rightindexcolor: String?
    let rightmiddlecolor: String?
    let rightpinkycolor: String?
    let rightringcolor: String?
    let rightthumbcolor: String?
    let skintone: String?
    let status: Int?
}

struct OldSavedCustomNailCollection: Codable {
    let createddate: String?
    let glossy: Bool?
    let id: Int?
    let imageurl: String?
    let lastmodifieddate: String?
    let leftindexcolor: String?
    let leftmiddlecolor: String?
    let leftpinkycolor: String?
    let leftringcolor: String?
    let leftthumbcolor: String?
    let name: String?
    let rightindexcolor: String?
    let rightmiddlecolor: String?
    let rightpinkycolor: String?
    let rightringcolor: String?
    let rightthumbcolor: String?
    let skintone: String?
    let status: Int?
    let userid: Int?
    
}

struct SavedCustomNailCollection: Codable, Identifiable {
    let glossy: Bool?
    let handphotoid: Int?
    let id: Int?
    let imageurl: String?
    let leftindex: ProductItem?
    let leftmiddle: ProductItem?
    let leftpinky: ProductItem?
    let leftring: ProductItem?
    let leftthumb: ProductItem?
    let name: String?
    let rightindex: ProductItem?
    let rightmiddle: ProductItem?
    let rightpinky: ProductItem?
    let rightring: ProductItem?
    let rightthumb: ProductItem?
    let skintoneid: Int?
    let status: Int?
    let userid: Int?
}

struct ProductItem: Codable {
    let productcolorcode: String?
    let productid: Int?
    let productname: String?
}

struct CollectionList: Codable {
    let Collections_list: [SavedCustomNailCollection]
}

struct Product: Codable, Equatable {
    let colorcode: String?
    let id: Int?
    let name: String?
    let productcategorycolorcode: String?
    let productcategoryid: Int?
    let productcategoryname: String?
    let status: Int?
}

struct ProductList: Codable, Equatable {
    let Products_list: [Product]
}

struct DeleteMessage: Codable {
    let message: String?
}

struct MeasurementIdResponse: Codable {
    let measurementid: Int?
    let measurementresultsid: Int?
}

struct NewNailMeasurementResponse: Codable {
    let id: Int?
    let userid: Int?
    let left_hand_image: String?
    let left_thumb_image: String?
    let right_hand_image: String?
    let right_thumb_image: String?
    let left_hand_marked_image: String?
    let left_thumb_marked_image: String?
    let right_hand_marked_image: String?
    let right_thumb_marked_image: String?
    let left_hand_processing_issue: String?
    let left_thumb_processing_issue: String?
    let right_hand_processing_issue: String?
    let right_thumb_processing_issue: String?
    let device: String?
    let deviceos: String?
    let createddate: String?
    let lastmodifieddate: String?
    let usersid: Int?
    let measurementsid: Int?
    let left_pinky_width: Double?
    let left_ring_width: Double?
    let left_middle_width: Double?
    let left_index_width: Double?
    let left_thumb_width: Double?
    let right_pinky_width: Double?
    let right_ring_width: Double?
    let right_middle_width: Double?
    let right_index_width: Double?
    let right_thumb_width: Double?
    let left_pinky_length: Double?
    let left_ring_length: Double?
    let left_middle_length: Double?
    let left_index_length: Double?
    let left_thumb_length: Double?
    let right_pinky_length: Double?
    let right_ring_length: Double?
    let right_middle_length: Double?
    let right_index_length: Double?
    let right_thumb_length: Double?
    let left_pinky_size: Int?
    let left_ring_size: Int?
    let left_middle_size: Int?
    let left_index_size: Int?
    let left_thumb_size: Int?
    let right_pinky_size: Int?
    let right_ring_size: Int?
    let right_middle_size: Int?
    let right_index_size: Int?
    let right_thumb_size: Int?
    let card_seg_model: String?
    let nails_seg_model: String?
    let git_commit_id: String?
    let processed_time: Double? //????
}

//struct HandPhotoModel: Codable {
//    let id: Int?
//    let imageurl: String?
//    let skintoneid: Int?
//    let status: Int?
//}

struct HandPhotoModel: Codable {
    let id: Int?
    let imageurl: String?
    let skintoneid: Int?
    let status: Int?
    let nail_assets: NailAssetModel?
}

struct NailAssetModel: Codable {
    let glossy_left_index_nailoverlayphoto: String?
    let glossy_left_middle_nailoverlayphoto: String?
    let glossy_left_pinky_nailoverlayphoto: String?
    let glossy_left_ring_nailoverlayphoto: String?
    let glossy_left_thumb_nailoverlayphoto: String?
    let glossy_right_index_nailoverlayphoto: String?
    let glossy_right_middle_nailoverlayphoto: String?
    let glossy_right_pinky_nailoverlayphoto: String?
    let glossy_right_ring_nailoverlayphoto: String?
    let glossy_right_thumb_nailoverlayphoto: String?
    let non_glossy_left_index_nailoverlayphoto: String?
    let non_glossy_left_middle_nailoverlayphoto: String?
    let non_glossy_left_pinky_nailoverlayphoto: String?
    let non_glossy_left_ring_nailoverlayphoto: String?
    let non_glossy_left_thumb_nailoverlayphoto: String?
    let non_glossy_na_id: Int?
    let non_glossy_right_index_nailoverlayphoto: String?
    let non_glossy_right_middle_nailoverlayphoto: String?
    let non_glossy_right_pinky_nailoverlayphoto: String?
    let non_glossy_right_ring_nailoverlayphoto: String?
    let non_glossy_right_thumb_nailoverlayphoto: String?
}

struct HandPhotoList: Codable {
    let Handphotos_list : [HandPhotoModel]?
}
