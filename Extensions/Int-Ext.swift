import Foundation
extension Int {
    func secondsToHoursMinsSecs() -> String {
        let hours = self / 3600
        let mins = (self % 3600) / 60
        let secs = (self % 3600) % 60
        return hours < 1 ? String(format: "%01d:%02d", mins, secs) : String(format: "%01d:%02d:%02d", hours, mins, secs)
    }
    func secondsToHoursMins() -> String {
        let hours = self / 3600
        let mins = (self % 3600) / 60
        if hours > 0 {
            return String(format: "%01dh %01dm", hours, mins)
        }
        return String(format: "%01dm", mins)
    }
    func secondsToHoursMinsMinimal() -> String {
        let hours = self / 3600
        let mins = (self % 3600) / 60
        return String(format: "%02d : %02d", hours, mins)
    }
    func secondsToHoursMinsSpit() -> (hours: String, mins: String) {
        let hours = self / 3600
        let mins = (self % 3600) / 60
        let hoursReturnValue = String(format: "%02d", hours)
        let minsReturnValue = String(format: "%02d", mins)
        return (hours: hoursReturnValue, mins: minsReturnValue)
    }
}
