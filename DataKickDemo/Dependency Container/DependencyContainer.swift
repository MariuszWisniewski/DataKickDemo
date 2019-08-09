import UIKit

protocol DependencyContainerProtocol {
    var flowController: FlowControllerProtocol { get }
    var navigationController: UINavigationController { get }
}

protocol DependencyContainerViewControllersProtocol {
    func productListViewController(viewModel: ProductListViewModelProtocol) -> ProductListViewController
    func productDetailsViewController(viewModel: ProductDetailsViewModelProtocol) -> ProductDetailsViewController
}

protocol DependencyContainerViewModelsProtocol {
    var productsListViewModel: ProductListViewModelProtocol & ProductListFlowProtocol { get }
    
    func productDetailsViewModel(for product: Product) -> ProductDetailsViewModelProtocol
}

protocol DependencyContainerAPIProtocol {
    var apiClient: APIClientProtocol { get }
    var imageDownloader: ImageDownloaderProtocol { get }
    var jsonDecoder: JSONDecoder { get }
}

class DependencyContainer: DependencyContainerProtocol {

    private(set) lazy var flowController: FlowControllerProtocol = FlowController(with: self)
    private lazy var _apiClient = APIClient(decoder: jsonDecoder)
    
    var navigationController: UINavigationController {
        return UINavigationController()
    }
}

extension DependencyContainer: DependencyContainerViewControllersProtocol {
    func productListViewController(viewModel: ProductListViewModelProtocol) -> ProductListViewController {
        let viewController = ProductListViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    func productDetailsViewController(viewModel: ProductDetailsViewModelProtocol) -> ProductDetailsViewController {
        let viewController = ProductDetailsViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension DependencyContainer: DependencyContainerViewModelsProtocol {
    var productsListViewModel: ProductListViewModelProtocol & ProductListFlowProtocol {
        return ProductListViewModel(apiClient: apiClient)
    }
    
    func productDetailsViewModel(for product: Product) -> ProductDetailsViewModelProtocol {
        let viewModel = ProductDetailsViewModel(product: product, imageDownloader: imageDownloader)
        return viewModel
    }
}

extension DependencyContainer: DependencyContainerAPIProtocol {
    var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
    
    var apiClient: APIClientProtocol {
        return _apiClient
    }
    
    var imageDownloader: ImageDownloaderProtocol {
        return _apiClient
    }
}
