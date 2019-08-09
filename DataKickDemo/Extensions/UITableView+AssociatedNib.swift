import UIKit

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    func register(_ cell: UITableViewHeaderFooterView.Type) {
        register(cell.nib, forHeaderFooterViewReuseIdentifier: cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cell with type \(T.nibName) should always be there")
        }
        
        return cell
    }
}
