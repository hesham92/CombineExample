import Foundation

enum RestaurantsListState {
    case idle
    case loading
    case loaded([Restaurant])
    case error(String)
}

protocol RestaurantsListPresenterProtocol {
    var state: RestaurantsListState { get }
    func configure(with viewDelegate: RestaurantsListViewDelegate)
    func didSelectRestaurantAtIndex(index: Int)
    func viewDidLoad()
}

protocol RestaurantsListViewDelegate: AnyObject {
    func stateDidChange()
    func navigateToRestaurantDetails(restaurant: Restaurant)
}

class RestaurantsListPresenter: RestaurantsListPresenterProtocol {
    
    typealias RestaurantRequest = PerformRequest<[Restaurant]>
    private let restaurantRequest: RestaurantRequest
    // MARK: - Public
    init(restaurantRequest: @escaping RestaurantRequest = makePerformRequest(), completionQueue: DispatchQueue = .main){
        self.restaurantRequest = restaurantRequest
        self.completionQueue = completionQueue
    }
    
    private(set) var state: RestaurantsListState = .idle {
        didSet {
            viewDelegate?.stateDidChange()
        }
    }
    
    func didSelectRestaurantAtIndex(index: Int) {
        viewDelegate?.navigateToRestaurantDetails(restaurant: restaurants[index])
    }
    
    func configure(with viewDelegate: RestaurantsListViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func viewDidLoad() {
        fetchRestaurants()
    }
    
    // MARK: - Private
    private func fetchRestaurants() {
        self.state = .loading
        
        restaurantRequest(RestaurantsEndpoint.getRestaurants, [Restaurant].self) { result in
            self.completionQueue.async {
                switch(result) {
                case .success(let restaurants):
                    self.restaurants = restaurants
                    self.state = .loaded(restaurants)
                case .failure(let error):
                    self.restaurants.removeAll()
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }
    
    private weak var viewDelegate: RestaurantsListViewDelegate?
    private var completionQueue: DispatchQueue
    private var restaurants: [Restaurant] = []
}
