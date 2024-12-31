//
//  TravelRecordManager.swift
//  Mugejungsim
//
//  Created by 도현학, 김지원 on 12/28/24.
//

/*
 * App 전체적인 기능 Flow 점검 위한 코드
 *
 */
import Alamofire
import UIKit



struct TravelRecord: Codable {
    var id: UUID                // 기록물 id
    var title: String           // 기록물 제목 : 여행 제목
    var startDate: String       // 여행 시작 날짜
    var endDate: String         // 여행 종료 날짜
    var location: String        // 여행지
    var companion : String      // 동행자
    var bottle : String         // 유리병
    var photos: [PhotoData]     // `PhotoData` 사용
    var oneLine1: String        // local
    var oneLine2: String        // local

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
    
    var userId: Int?
    var postId: Int?
    private let recordID: String = "1" // recordID를 항상 "1"로 고정
    
    private var travelRecords: [TravelRecord] = []
    var userId: Int?
    var postId: Int?
    
    private init() {
        travelRecords = DataManager.shared.loadTravelRecords()
    }
    
    private func saveData() {
        DataManager.shared.saveTravelRecords(travelRecords)
    }
    
    func getAllRecords() -> [TravelRecord] {
        return travelRecords
    }
    
    
    func addRecord(_ record: TravelRecord) {
        // 기존 고정된 recordID 데이터가 있다면 덮어씌움
        if let existingIndex = travelRecords.firstIndex(where: { $0.id.uuidString == recordID }) {
            travelRecords[existingIndex] = record
        } else {
            travelRecords.append(record)
        }
        saveData()
    }
    
    func addPhoto(to recordID: String, image: UIImage, text: String, categories: [String]) -> Bool {
        let recordID = "1" // recordID를 항상 "1"로 고정
//        let record = ensureDefaultRecordExists() // 레코드가 없으면 생성

    // MARK: - 사진 추가
    func addPhoto(to recordID: UUID, image: UIImage, text: String, categories: String) -> Bool {
        guard var record = getRecord(by: recordID) else { return false }

        // 사진 수 제한 체크
        if record.photos.count >= 25 {
            print("사진 추가 실패: 최대 25개 제한")
            return false
        }
        
        if let imageName = DataManager.shared.saveImage(image) {
            let newPhoto = PhotoData(imagePath: imageName, text: text, categories: [categories])
            record.photos.append(newPhoto)
            // 업데이트된 기록 저장
            updateRecord(record)
            return true
        }
        
        print("사진 저장 실패")
        return false
    }
    
    func deletePhoto(from recordID: String, at index: Int) -> Bool {
        // recordID를 무시하고 항상 고정된 ID "1"을 사용
        guard var record = getRecord(by: self.recordID), index < record.photos.count else {
            print("Invalid index or record not found")
            return false
        }
        
        record.photos.remove(at: index)
        updateRecord(record)
        return true
    }
    
    func updateRecord(_ updatedRecord: TravelRecord) {
        if let index = travelRecords.firstIndex(where: { $0.id == updatedRecord.id }) {
            travelRecords[index] = updatedRecord
            saveData()
        } else {
            print("Failed to update record: Record not found")
        }
    }
    
    func getRecord(by id: String) -> TravelRecord? {
        // recordID가 "1"로 고정
        let recordID = "1"
        return travelRecords.first { $0.id.uuidString == recordID }
    }

//    func ensureDefaultRecordExists() -> TravelRecord {
//        let recordID = "1"
//        if let record = getRecord(by: recordID) {
//            return record
//        }
//
//        // 기본 레코드 생성
//        let defaultRecord = TravelRecord(
//            id: UUID(uuidString: recordID) ?? UUID(),
//            title: "Default Title",
//            startDate: "2024-01-01",
//            endDate: "2024-01-02",
//            location: "Default Location",
//            companion: "Default Companion",
//            bottle: "Default Bottle",
//            oneLine1: "",
//            oneLine2: ""
//        )
//        addRecord(defaultRecord)
//        return defaultRecord
//    }

    // recordID "1"에 대한 레코드 반환 (없으면 기본 레코드 생성)
    func getFixedRecord() -> TravelRecord {
        if let record = getRecord(by: recordID) {
            return record
        } else {
            let defaultRecord = TravelRecord(
                id: UUID(uuidString: recordID) ?? UUID(),
                title: "Default Title",
                startDate: "2024-01-01",
                endDate: "2024-12-31",
                location: "Default Location",
                companion: "Alone",
                bottle: "",
                photos: [],
                oneLine1: "Default Line 1",
                oneLine2: "Default Line 2"
            )
            addRecord(defaultRecord)
            return defaultRecord
        }
    }
}
