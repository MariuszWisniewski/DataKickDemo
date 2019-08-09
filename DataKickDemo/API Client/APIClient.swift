import Alamofire
import AlamofireImage
import UIKit

protocol APIClientProtocol {
    func getProducts(onSuccess: @escaping ([Product]) -> (),
                     onFailure: @escaping (Error) -> ())
    
    func getProducts(query: String,
                     onSuccess: @escaping ([Product]) -> (),
                     onFailure: @escaping (Error) -> ())
}

protocol ImageDownloaderProtocol {
    func downloadImage(path: String,
                       onSuccess: @escaping (UIImage) -> (),
                       onFailure: @escaping (Error) -> ())
}

enum ImageDownloaderError: Error {
    case couldNotBuildImageFromData
}

class APIClient: APIClientProtocol {
    
    private let baseURL = "https://www.datakick.org/api/"
    private let jsonDecoder: JSONDecoder
    private var lastRequest: DataRequest?
    
    private lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.background(
            withIdentifier: "com.mariuszwisniewski.DataKickDemo"
            )
        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }()
    
    init(decoder: JSONDecoder) {
        jsonDecoder = decoder
    }
    
    private func get<T: Decodable>(
        path: String,
        parameters: Parameters?,
        onSuccess: @escaping (T) -> (),
        onFailure: @escaping (Error) -> ()
        ) {
        let url = baseURL + path
        lastRequest?.cancel()
        let request = sessionManager.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: nil
        )
        lastRequest = request
            
        request.responseData { [weak self] response in
            guard let self = self else { return }
            let result: Result<T> = self.jsonDecoder.decodeResponse(from: response)
            switch result {
            case .failure(let error):
                onFailure(error)
            case .success(let value):
                onSuccess(value)
            }
        }
    }
    
    func getProducts(onSuccess: @escaping ([Product]) -> (),
                     onFailure: @escaping (Error) -> ()) {
        get(
            path: "items",
            parameters: nil,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }
    
    func getProducts(query: String,
                     onSuccess: @escaping ([Product]) -> (),
                     onFailure: @escaping (Error) -> ()) {
        get(
            path: "items",
            parameters: ["query": query],
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }
}

extension APIClient: ImageDownloaderProtocol {
    func downloadImage(path: String,
                       onSuccess: @escaping (UIImage) -> (),
                       onFailure: @escaping (Error) -> ()) {
        sessionManager.request(path, method: .get).responseImage { response in
            switch response.result {
            case .success(let value):
                onSuccess(value)
            case .failure(let error):
                onFailure(error)
            }
        }
    }
}
