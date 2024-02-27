import UIKit

extension Date {
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_EN")
        return dateFormatter.string(from: self).lowercased()
    }
    
    func dayOfMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        dateFormatter.locale = Locale(identifier: "en_EN")
        return dateFormatter.string(from: self).uppercased()
    }
    
}
