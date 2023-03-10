import UIKit
import SnapKit
import Combine

public class RestaurantsListViewController: UIViewController, LoadingViewShowing, ErrorViewShowing, UIActionSheetDelegate {
    // MARK: - Public
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: RestaurantsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureConstraints()
        setupBindings()
        
        Task {
            await viewModel.viewDidLoad()
        }
    }
    
    public static func makeViewController() -> RestaurantsListViewController {
        let viewModel = RestaurantsListViewModel()
        let viewController = RestaurantsListViewController(viewModel: viewModel)
        return viewController
    }
    
    // MARK: - Private
    private func setupBindings() {
        viewModel.$state.sink { [weak self] state in
            guard let self else { return }
            switch state {
            case .loading:
                self.handleLoading(isLoading: true)
            case let .loaded(restaurants):
                self.handleLoading(isLoading: false)
                var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
                snapshot.appendSections([.main])
                snapshot.appendItems(restaurants)
                self.dataSource.apply(snapshot)
            case let .error(viewModel):
                self.handleLoading(isLoading: false)
                self.showError(viewModel: viewModel)
            default:
                break
            }
        }.store(in: &cancellables)
        
        viewModel.$navigateToRestaurantDetails.compactMap{ $0 }.sink { [weak self] restaurant in
            guard let self else { return }
            let viewController = RestaurantDetailsViewController.makeViewController(restaurant: restaurant)
            self.navigationController?.pushViewController(viewController, animated: true)
        }.store(in: &cancellables)
    }
    
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
    
    @objc private func segmentedControlValueChanged() {
        viewModel.didSelectSegmentAtIndex = segmentedControl.selectedSegmentIndex
    }
    
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
        return collectionView
    }()
    
    private enum Section {
        case main
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Restaurant> = {
        let registration = UICollectionView.CellRegistration<ResturantCollectionViewCell, Restaurant> { cell, indexPath, restaurant in
            cell.configure(with: restaurant)
        }
        
        let  dataSource = UICollectionViewDiffableDataSource<Section, Restaurant>(collectionView: collectionView) { collectionView, indexPath, restaurant in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: restaurant)
        }
        return dataSource
    }()
    
    private let viewModel: RestaurantsListViewModel
    private var cancellables = Set<AnyCancellable>()
}

extension RestaurantsListViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRestaurantAtIndex = indexPath.row
    }
}
