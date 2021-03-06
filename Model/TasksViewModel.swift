import Foundation
import SwiftUI
@available(iOS 13.0, *)
class TasksViewModel: ObservableObject {
    @Published var allTasks: [Task] = []
    @Published var currentSelectedTask: Task?
    @Published var isLogging = false
    @Published var showingPomodoroTimer = false
    @Published var manualRefresh: Bool = false
    init() {
        if let savedTasks: [Task] = FileManager.default.fetchData(from: FMKeys.allTasks) {
            self.allTasks = savedTasks
            if let savedCurrentTask: Task = FileManager.default.fetchData(from: FMKeys.currentTask) {
                if let index = allTasks.firstIndex(where: { $0.id == savedCurrentTask.id }) {
                    self.currentSelectedTask = allTasks[index]
                    if currentSelectedTask?.loggingHistory.last?.endTime == nil {
                        self.isLogging = true
                    }
                }
                if let showingPomodoroTimer: Bool = FileManager.default.fetchData(from: FMKeys.showingPomodoroTimer) {
                    self.showingPomodoroTimer = showingPomodoroTimer
                }
            }
        }
    }
    init(tasks: [Task]) {
        self.allTasks = tasks
    }
    func startLoggingForNewTask(named taskName: String) {
        let newTask = Task(name: taskName, loggingHistory: [])
        currentSelectedTask = newTask
        allTasks.insert(newTask, at: 0)
        startLoggingForCurrentTask()
    }
    func startLoggingForCurrentTask() {
        guard currentSelectedTask != nil else { fatalError() }
        self.isLogging = true
        UIApplication.shared.isIdleTimerDisabled = true
        currentSelectedTask!.loggingHistory.append(LoggingRecord(taskID: currentSelectedTask!.id))
        persistTaskViewModelState()
    }
    func stopLoggingForCurrentTask() {
        self.isLogging = false
        UIApplication.shared.isIdleTimerDisabled = false
        guard currentSelectedTask != nil else { fatalError() }
        guard let loggingRecord = currentSelectedTask!.loggingHistory.last else { fatalError("There's no logging record to update.") }
        loggingRecord.endTime = Date()
        currentSelectedTask = nil
        persistTaskViewModelState()
    }
    func delete(task: Task) {
        if let index = allTasks.firstIndex(where: { $0.id == task.id }) {
            allTasks.remove(at: index)
            persistTaskViewModelState()
        }
    }
    func delete(loggingRecord: LoggingRecord) {
        for task in allTasks {
            if let logRecordIndex = task.loggingHistory.firstIndex(where: { $0.id == loggingRecord.id }) {
                guard let taskIndex = allTasks.firstIndex(where: { $0.id == task.id }) else { break }
                allTasks[taskIndex].loggingHistory.remove(at: logRecordIndex)
                persistTaskViewModelState()
                self.manualRefresh.toggle()
                break
            }
        }
    }
    func update(logRecord: LoggingRecord, startTime: Date, endTime: Date?) {
        if let taskIndex = allTasks.firstIndex(where: { $0.id == logRecord.taskID }) {
            if let logRecordIndex = allTasks[taskIndex].loggingHistory.firstIndex(where: { $0.id == logRecord.id }) {
                let logRecordToUpdate = allTasks[taskIndex].loggingHistory[logRecordIndex]
                logRecordToUpdate.startTime = startTime
                logRecordToUpdate.endTime = endTime
                persistTaskViewModelState()
            }
        }
    }
    func changeTask(id: UUID, name: String) {
        if let index = allTasks.firstIndex(where: { $0.id == id } ) {
            allTasks[index].name = name
            persistTaskViewModelState()
        }
    }
    func persistPomodoroState() {
        FileManager.default.writeData(showingPomodoroTimer, to: FMKeys.showingPomodoroTimer)
    }
    private func persistTaskViewModelState() {
        FileManager.default.writeData(allTasks, to: FMKeys.allTasks)
        FileManager.default.writeData(currentSelectedTask, to: FMKeys.currentTask)
    }
}
