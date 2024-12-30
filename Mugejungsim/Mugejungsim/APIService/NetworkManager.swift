import Alamofire
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = URLService.shared.baseURL
    
    private init() {}

    // MARK: - 일반 네트워크 요청 메서드
    func request<T: Codable>(
        _ endpoint: String,
        method: HTTPMethod,
        parameters: [String: String]? = nil,
        body: Codable? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let url = baseURL + endpoint
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        var encoding: ParameterEncoding = URLEncoding.default
        if method == .post || method == .patch {
            encoding = JSONEncoding.default
        }
        
        let bodyParameters: Parameters? = {
            guard let body = body else { return nil }
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            return try? encoder.encode(body).toDictionary()
        }()
        
        // Print request details
        print("=== Request ===")
        print("URL: \(url)")
        print("Method: \(method.rawValue)")
        print("Headers: \(headers)")
        print("Parameters: \(parameters ?? [:])")
        if let bodyParameters = bodyParameters {
            print("Body: \(bodyParameters)")
        }
        print("===============")
        
        AF.request(
            url,
            method: method,
            parameters: bodyParameters ?? parameters,
            encoding: encoding,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            // Print response details
            print("=== Response ===")
            print("URL: \(response.request?.url?.absoluteString ?? "No URL")")
            print("Status Code: \(response.response?.statusCode ?? 0)")
            if let data = response.data {
                print("Raw Data: \(String(data: data, encoding: .utf8) ?? "No Data")")
            }
            switch response.result {
            case .success(let result):
                print("Decoded Response: \(result)")
                completion(.success(result))
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            print("================")
        }
    }

    // MARK: - 다중 이미지 업로드 메서드
    func uploadImages(
        _ endpoint: String,
        parameters: [String: String],
        images: [UIImage],
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        let url = baseURL + endpoint
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        
        // Print upload details
        print("=== Upload Request ===")
        print("URL: \(url)")
        print("Headers: \(headers)")
        print("Parameters: \(parameters)")
        print("Images Count: \(images.count)")
        print("======================")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // Add parameters
                for (key, value) in parameters {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
                
                // Add images
                images.enumerated().forEach { index, image in
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(
                            imageData,
                            withName: "image\(index + 1)",
                            fileName: "image\(index + 1).jpg",
                            mimeType: "image/jpeg"
                        )
                    }
                }
            },
            to: url,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: APIResponse.self) { response in
            // Print upload response details
            print("=== Upload Response ===")
            print("URL: \(response.request?.url?.absoluteString ?? "No URL")")
            print("Status Code: \(response.response?.statusCode ?? 0)")
            if let data = response.data {
                print("Raw Data: \(String(data: data, encoding: .utf8) ?? "No Data")")
            }
            switch response.result {
            case .success(let result):
                print("Decoded Response: \(result)")
                completion(.success(result))
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
            print("=======================")
        }
    }
}

// MARK: - Codable 데이터 변환 헬퍼 메서드
extension Data {
    func toDictionary() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
    }
}
