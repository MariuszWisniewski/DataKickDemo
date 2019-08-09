import Foundation

enum ProductError: Error {
    case missingImage
}

struct ProductUrl: Decodable {
    let url: String
}

struct Product {
    let id: String
    let name: String?
    let brandName: String?
    let size: String?
    let images: [ProductUrl]
    let pages: Int?
    
    //Details
    let author: String?
    let format: String?
    let publisher: String?
    let ingredients: String?
    let servingSize: String?
    let servingsPerContainer: String?
    let calories: Decimal?
    let fatCalories: Decimal?
    let fat: Decimal?
    let saturatedFat: Decimal?
    let transFat: Decimal?
    let polyunsaturatedFat: Decimal?
    let monounsaturatedFat: Decimal?
    let cholesterol: Decimal?
    let sodium: Decimal?
    let potassium: Decimal?
    let carbohydrate: Decimal?
    let fiber: Decimal?
    let sugars: Decimal?
    let protein: Decimal?
    let alcoholByVolume: Decimal?
}

extension Product: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "gtin14"
        case name
        case brandName
        case size
        case images
        case pages
        
        //Details
        case ingredients
        case servingSize
        case servingsPerContainer
        case calories
        case fatCalories
        case fat
        case saturatedFat
        case transFat
        case polyunsaturatedFat
        case monounsaturatedFat
        case cholesterol
        case sodium
        case potassium
        case carbohydrate
        case fiber
        case sugars
        case protein
        case author
        case format
        case publisher
        case alcoholByVolume
    }
}
