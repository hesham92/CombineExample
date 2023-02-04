import Foundation
import Combine

struct RestaurantViewModel: Equatable, Hashable {
    let imageURL: URL?
    let name: String
}

enum RestaurantsListState {
    case idle
    case loading
    case loaded([Restaurant])
    case error(GenericErrorViewModel)
}

final class RestaurantsListViewModel {
    // MARK: - Public
    init(service: HttpServiceProtocol = HttpService()){
        self.service = service
        
        observeActions()
    }
    
    @Published private(set) var state: RestaurantsListState = .idle
    @Published private(set) var navigateToRestaurantDetails: Restaurant?
    @Published var didSelectRestaurantAtIndex: Int?
    @Published var didSelectSegmentAtIndex: Int?
    
    func viewDidLoad() async {
        await fetchRestaurants()
    }
    
    // MARK: - Private
    private func observeActions() {
        $didSelectRestaurantAtIndex
            .compactMap { $0 }
            .map{ [weak self] in self?.restaurants[$0] }
            .assign(to: &$navigateToRestaurantDetails)
        
        $didSelectSegmentAtIndex
            .compactMap { $0 }
            .map{ [weak self] index in
                guard let self else { return .loaded([]) }
                var sortedRestaurants: [Restaurant] = []
                
                switch SortingCriteria(rawValue: index) {
                case .default, .none:
                    sortedRestaurants = self.restaurants
                case .distance:
                    sortedRestaurants = self.restaurants.sorted { $0.distance < $1.distance }
                case .rating:
                    sortedRestaurants = self.restaurants.sorted { $0.rating > $1.rating }
                }
                
                return .loaded(sortedRestaurants)
            }
            .assign(to: &$state)
    }
    
    @MainActor
    private func fetchRestaurants() async {
        state = .loading
        do {
            restaurants = try await service.request(endpoint: RestaurantsEndpoint.getRestaurants, modelType: [Restaurant].self)
            state = .loaded(restaurants)
        } catch {
            restaurants.removeAll()
            state = .error(makeErrorViewModel(error: error))
        }
    }
    
    private func makeErrorViewModel(error: Error) -> GenericErrorViewModel {
        GenericErrorViewModel(description: error.localizedDescription, onRetryTapped: { [weak self] in
            guard let self else { return }
            Task {
                await self.fetchRestaurants()
            }
        })
    }
    
    private enum SortingCriteria: Int, CaseIterable {
        case `default` = 0
        case distance = 1
        case rating = 2
    }
    
    private let service: HttpServiceProtocol
    private var restaurants: [Restaurant] = []
}
