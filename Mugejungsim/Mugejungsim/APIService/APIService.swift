import Foundation
import UIKit

struct User: Codable {
    let id: Int?
    let name: String
    let part: String
    let age: Int
}

struct UpdateUserRequest: Codable {
    let name: String
    let part: String
    let age: String
}

struct APIResponse: Codable {
    let success: Bool
}

class APIService {
    static let shared = APIService()
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    // MARK: - 사용자 목록 조회
    func getUsers(part: String, completion: @escaping (Result<[User], Error>) -> Void) {
        networkManager.request(
            "/user",
            method: "GET",
            parameters: ["part": part],
            completion: completion
        )
    }
    
    // MARK: - 사용자 생성
    func createUser(user: User, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        networkManager.request(
            "/user",
            method: "POST",
            body: user,
            completion: completion
        )
    }
    
    // MARK: - 사용자 정보 업데이트
    func updateUser(id: Int, user: UpdateUserRequest, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        networkManager.request(
            "/user/\(id)",
            method: "PATCH",
            body: user,
            completion: completion
        )
    }
    
    // MARK: - 사용자 삭제
    func deleteUser(id: Int, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        networkManager.request(
            "/user/\(id)",
            method: "DELETE",
            completion: completion
        )
    }
    
    // MARK: - 다중 이미지 업로드
    func uploadUserImages(
        userId: Int,
        images: [UIImage],
        completion: @escaping (Result<APIResponse, Error>) -> Void
    ) {
        let parameters = ["userId": "\(userId)"]
        
        // EnumeratedSequence를 명확히 풀어서 사용
        let imageInfos = images.enumerated().map { (index, image) -> (fieldName: String, image: UIImage, fileName: String) in
            let fieldName = "image\(index + 1)"
            let fileName = "image\(index + 1).jpg"
            return (fieldName: fieldName, image: image, fileName: fileName)
        }
        
        networkManager.uploadImages(
            "/user/upload",
            parameters: parameters,
            images: imageInfos,
            completion: completion
        )
    }
}
