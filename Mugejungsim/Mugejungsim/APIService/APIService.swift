import Alamofire
import UIKit

struct APIResponse: Codable {
    let success: Bool
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
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        networkManager.uploadImages(
            "/travelRecords/upload",
            parameters: ["recordId": recordId.uuidString],
            images: images,
            completion: completion
        )
    }
}

// MARK: - Codable 데이터 변환 헬퍼 메서드
extension Data {
    func toDictionary() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
    }
}
