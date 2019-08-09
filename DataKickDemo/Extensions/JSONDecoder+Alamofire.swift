import Alamofire
import Foundation

enum DecodingError: Error {
    case missingData
    case parsingError(Error)
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(
        from response: DataResponse<Data>
        ) -> Result<T> {
        if let error = response.error {
            print(error)
            return .failure(error)
        }
        
        guard let responseData = response.data else {
            print("Response data was empty :(")
            return .failure(DecodingError.missingData)
        }
        
        let json = String(data: responseData, encoding: .utf8) ?? "WRONG JSON FORMAT"
        print("Response was: \(json)")
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("Error decoding object: \(error)")
            return .failure(DecodingError.parsingError(error))
        }
    }
}
