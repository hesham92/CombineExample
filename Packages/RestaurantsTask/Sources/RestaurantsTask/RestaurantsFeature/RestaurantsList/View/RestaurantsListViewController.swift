import UIKit
import SnapKit

public class RestaurantsListViewController: UIViewController, LoadingViewShowing, ErrorViewShowing, UIActionSheetDelegate {
    // MARK: - Public
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(presenter: RestaurantsListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureConstraints()
        
        presenter.configure(with: self)
        Task {
            await presenter.viewDidLoad()
        }
    }
    
    public static func makeViewController() -> RestaurantsListViewController {
        let presenter = DefaultRestaurantsListPresenter()
        let viewController = RestaurantsListViewController(presenter: presenter)
        return viewController
    }
    
    // MARK: - Private
    private func configureView() {
        title = "Restaurants"
        view.backgroundColor = .white
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.addSubview(segmentedControl)
        containerView.addSubview(collectionView)
    }
    
    private func configureConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(collectionView.snp.top)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func segmentedControlValueChanged() {
        presenter.didSelectSegmentAtIndex(segmentedControl.selectedSegmentIndex)
    }
    
    private let containerView = UIView()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Default", "Distance", "Rating"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        
        let registration = UICollectionView.CellRegistration<ResturantCollectionViewCell, RestaurantViewModel> { cell, indexPath, restaurantViewModel in
            cell.configure(with: restaurantViewModel)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, RestaurantViewModel>(collectionView: collectionView) { collectionView, indexPath, restaurantViewModel in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: restaurantViewModel)
        }
        
        return collectionView
    }()
    
    private let presenter: RestaurantsListPresenter
    private var dataSource: UICollectionViewDiffableDataSource<Section, RestaurantViewModel>?
}

extension RestaurantsListViewController: RestaurantsListView {
    func stateDidChange() {
        self.handleLoading(isLoading: false)
        
        switch presenter.state {
        case .idle:
            self.containerView.isHidden = true
        case .loading:
            self.handleLoading(isLoading: true)
        case let .loaded(restaurants):
            var snapshot = NSDiffableDataSourceSnapshot<Section, RestaurantViewModel>()
            snapshot.appendSections([.main])
            snapshot.appendItems(restaurants)
            self.dataSource?.apply(snapshot)
            self.containerView.isHidden = false
        case let .error(viewModel):
            self.showError(viewModel: viewModel)
        }
    }
    
    func navigateToRestaurantDetails(restaurant: Restaurant) {
        let viewController = RestaurantDetailsViewController.makeViewController(restaurant: restaurant)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RestaurantsListViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectRestaurantAtIndex(indexPath.row)
    }
}

extension RestaurantsListViewController {
    enum Section {
        case main
    }
}
