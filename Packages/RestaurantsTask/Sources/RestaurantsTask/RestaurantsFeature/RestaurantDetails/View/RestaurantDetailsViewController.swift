import UIKit
import SnapKit

class RestaurantDetailsViewController: UIViewController, ErrorViewShowing {
    // MARK: - Public
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(presenter: RestaurantsDetailsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureConstraints()
        
        presenter.configure(with: self)
        presenter.viewDidLoad()
    }
    
    static func makeViewController(restaurant: Restaurant) -> RestaurantDetailsViewController {
        let presenter = DefaultRestaurantDetailsPresenter(restaurant: restaurant)
        let viewController = RestaurantDetailsViewController(presenter: presenter)
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

    private let presenter: RestaurantsDetailsPresenter
}

extension RestaurantDetailsViewController: RestaurantsDetailsView {
    func updateUI(with viewModel: RestaurantDetailsViewModel) {
        restaurantImageView.kf.setImage(with: viewModel.imageURL)
        restaurantNameLabel.text = viewModel.name
        restaurantDescriptionLabel.text = viewModel.description
        restaurantHoursLabel.text = viewModel.hours
        restaurantRatingLabel.text = String(viewModel.rating)
    }
}
