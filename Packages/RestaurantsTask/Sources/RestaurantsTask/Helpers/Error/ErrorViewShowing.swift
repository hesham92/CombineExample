import UIKit


struct GenericErrorViewModel {
    let onRetryTapped: (() -> Void)?
    let title: String
    let description: String

    init(title: String? = nil, description: String? = nil, onRetryTapped: (() -> Void)? = nil) {
        self.title = title ?? "Error"
        self.description = description ?? "Sorry there something worng"
        self.onRetryTapped = onRetryTapped
    }

    func retry() {
        if let onRetryTapped {
            onRetryTapped()
        }
    }
}

protocol ErrorViewShowing {
    func showError(viewModel: GenericErrorViewModel)
}

extension ErrorViewShowing where Self: UIViewController {
    func showError(viewModel: GenericErrorViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            if viewModel.onRetryTapped != nil {
                viewModel.retry()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
