protocol ProductListViewModelProtocol: AnyObject {
    var title: String { get }
    
    func downloadItems(
        onSuccess: @escaping ([Product]) -> (),
        onFailure: @escaping (Error) -> ()
    )
    
    func downloadItems(
        query: String,
        onSuccess: @escaping ([Product]) -> (),
        onFailure: @escaping (Error) -> ()
    )
    
    func displayProduct(_ product: Product)
}

protocol ProductListFlowProtocol: AnyObject {
    var onProductSelected: ((Product) -> ())? { get set }
}

class ProductListViewModel: ProductListViewModelProtocol, ProductListFlowProtocol {

    var title: String {
        return "Product List"
    }
    
    var onProductSelected: ((Product) -> ())?
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func downloadItems(
        onSuccess: @escaping ([Product]) -> (),
        onFailure: @escaping (Error) -> ()
        ) {
        apiClient.getProducts(onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func downloadItems(
        query: String,
        onSuccess: @escaping ([Product]) -> (),
        onFailure: @escaping (Error) -> ()
        ) {
        apiClient.getProducts(query: query, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func displayProduct(_ product: Product) {
        onProductSelected?(product)
    }
}
