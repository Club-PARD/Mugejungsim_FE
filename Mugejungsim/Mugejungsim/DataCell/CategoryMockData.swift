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
        0: ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet"],
        1: ["Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango"],
        2: ["Uniform", "Victor", "Whiskey", "X-ray", "Yankee", "Zulu", "Echo", "Delta", "Alpha", "Bravo"],
        3: ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"],
        4: ["Dog", "Cat", "Bird", "Fish", "Horse", "Lion", "Tiger", "Bear", "Wolf", "Fox"]
    ]
}
