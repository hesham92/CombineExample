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
        thumbnailImageView.image = nil
        thumbnailImageView.kf.cancelDownloadTask()
    }
    
    func configure(viewModel: RestaurantViewModel) {
        restaurantNameLabel.text = viewModel.name
        thumbnailImageView.kf.setImage(with: URL(string: viewModel.image))
    }

    // MARK: - Private
    private func configureView() {
        addSubview(restaurantNameLabel)
        addSubview(thumbnailImageView)
    }

    private func configureConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(8)
            $0.size.width.equalTo(160)
        }
        
        restaurantNameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
        }
    }

    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
}
