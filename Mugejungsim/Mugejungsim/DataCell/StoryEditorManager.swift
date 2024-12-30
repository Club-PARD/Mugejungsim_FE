import Foundation
import Alamofire
import UIKit

struct StoryEditor: Codable {
    var id: UUID
    var content: String
    var categories: [String]
    var imagePath: String
    var orderIndex: Int
    
    init(id: UUID=UUID(), content: String, categories: [String], imagePath: String, orderIndex: Int) {
        self.id = id
        self.content = content
        self.categories = categories
        self.imagePath = imagePath
        self.orderIndex = orderIndex
    }
}

class StoryManager {
    static let shared = StoryManager()
    private var stories: [[String: Any]] = [] // Swagger 형식의 데이터 저장

    private init() {}

    // MARK: - 스토리 추가
    func addStory(id: UUID=UUID(), content: String, categories: [String], imagePath: String, orderIndex: Int) {
        let story: [String: Any] = [
            "id": id,
            "content": content,
            "categories": categories,
            "imagePath": imagePath,
            "orderIndex": orderIndex
        ]
        stories.append(story)
    }

    // MARK: - 모든 스토리 가져오기
    func getAllStories() -> [[String: Any]] {
        return stories
    }

    // MARK: - 서버로 스토리 데이터 전송
    func uploadStories(to url: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !stories.isEmpty else {
            completion(.failure(NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "스토리 데이터가 없습니다."])))
            return
        }

        // JSON 배열 데이터를 Data로 변환
        guard let jsonData = try? JSONSerialization.data(withJSONObject: stories, options: []) else {
            completion(.failure(NSError(domain: "InvalidData", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON 변환 실패"])))
            return
        }

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Alamofire 요청
        AF.request(request).response { response in
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(NSError(domain: "NoResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "서버로부터 응답을 받을 수 없습니다."])))
                return
            }

            switch response.result {
            case .success:
                if statusCode == 200 || statusCode == 201 {
                    completion(.success("스토리 데이터가 성공적으로 업로드되었습니다. 상태 코드: \(statusCode)"))
                } else {
                    let errorMessage = "서버 응답 오류. 상태 코드: \(statusCode)"
                    completion(.failure(NSError(domain: "ServerError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
        print("스토리 데이터: \(StoryManager.shared.getAllStories())")
    }

    // MARK: - 특정 스토리 삭제
    func deleteStory(at index: Int) {
        guard index >= 0 && index < stories.count else { return }
        stories.remove(at: index)
    }

    // MARK: - 스토리 초기화
    func clearStories() {
        stories.removeAll()
    }
}
