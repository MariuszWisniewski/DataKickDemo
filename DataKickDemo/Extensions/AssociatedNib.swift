import UIKit

internal protocol AssociatedNib: AnyObject {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension AssociatedNib {
    static var nibName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
}

extension AssociatedNib where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return self.nibName
    }
}

extension AssociatedNib where Self: UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return self.nibName
    }
}

extension UITableViewCell: AssociatedNib {}
extension UITableViewHeaderFooterView: AssociatedNib {}
