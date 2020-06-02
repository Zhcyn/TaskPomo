import Foundation
enum Period: String, Codable {
    case perDay
    case perWeek
    case perMonth
}
enum TargetType: String, Codable {
    case minimum
    case maximum
}
struct Target: Codable {
    let taskID: UUID
    let amount: Int
    let period: Period
    let target: TargetType
}
