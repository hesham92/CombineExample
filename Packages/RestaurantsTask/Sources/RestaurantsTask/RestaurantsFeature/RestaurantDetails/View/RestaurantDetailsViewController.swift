import UIKit
import SnapKit

class RestaurantDetailsViewController: UIViewController, ErrorViewShowing {
    // MARK: - Public
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureConstraints()
        updateUI(with: restaurant)
    }
    
    static func makeViewController(restaurant: Restaurant) -> RestaurantDetailsViewController {
        let viewController = RestaurantDetailsViewController(restaurant: restaurant)
        return viewController
    }
    
    // MARK: - Private
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(restaurantImageView)
        view.addSubview(nameAndDescriptionstackView)
        view.addSubview(hoursAndRatingstackView)
    }
    
    private func configureConstraints() {
        restaurantImageView.snp.makeConstraints {
            $0.size.height.equalTo(200)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        nameAndDescriptionstackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(restaurantImageView.snp.bottom).offset(20)
        }
        
        hoursAndRatingstackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(nameAndDescriptionstackView.snp.bottom).offset(20)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func updateUI(with restaurant: Restaurant) {
        restaurantImageView.kf.setImage(with: URL(string: restaurant.image))
        restaurantNameLabel.text = restaurant.name
        restaurantDescriptionLabel.text = restaurant.description
        restaurantHoursLabel.text = restaurant.hours
        restaurantRatingLabel.text = String(restaurant.rating)
    }
    
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameAndDescriptionstackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restaurantNameLabel, restaurantDescriptionLabel])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let restaurantDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var hoursAndRatingstackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restaurantHoursLabel, restaurantRatingLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private let restaurantHoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let restaurantRatingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let restaurant: Restaurant
}
