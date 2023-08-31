import Foundation

// MARK: - AdsList
struct AdsList: Codable {
    let advertisements: [Advertisement]
}

// MARK: - Advertisement
struct Advertisement: Codable {
    let id: String
    let title, price, location, imageURL: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
    }
}
