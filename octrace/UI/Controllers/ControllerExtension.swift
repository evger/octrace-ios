import UIKit

extension UIViewController {
    
    /*
     Navigation
     */
    
    func popOut(animated: Bool = false) {
        _ = navigationController?.popViewController(animated: animated)
    }
    
    
    
    /*
     Indicator
     */
    
    func addActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

        if #available(iOS 13.0, *) {
            indicator.style = UIActivityIndicatorView.Style.large
        } else {
            indicator.style = UIActivityIndicatorView.Style.gray
        }
        indicator.backgroundColor = UIColor.clear
        indicator.center = view.center

        view.addSubview(indicator)

        return indicator
    }
    
    
    /*
     Dialogs
     */
    
    func actionMenu(addActions: (UIAlertController) -> Void) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        addActions(optionMenu)
        
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    func confirm(_ message: String, _ handler: @escaping () -> Swift.Void) {
        let alert = UIAlertController(title: "Please confirm",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in handler() }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        
        present(alert, animated: true, completion: nil)
    }
    
    func inputText(_ message: String, _ handler: @escaping (String) -> Swift.Void) {
        let alert = UIAlertController(title: "Input required",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            handler(alert.textFields?[0].text ?? "")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        alert.addTextField()
        
        present(alert, animated: true, completion: nil)
    }
    
    func showInfo(_ message: String) {
        let alert = UIAlertController(title: "OCTrace", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showSettings(_ message: String) {
        let alert = UIAlertController(title: "OCTrace", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alert.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "No, thanks", style: .default, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

extension Date {
    init(tst: Int64) {
        self.init(timeIntervalSince1970: Double(tst) / 1000)
    }
    
    func timestamp() -> Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }
    
    static func timestamp() -> Int64 {
        return Int64((Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate) * 1000)
    }
}
