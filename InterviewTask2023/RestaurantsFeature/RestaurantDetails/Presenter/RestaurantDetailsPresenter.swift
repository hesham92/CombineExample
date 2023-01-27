import Foundation

protocol RestaurantsDetailsPresenterProtocol {
    func configure(with viewDelegate: RestaurantsDetailsViewDelegate)
    func viewDidLoad()
}

protocol RestaurantsDetailsViewDelegate: AnyObject {
    func updateUI(restaurant: Restaurant)
}

class RestaurantDetailsPresenter: RestaurantsDetailsPresenterProtocol {
    // MARK: - Public
    init(restaurant: Restaurant){
        self.restaurant = restaurant
    }
    
    func configure(with viewDelegate: RestaurantsDetailsViewDelegate) {
        self.viewDelegate = viewDelegate
    }
    
    func viewDidLoad() {
        viewDelegate?.updateUI(restaurant: restaurant)
    }
    
    // MARK: - Private
    
    private var restaurant: Restaurant
    private weak var viewDelegate: RestaurantsDetailsViewDelegate?
}
