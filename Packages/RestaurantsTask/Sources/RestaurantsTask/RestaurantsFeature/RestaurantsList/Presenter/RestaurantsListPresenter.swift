import Foundation

enum RestaurantsListState {
    case idle
    case loading
    case loaded([Restaurant])
    case error(String)
}

protocol RestaurantsListPresenterProtocol {
    var state: RestaurantsListState { get }
    func configure(with viewDelegate: RestaurantsListView)
    func didSelectRestaurantAtIndex(index: Int)
    func viewDidLoad() async
}

protocol RestaurantsListView: AnyObject {
    func stateDidChange()
    func navigateToRestaurantDetails(restaurant: Restaurant)
}

class RestaurantsListPresenter: RestaurantsListPresenterProtocol {
    // MARK: - Public
    init(service: HttpServiceProtocol = HttpService()){
        self.service = service
    }
    
    private(set) var state: RestaurantsListState = .idle {
        didSet {
            view?.stateDidChange()
        }
    }
    
    func didSelectRestaurantAtIndex(index: Int) {
        view?.navigateToRestaurantDetails(restaurant: restaurants[index])
    }
    
    func configure(with viewDelegate: RestaurantsListView) {
        self.view = viewDelegate
    }
    
    func viewDidLoad() async {
        await fetchRestaurants()
    }
    
    // MARK: - Private
    @MainActor
    private func fetchRestaurants() async {
        self.state = .loading
        
        do {
            let restaurants = try await service.request(endpoint: RestaurantsEndpoint.getRestaurants, modelType: [Restaurant].self)
            
            self.restaurants = restaurants
            state = .loaded(restaurants)
        } catch {
            restaurants.removeAll()
            state = .error(error.localizedDescription)
        }
    }
    
    private let service: HttpServiceProtocol
    private weak var view: RestaurantsListView?
    var restaurants: [Restaurant] = []
}
