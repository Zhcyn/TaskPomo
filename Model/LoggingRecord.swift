import Foundation
class LoggingRecord: Codable, Identifiable {
    let id = UUID()
    var taskID: UUID
    var startTime: Date
    var endTime: Date?
    var lengthInSeconds: Int {
        guard let endTime = self.endTime else { return 0 }
        let time = endTime.timeIntervalSince(startTime)
        return Int(time)
    }
    var startDateString: String { startTime.dateAsString }
    init(taskID: UUID, endTime: Date? = nil) {
        self.taskID = taskID
        self.startTime = Date()
        self.endTime = endTime
    }
}
