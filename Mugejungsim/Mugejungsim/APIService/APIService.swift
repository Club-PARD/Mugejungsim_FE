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

    func uploadTravelRecordImages(
        recordId: UUID,
        images: [UIImage],
        metadata: [[String: Any]], // 각 이미지와 관련된 메타데이터
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {

        let endpoint = "/travelRecords/\(recordId)/upload"
        let url = URLService.shared.baseURL + endpoint
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]

        AF.upload(
            multipartFormData: { multipartFormData in
                // Add images and metadata
                images.enumerated().forEach { index, image in
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        multipartFormData.append(
                            imageData,
                            withName: "photos[\(index)][image]",
                            fileName: "image\(index + 1).jpg",
                            mimeType: "image/jpeg"
                        )
                    }
                    
                    // Add metadata for each image
                    if let pid = metadata[index]["pid"] as? String {
                        multipartFormData.append(Data(pid.utf8), withName: "photos[\(index)][pid]")
                    }
                    if let content = metadata[index]["content"] as? String {
                        multipartFormData.append(Data(content.utf8), withName: "photos[\(index)][content]")
                    }
                    if let categories = metadata[index]["categories"] as? [String] {
                        categories.forEach { category in
                            multipartFormData.append(Data(category.utf8), withName: "photos[\(index)][categories][]")
                        }
                    }
                    if let orderIndex = metadata[index]["orderIndex"] as? Int {
                        multipartFormData.append(Data("\(orderIndex)".utf8), withName: "photos[\(index)][orderIndex]")
                    }
                }
            },
            to: url,
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

// MARK: - Codable 데이터 변환 헬퍼 메서드
extension Data {
    func toDictionary() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
    }
}
