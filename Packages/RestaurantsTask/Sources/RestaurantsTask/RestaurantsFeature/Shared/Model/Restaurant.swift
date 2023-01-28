import Foundation

struct Restaurant: Codable, Equatable, Hashable {
    let image: String
    let name: String
    let description: String
    let hours: String
    let distance: Double
    let rating: Double
}
