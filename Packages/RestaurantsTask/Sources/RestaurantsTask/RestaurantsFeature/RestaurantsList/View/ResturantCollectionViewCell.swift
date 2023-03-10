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
        
        view.prepareForReuse()
    }
    
    func configure(with restaurant: Restaurant) {
        view.configure(with: restaurant)
    }
    
    // MARK: - Private
    private func configureView() {
        addSubview(view)
    }
    
    private func configureConstraints() {
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private let view = ResturantView() // Reason to sepearte view from cell to be reusable in any context
}


