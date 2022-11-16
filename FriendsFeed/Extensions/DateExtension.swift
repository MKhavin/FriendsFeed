import Foundation

extension Date {
    func formatted(by format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: self)
    }
}
