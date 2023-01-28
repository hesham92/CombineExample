import UIKit
import SnapKit

protocol LoadingViewShowing {
    func handleLoading(isLoading: Bool)
}

 private struct Constants {
    /// an arbitrary tag id for the loading view, so it can be retrieved later without keeping a reference to it
    static let loadingViewTag = 1234
}

extension LoadingViewShowing where Self: UIViewController {
    func handleLoading(isLoading: Bool) {
        if isLoading {
            showLoading()
        } else {
            hideLoading()
        }
    }
    
    private func showLoading() {
        let loadingView = UIActivityIndicatorView(style: .medium)
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        loadingView.tag = Constants.loadingViewTag
        loadingView.startAnimating()
    }
    
    private func hideLoading() {
        view.subviews.forEach { subview in
            if subview.tag == Constants.loadingViewTag {
                subview.removeFromSuperview()
            }
        }
    }
}
