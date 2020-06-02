import Foundation
extension Array {
    mutating func move(from oldPosition: Int, to newPosition: Int) {
        let element = self.remove(at: oldPosition)
        self.insert(element, at: newPosition)
    }
}
