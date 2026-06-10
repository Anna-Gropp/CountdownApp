import Foundation
import Combine
import SwiftUI
import WidgetKit

final class CountdownStore: ObservableObject {
    @Published var countdowns: [Countdown] = [] {
        didSet {
            save()
        }
    }

    private let storageKey = "savedCountdowns"
    static let appGroupID = "group.com.GroppAnna.countdownwidget"

    private var defaults: UserDefaults {
        UserDefaults(suiteName: Self.appGroupID) ?? .standard
    }

    init() {
        load()
    }

    func add(title: String, targetDate: Date) {
        let dateOnly = Calendar.current.startOfDay(for: targetDate)

        countdowns.append(Countdown(title: title, targetDate: dateOnly))
        WidgetCenter.shared.reloadAllTimelines()
    }

    func update(countdown: Countdown, title: String, targetDate: Date) {
        guard let index = countdowns.firstIndex(where: { $0.id == countdown.id }) else { return }

        countdowns[index].title = title
        countdowns[index].targetDate = Calendar.current.startOfDay(for: targetDate)
        
        WidgetCenter.shared.reloadAllTimelines()
    }

    func delete(_ countdown: Countdown) {
        countdowns.removeAll { $0.id == countdown.id }
        WidgetCenter.shared.reloadAllTimelines()
    }

    func delete(at offsets: IndexSet) {
        countdowns.remove(atOffsets: offsets)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(countdowns) {
            defaults.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Countdown].self, from: data) else {
            countdowns = [
                Countdown(title: "Mein erstes Event", targetDate: Date().addingTimeInterval(86400 * 7))
            ]
            return
        }

        countdowns = decoded
    }
}
