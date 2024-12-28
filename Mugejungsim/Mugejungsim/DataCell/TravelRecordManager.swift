//
//  TravelRecordManager.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/28/24.
//

import UIKit

struct TravelRecord: Codable {
    var id: UUID
    var title: String
    var description: String
    var date: String
    var location: String
    var photos: [PhotoData] // `PhotoData` 사용

    init(title: String, description: String, date: String, location: String, photos: [PhotoData] = []) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.date = date
        self.location = location
        self.photos = photos
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
        guard var record = getRecord(by: recordID), index < record.photos.count else {
            return false
        }

        // `DataManager`를 사용하여 이미지 삭제
        let photoToDelete = record.photos[index]
        DataManager.shared.deleteData(photoData: photoToDelete)

        // 사진 목록 업데이트
        record.photos.remove(at: index)
        updateRecord(record)
        return true
    }

    // MARK: - 기록 업데이트
    private func updateRecord(_ updatedRecord: TravelRecord) {
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
