import Foundation

// MARK: - AdsDetailModel
struct AdsDetailModel: Codable {
    let id: String
    let imageURL: String
    let title, price, location, createdDate, description, email, phoneNumber: String
    let address: String

    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
        case description, email
        case phoneNumber = "phone_number"
        case address
    }
}
