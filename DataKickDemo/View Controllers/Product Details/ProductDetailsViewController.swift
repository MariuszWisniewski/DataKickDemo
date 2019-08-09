import UIKit
import ViewModelOwners

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var additionalInfoLine1Label: UILabel!
    @IBOutlet weak var additionalInfoLine2Label: UILabel!
    @IBOutlet weak var additionalInfoLine3Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
        update(using: viewModel)
        viewModel.downloadImage(onSuccess: { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
                self?.imageView.isHidden = false
            }
        }) { error in
            print("Error downloading image: \(error)")
        }
    }
    
    private func update(using viewModel: ProductDetailsViewModelProtocol) {
        title = viewModel.title
        nameLabel.text = viewModel.name
        idLabel.text = viewModel.id
        additionalInfoLine1Label.text = viewModel.info1
        additionalInfoLine2Label.text = viewModel.info2
        additionalInfoLine3Label.text = viewModel.info3
    }

}

extension ProductDetailsViewController: NonReusableViewModelOwner {
    func didSetViewModel(_ viewModel: ProductDetailsViewModelProtocol, disposeBag: ViewModelOwnerDisposeBag) {
        guard isViewLoaded else { return }
        update(using: viewModel)
    }
}
