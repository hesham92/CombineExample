import UIKit
import SnapKit

class RestaurantsListViewController: UIViewController, LoadingViewShowing, ErrorViewShowing {
    // MARK: - Public
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: RestaurantsListPresenterProtocol) {
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
    
    static func makeViewController() -> RestaurantsListViewController {
        let presenter = RestaurantsListPresenter()
        let viewController = RestaurantsListViewController(presenter: presenter)
        return viewController
    }
    
    // MARK: - Private
    private func configureView() {
        title = "Restaurants"
        
        view.addSubview(collectionView)
    }
    
    private func configureConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        
        let registration = UICollectionView.CellRegistration<ResturantCollectionViewCell, Restaurant> { cell, indexPath, restaurant in
            cell.configure(restaurant: restaurant)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Restaurant>(collectionView: collectionView) { collectionView, indexPath, user in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: user)
        }
        
        return collectionView
    }()
    
    private let presenter: RestaurantsListPresenterProtocol
    private var dataSource: UICollectionViewDiffableDataSource<Section, Restaurant>?
}

extension RestaurantsListViewController: RestaurantsListViewDelegate {
    func stateDidChange() {
        self.handleLoading(isLoading: false)

        switch presenter.state {
        case .loading:
            self.handleLoading(isLoading: true)
        case let .loaded(restaurants):
            var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
            snapshot.appendSections([.main])
            snapshot.appendItems(restaurants)
            self.dataSource?.apply(snapshot)
        case let .error(errorMessage):
            self.showErrorMessage(errorMessage)
        default:
            break
        }
    }
    
    func navigateToRestaurantDetails(restaurant: Restaurant) {
        let viewController = RestaurantDetailsViewController.makeViewController(restaurant: restaurant)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RestaurantsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectRestaurantAtIndex(index: indexPath.row)
    }
}

extension RestaurantsListViewController {
    enum Section {
        case main
    }
}
