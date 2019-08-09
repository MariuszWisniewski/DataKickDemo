import UIKit

protocol FlowControllerProtocol {
    var rootViewController: UIViewController { get }
}

class FlowController: FlowControllerProtocol {
    typealias DependencyContainerType = DependencyContainerProtocol
        & DependencyContainerViewControllersProtocol
        & DependencyContainerViewModelsProtocol
    
    private var navigationController: UINavigationController
    private var dependencyContainer: DependencyContainerType
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    private var productListViewController: ProductListViewController {
        let viewModel = dependencyContainer.productsListViewModel
        viewModel.onProductSelected = { [weak self] product in
            self?.showProductDetails(for: product)
        }
        return dependencyContainer.productListViewController(viewModel: viewModel)
    }
    
    init(with dependencyContainer: DependencyContainerType) {
        self.dependencyContainer = dependencyContainer
        navigationController = dependencyContainer.navigationController
        navigationController.viewControllers = [productListViewController]
    }
    
    private func showProductDetails(for product: Product) {
        let viewModel = dependencyContainer.productDetailsViewModel(for: product)
        let viewController = dependencyContainer.productDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
