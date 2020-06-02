import Foundation
class Task: Identifiable, Codable {
    var id = UUID()
    var name: String
    var loggingHistory: [LoggingRecord]
    var targets: [Target]? 
    init(name: String, loggingHistory: [LoggingRecord]) {
        self.name = name
        self.loggingHistory = loggingHistory
    }
    func getSecondsRecordedToday() -> Int {
        let startOfDay = Calendar(identifier: .gregorian).startOfDay(for: Date())
        let filteredHistoryRecords = loggingHistory.filter { $0.startTime > startOfDay }
        return filteredHistoryRecords.reduce(0) { $0 + $1.lengthInSeconds}
    }
    func getSecondsRecordedThisWeek() -> Int {
        guard let startOfThisWeek = Date().startOfThisWeek else { return 0 }
        let filteredHistoryRecords = loggingHistory.filter { $0.startTime > startOfThisWeek }
        return filteredHistoryRecords.reduce(0) { $0 + $1.lengthInSeconds }
    }
    func getSecondsRecordedThisMonth() -> Int {
        guard let startOfThisMonth = Date().startOfThisMonth else { return 0 }
        let filteredHistoryRecords = loggingHistory.filter { $0.startTime > startOfThisMonth }
        return filteredHistoryRecords.reduce(0) { $0 + $1.lengthInSeconds}
    }
    func getSecondsRecordedAllTime() -> Int { loggingHistory.reduce(0) { $0 + $1.lengthInSeconds} }
}
