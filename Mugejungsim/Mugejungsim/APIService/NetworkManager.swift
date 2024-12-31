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
    
    func resizeImage(image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage? {
        let size = image.size
        let widthRatio = maxWidth / size.width
        let heightRatio = maxHeight / size.height
        let scaleRatio = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * scaleRatio, height: size.height * scaleRatio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func uploadImages(
        _ endpoint: String,
        photos: [[String: Any]],
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        let url = baseURL + endpoint
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        // JSON 데이터를 생성
        guard let jsonData = try? JSONSerialization.data(withJSONObject: ["photos": photos], options: []) else {
            print("Failed to serialize JSON")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON"])))
            return
        }

        // 디버깅용 출력
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON Payload: \(jsonString)")
        }

        // 서버로 요청
        AF.request(
            url,
            method: .post,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: APIResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                print("Upload Success:", apiResponse)
                completion(.success(apiResponse))
            case .failure(let error):
                print("Upload Failure:", error.localizedDescription)
                if let data = response.data {
                    print("Response Data: \(String(data: data, encoding: .utf8) ?? "No Data")")
                }
                completion(.failure(error))
            }
        }
    }
}

