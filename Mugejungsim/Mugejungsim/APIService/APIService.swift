import Alamofire
import UIKit

struct APIResponse: Codable {
    let success: Bool
    let message: String? // 추가적으로 서버의 메시지를 포함할 수 있도록 설정
}

class APIService {
    static let shared = APIService()
    
    private let networkManager = NetworkManager.shared
    private init() {}

    // MARK: - 여행 기록 목록 조회
    func getTravelRecords(completion: @escaping (Result<[TravelRecord], Error>) -> Void) {
        networkManager.request(
            "/travelRecords",
            method: .get,
            completion: completion
        )
    }
    
    // MARK: - 여행 기록 생성
    func createTravelRecord(record: TravelRecord, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        networkManager.request(
            "/travelRecords",
            method: .post,
            body: record,
            completion: completion
        )
    }
    
    // MARK: - 여행 기록 업데이트
    func updateTravelRecord(id: UUID, record: TravelRecord, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        networkManager.request(
            "/travelRecords/\(id)",
            method: .patch,
            body: record,
            completion: completion
        )
    }
    
    // MARK: - 여행 기록 삭제
    func deleteTravelRecord(id: UUID, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        networkManager.request(
            "/travelRecords/\(id)",
            method: .delete,
            completion: completion
        )
    }
    
    // MARK: - 다중 이미지 업로드
    func uploadImages(
            endpoint: String,
            images: [UIImage],
            metadata: [[String: Any]], // 각 이미지와 연결된 JSON 데이터
            completion: @escaping (Result<Any, Error>) -> Void
        ) {
            let url = URLService.shared.baseURL + endpoint
            let headers: HTTPHeaders = [
                "Content-Type": "multipart/form-data"
            ]

            AF.upload(
                multipartFormData: { multipartFormData in
                    // 이미지 파일 추가
                    for (index, image) in images.enumerated() {
                        if let imageData = image.jpegData(compressionQuality: 0.8) {
                            multipartFormData.append(
                                imageData,
                                withName: "photos",
                                fileName: "image\(index + 1).jpg",
                                mimeType: "image/jpeg"
                            )
                        }
                    }

                    // JSON 데이터 추가
                    if let jsonData = try? JSONSerialization.data(withJSONObject: metadata, options: []),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        multipartFormData.append(
                            Data(jsonString.utf8),
                            withName: "data"
                        )
                    }
                },
                to: url,
                headers: headers
            )
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Upload successful: \(value)")
                    completion(.success(value))
                case .failure(let error):
                    print("Upload failed: \(error.localizedDescription)")
                    if let data = response.data {
                        print("Server Response: \(String(data: data, encoding: .utf8) ?? "No response body")")
                    }
                    completion(.failure(error))
                }
            }
        }

    // 사진 정보를 받아오는 함수
    // MARK: - 사진 데이터 가져오기
        func getPhotos(endpoint: String, completion: @escaping (Result<[PhotoData], Error>) -> Void) {
            let url = URLService.shared.baseURL + endpoint
            
            // GET 요청을 사용하여 서버에서 사진 정보를 가져옵니다
            AF.request(url, method: .get)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [PhotoData].self) { response in
                    switch response.result {
                    case .success(let photoData):
                        print("Successfully fetched photo data: \(photoData)")
                        completion(.success(photoData))
                    case .failure(let error):
                        print("Failed to fetch photo data: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
        }
    
    
    // 여행 기록 정보를 받아오는 함수
    func getTravelRecords(endpoint: String, completion: @escaping (Result<[TravelRecord], Error>) -> Void) {
        let url = URLService.shared.baseURL + endpoint
        
        // GET 요청을 사용하여 서버에서 여행 기록 정보를 가져옵니다
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [TravelRecord].self) { response in
                switch response.result {
                case .success(let records):
                    print("Travel records fetched successfully: \(records)")
                    completion(.success(records))
                case .failure(let error):
                    print("Failed to fetch travel records: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - 여행 기록 목록 조회
//    func getTravelRecords(completion: @escaping (Result<[TravelRecord], Error>) -> Void) {
//        let url = URLService.shared.baseURL + "/travelRecords"
//            
//        // GET 요청을 사용하여 서버에서 여행 기록 데이터를 가져옵니다
//        AF.request(url, method: .get)
//            .validate(statusCode: 200..<300)
//            .responseDecodable(of: [TravelRecord].self) { response in
//                switch response.result {
//                case .success(let records):
//                    print("Travel Records fetched successfully: \(records)")
//                    completion(.success(records))
//                case .failure(let error):
//                    print("Failed to fetch travel records: \(error.localizedDescription)")
//                    completion(.failure(error))
//                }
//            }
//    }
    
    
    
}

// MARK: - Codable 데이터 변환 헬퍼 메서드
extension Data {
    func toDictionary() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
    }
}
