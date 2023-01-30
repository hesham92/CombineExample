import UIKit
import SnapKit
import Kingfisher

final class ResturantView: UIView {
    // MARK: - Public
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func prepareForReuse() {
        restaurantNameLabel.text = ""
        restaurantImageView.image = nil
        restaurantImageView.kf.cancelDownloadTask()
    }
    
    func configure(with viewModel: RestaurantViewModel) {
        restaurantNameLabel.text = viewModel.name
        restaurantImageView.kf.indicatorType = .activity
        restaurantImageView.kf.setImage(with: viewModel.imageURL)
    }
    
    // MARK: - Private
    private func configureView() {
        addSubview(restaurantNameLabel)
        addSubview(restaurantImageView)
    }
    
    private func configureConstraints() {
        restaurantImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(8)
            $0.size.width.equalTo(160)
        }
        
        restaurantNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(restaurantImageView.snp.centerY)
            $0.leading.equalTo(restaurantImageView.snp.trailing).offset(8)
        }
    }
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
}
