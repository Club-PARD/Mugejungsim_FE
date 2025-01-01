//
//  CategoryMockData.swift
//  Mugejungsim
//
//  Created by 도현학 on 12/27/24.
//


import UIKit

struct MockData {
    static let shared = MockData()
    let rows: [Int: [String]] = [
        0: ["☁️ 구름 사이로 내려앉은 부드러운 위로",
            "🧣 차분한 온기가 보내오는 고요함",
            "🛏️ 부드러운 이불 속에 안긴 듯한 아늑함",
            "🌻 햇살 사이로 스며드는 평온함",
            "🍵 느릿한 순간들이 선물하는 마음의 쉼표"],
        1: [ "🌅 눈부신 아름다움 앞에 숨이 멎는 순간",
             "🌸 마음 깊이 여운으로 스며드는 조용한 시간",
             "🌊 그리움의 물결이 가슴에 잔잔히 번지는 순간",
             "🎇 소중한 순간들이 빛처럼 가슴에 내려앉는 감동",
             "🌿 마음의 문이 살며시 열리는 따뜻한 순간"],
        2: ["☀️ 햇살에 물든 따뜻한 순간",
            "❤️ 사랑의 온기가 스며드는 기억",
            "🍂 소중한 추억이 담긴 조각들",
            "✨ 따뜻한 미소가 전하는 행복의 빛",
            "🌸 순간의 마법이 만들어낸 설렘"],
        3: ["🌍 미지의 세계로 떠나는 짜릿한 설렘",
            "🎉 순간이 전해주는 놀라움",
            "🪁 아이처럼 맑게 뛰노는 즐거움",
            "🏃‍♂️ 가슴을 뛰게 하는 신나는 순간",
            "⛰️ 새로운 길에 도전하는 용기"]
    ]
}
