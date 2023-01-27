import Foundation

enum RestaurantsEndpoint {
    case getRestaurants
}

extension RestaurantsEndpoint: Endpoint {
    var baseURL: URL { return URL(string: "https://jahez-other-oniiphi8.s3.eu-central-1.amazonaws.com/")! }
    
    var path: String {
        switch self {
        case .getRestaurants:
            return "restaurants.json"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .getRestaurants:
            return .get
        }
    }
    
    var bodyParameters: [String: Any]? {
        return nil
    }
    
    var headers: [String: String] {
        return ["Content-type": "application/json"]
    }
}
