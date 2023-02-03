import Foundation

struct Restaurant: Codable, Hashable, Equatable {
    let image: String
    let name: String
    let description: String
    let hours: String
    let distance: Double
    let rating: Double
}
