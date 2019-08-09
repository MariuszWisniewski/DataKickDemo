import UIKit
import ViewModelOwners

class ProductListCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var unitLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ProductListCell: ReusableViewModelOwner {
    
    func didSetViewModel(_ viewModel: ProductViewModelProtocol, disposeBag: ViewModelOwnerDisposeBag) {
        nameLabel.text = viewModel.name
        unitLabel.text = viewModel.unit
    }
}
