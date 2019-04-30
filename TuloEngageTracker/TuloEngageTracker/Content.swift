import Foundation

struct Content: Codable {
    let state: String?
    let type: String?
    let articleId: String?
    let publishDate: Date?
    let title: String?
    let section: String?
    let keywords: [String]?
    let authorId: [String]?
    let articleLon: String?
    let articleLat: String?

}
