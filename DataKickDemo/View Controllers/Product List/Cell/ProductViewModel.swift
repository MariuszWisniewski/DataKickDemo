import UIKit

protocol ProductViewModelProtocol {
    var name: String { get }
    var unit: String { get }
    var imageURL: String? { get }
}

class ProductViewModel: ProductViewModelProtocol {
    var name: String {
        return product.name ?? product.brandName ?? "<<No Name>>"
    }
    
    var unit: String {
        if let size = product.size {
            return size
        }
        if let pages = product.pages {
            return "\(pages) pages"
        }
        return ""
    }
    
    var imageURL: String? {
        return product.images.first?.url
    }
    
    private let product: Product
    
    init(product: Product) {
        self.product = product
    }
}
