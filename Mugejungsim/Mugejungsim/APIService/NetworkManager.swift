// NetworkManager.swift

import Foundation
import UIKit

/*
 * 기존 클백 코드가 유저 데이터 기준으로 짜여진 코드
 * Swagger 나오는대로 수정하여 진행
 * JPG기준으로 진행하기
 */

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "#"
    
    // 외부에서 인스턴스 생성 막기!
    private init() {}
    
    // MARK: - 네트워크 요청 메서드에요~
    // T: Codable - 어떤 타입이든 Codable을 준수하면 사용할 수 있어요~ -> 즉 JSON 변환 가능한 어떤 타입이든 OK"라는 의미에요!!
    // struct 떙땡땡 : Codable -> Encodable과 Decodable을 합친 거여서 JSON <-> Swift 객체 간 변환을 가능하게 합니다!!!
    func request<T: Codable>(_ endpoint: String,
                            method: String,
                            parameters: [String: String]? = nil,
                            body: Codable? = nil,
                            completion: @escaping (Result<T, Error>) -> Void) {
        
        // MARK: - URL 생성 부분입니당!
        // 기본 URL + 엔드포인트
        var urlString = baseURL + endpoint
        if let parameters = parameters {
            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            var components = URLComponents(string: urlString)!
            components.queryItems = queryItems
            urlString = components.url?.absoluteString ?? urlString
        }
        
        // URL이 유효한지 체크해요!
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // body가 있으면 JSON으로 인코딩해서 추가할것!
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        // MARK: - 네트워크 요청 실행 부분이에요!!
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // 에러 체크 해주고~
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 데이터 존재 체크한다음~
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            // 받은 데이터를 요청한 타입으로 디코딩 하기!
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume() // 요청 시자악!
    }
    
    
    // MARK: - 멀티파트 : 이미지 전송을 위한 함수
    func uploadImage(
        _ endpoint: String,
        parameters: [String: String]? = nil,
        image: UIImage,
        imageFieldName: String = "image",
        fileName: String = "image.jpg",
        completion: @escaping (Result<APIResponse, Error>) -> Void
        ) {
            guard let url = URL(string: baseURL + endpoint) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Image Data"])))
            return
        }

        let body = createMultipartBody(
            parameters: parameters,
            fileFieldName: imageFieldName,
            fileName: fileName,
            fileData: imageData,
            mimeType: "image/jpeg",
            boundary: boundary
        )
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
                
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func createMultipartBody(
        parameters: [String: String]?,
        fileFieldName: String,
        fileName: String,
        fileData: Data,
        mimeType: String,
        boundary: String
    ) -> Data {
        var body = Data()

        parameters?.forEach { key, value in
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(fileFieldName)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(fileData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        return body
    }
}

// Helper extension for Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
