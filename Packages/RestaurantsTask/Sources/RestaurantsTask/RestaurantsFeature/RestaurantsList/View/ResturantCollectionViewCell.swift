import UIKit

final class ResturantCollectionViewCell: UICollectionViewCell {
    // MARK: - Public
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resturantView.prepareForReuse()
    }
    
    func configure(restaurant: Restaurant) {
        self.resturantView.configure(restaurant: restaurant)
    }
    
    // MARK: - Private
    private func configureView() {
        addSubview(resturantView)
    }
    
    private func configureConstraints() {
        resturantView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private let resturantView = ResturantView() // Reason to sepearte view from cell to be reusable in any context
}


