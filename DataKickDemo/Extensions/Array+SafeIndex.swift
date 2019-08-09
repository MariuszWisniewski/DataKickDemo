import Foundation

extension Array {
    func safeObject(at index: Int) -> Element? {
        if count > index {
            return self[index]
        }
        return nil
    }
}
