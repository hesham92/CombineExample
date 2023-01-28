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
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
    }
    
    private func configureConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(collectionView.snp.top)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Actions
    @objc private func segmentedControlValueChanged() {
        presenter.didSelectSegmentAtIndex(index: segmentedControl.selectedSegmentIndex)
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
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Default", "Distance", "Rating"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return control
    }()
    
    private let presenter: RestaurantsListPresenter
    private var dataSource: UICollectionViewDiffableDataSource<Section, Restaurant>?
}

extension RestaurantsListViewController: RestaurantsListView {
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
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectRestaurantAtIndex(index: indexPath.row)
    }
}

extension RestaurantsListViewController {
    enum Section {
        case main
    }
}
