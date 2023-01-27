import UIKit

protocol ErrorViewShowing {
    func showErrorMessage(_ errorMessage: String)
}

extension ErrorViewShowing where Self: UIViewController {
    func showErrorMessage(_ errorMessage: String) {
        let alert = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
