import Foundation
import UIKit

protocol ProductDetailsViewModelProtocol: AnyObject {
    var title: String { get }
    var name: String { get }
    var id: String { get }
    var info1: String { get }
    var info2: String { get }
    var info3: String { get }
    
    func downloadImage(onSuccess: @escaping (UIImage) -> (), onFailure: @escaping (Error) -> ())
}

class ProductDetailsViewModel: ProductDetailsViewModelProtocol {
    
    private let product: Product
    private let imageDownloader: ImageDownloaderProtocol
    private var properties: [String] = []
    
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.locale = Locale.autoupdatingCurrent
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.minimumIntegerDigits = 1
        return numberFormatter
    }()
    
    var title: String {
        return product.name ?? product.brandName ?? "<<No Name>>"
    }
    
    var name: String {
        var name = product.name ?? "<<No Name>>"
        if let brandName = product.brandName {
            name += "by \(brandName)"
        }
        return name
    }
    
    var id: String {
        return "ID: \(product.id)"
    }
    
    var info1: String {
        return properties.safeObject(at: 0) ?? ""
    }
    
    var info2: String {
        return properties.safeObject(at: 1) ?? ""
    }
    
    var info3: String {
        return properties.safeObject(at: 2) ?? ""
    }
    
    init(product: Product, imageDownloader: ImageDownloaderProtocol) {
        self.product = product
        self.imageDownloader = imageDownloader
        self.properties = properties(for: product)
    }
    
    func downloadImage(onSuccess: @escaping (UIImage) -> (), onFailure: @escaping (Error) -> ()) {
        guard let imageURL = product.images.first?.url else {
            onFailure(ProductError.missingImage)
            return
        }
        imageDownloader.downloadImage(path: imageURL, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    private func textRepresentation(for number: Decimal) -> String {
        return numberFormatter.string(from: number as NSNumber) ?? ""
    }
    
    private func properties(for product: Product) -> [String] {
        var properties: [String] = []
        
        if let carbohydrate = product.carbohydrate {
            properties.append("Carbohydrate: \(textRepresentation(for: carbohydrate))")
        }
        
        if let fat = product.fat {
            properties.append("Fat: \(textRepresentation(for: fat))")
        }
        
        if let protein = product.protein {
            properties.append("Protein: \(textRepresentation(for: protein))")
        }
        
        if let calories = product.calories {
            properties.append("Calories: \(textRepresentation(for: calories))")
        }
        
        if let size = product.size {
            properties.append("Size: \(size)")
        }
        
        if let servingSize = product.servingSize {
            properties.append("Serving Size: \(servingSize)")
        }
        if let servingsPerContainer = product.servingsPerContainer {
            properties.append("Servings Per Container: \(servingsPerContainer)")
        }
        
        if let alcoholByVolume = product.alcoholByVolume {
            properties.append("Alcohol by Volume: \(textRepresentation(for: alcoholByVolume))")
        }
        
        if let author = product.author {
            properties.append("Author: \(author)")
        }
        
        if let publisher = product.publisher {
            properties.append("Publisher: \(publisher)")
        }
        
        if let pages = product.pages {
            properties.append("Number of pages: \(pages)")
        }
        
        return properties
    }
}
