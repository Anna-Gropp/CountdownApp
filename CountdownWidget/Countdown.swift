import Foundation

struct Countdown: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var targetDate: Date
    var colorName: String = "blue"

    var timeRemainingText: String {
        let calendar = Calendar.current

        let today = calendar.startOfDay(for: Date())
        let targetDay = calendar.startOfDay(for: targetDate)

        let days = calendar.dateComponents(
            [.day],
            from: today,
            to: targetDay
        ).day ?? 0

        if days < 0 {
            return "Abgelaufen"
        }

        if days == 0 {
            return "Heute"
        }

        if days == 1 {
            return "1 Tag"
        }

        return "\(days) Tage"
    }
}
