import Foundation

struct PhotoData: Codable {
    var imagePath: String
    var text: String
    var categories: [String]
    
    init(imagePath: String, text: String, categories: [String]) {
        self.imagePath = imagePath
        self.text = text
        self.categories = categories
    }

    init?(from dictionary: [String: Any]) {
        guard let imageUrl = dictionary["imageUrl"] as? String,
              let text = dictionary["text"] as? String,
              let categories = dictionary["categories"] as? [String] else { return nil }
        
        self.imagePath = imageUrl
        self.text = text
        self.categories = categories
    }
}
