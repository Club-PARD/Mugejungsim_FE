//
//  TravelRecordManager.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/28/24.
//

/*
 * App 전체적인 기능 Flow 점검 위한 코드
 *
 */
import Alamofire
import UIKit

//struct TravelRecord: Codable {
//    var id: UUID                // 기록물 id
//    var title: String           // 기록물 제목 : 여행 제목
//    var description: String     //
//    var date: String            // 여행 날짜
//    var location: String        // 여행지
//    var oneLine1: String        //
//    var oneLine2: String        //
//    var photos: [PhotoData] // `PhotoData` 사용
//
//    init(title: String, description: String, date: String, location: String, photos: [PhotoData] = [], oneLine1: String, oneLine2: String) {
//        self.id = UUID()
//        self.title = title
//        self.description = description
//        self.date = date
//        self.location = location
//        self.oneLine1 = oneLine1
//        self.oneLine2 = oneLine2
//        self.photos = photos
//    }
//}

struct TravelRecord: Codable {
    var id: UUID          // 기록물 id
    var title: String           // 기록물 제목 : 여행 제목
    var startDate: String            // 여행 시작 날짜
    var endDate: String            // 여행 종료 날짜
    var location: String        // 여행지
    var companion : String // 동행자
    var bottle : String // 유리병
    var photos: [PhotoData] // `PhotoData` 사용
    var oneLine1: String        // local
    var oneLine2: String // local

    init(id:UUID = UUID(), title: String, startDate: String, endDate: String, location: String, companion: String, bottle: String, photos: [PhotoData] = [], oneLine1: String, oneLine2: String) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.companion = companion
        self.bottle = bottle
        self.photos = photos
        self.oneLine1 = oneLine1
        self.oneLine2 = oneLine2
    }
}

class TravelRecordManager {
    static let shared = TravelRecordManager()
    private var travelRecords: [TravelRecord] = []

    
    private init() {
        travelRecords = DataManager.shared.loadTravelRecords()
    }

    // MARK: - 데이터 저장
    private func saveData() {
        DataManager.shared.saveTravelRecords(travelRecords)
    }

    // MARK: - 모든 기록 가져오기
    func getAllRecords() -> [TravelRecord] {
        return travelRecords
    }

    // MARK: - 기록 추가
    func addRecord(_ record: TravelRecord) {
        travelRecords.append(record)
        saveData()
    }

    // MARK: - 사진 추가
    func addPhoto(to recordID: UUID, image: UIImage, text: String, category: String) -> Bool {
        guard var record = getRecord(by: recordID) else { return false }

        // 사진 수 제한 체크
        if record.photos.count >= 25 {
            print("사진 추가 실패: 최대 25개 제한")
            return false
        }

        // `DataManager`를 사용하여 이미지 저장
        if let imageName = DataManager.shared.saveImage(image) {
            let newPhoto = PhotoData(imagePath: imageName, text: text, category: category)
            record.photos.append(newPhoto)
            // 업데이트된 기록 저장
            updateRecord(record)
            return true
        }
        return false
    }

    // MARK: - 사진 삭제
    func deletePhoto(from recordID: UUID, at index: Int) -> Bool {
        guard var record = getRecord(by: recordID), index < record.photos.count else { return false }

        // `DataManager`를 사용하여 이미지 삭제
        let photoToDelete = record.photos[index]
//        DataManager.shared.deleteData(photoData: photoToDelete)
        // 사진 목록 업데이트
        record.photos.remove(at: index)
        updateRecord(record)
        return true
    }

    // MARK: - 기록 업데이트
    func updateRecord(_ updatedRecord: TravelRecord) {
        if let index = travelRecords.firstIndex(where: { $0.id == updatedRecord.id }) {
            travelRecords[index] = updatedRecord
            saveData()
        }
    }

    // MARK: - 특정 기록 불러오기
    func getRecord(by id: UUID) -> TravelRecord? {
        return travelRecords.first { $0.id == id }
    }
    
}
