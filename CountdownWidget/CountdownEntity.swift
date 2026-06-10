import AppIntents
import Foundation

struct CountdownEntity: AppEntity {
    let id: String
    let title: String

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Countdown")
    static var defaultQuery = CountdownQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}

struct CountdownQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [CountdownEntity] {
        loadCountdowns()
            .filter { identifiers.contains($0.id.uuidString) }
            .map { CountdownEntity(id: $0.id.uuidString, title: $0.title) }
    }

    func suggestedEntities() async throws -> [CountdownEntity] {
        loadCountdowns()
            .map { CountdownEntity(id: $0.id.uuidString, title: $0.title) }
    }

    private func loadCountdowns() -> [Countdown] {
        let defaults = UserDefaults(suiteName: "group.com.GroppAnna.countdownwidget")

        guard let data = defaults?.data(forKey: "savedCountdowns"),
              let decoded = try? JSONDecoder().decode([Countdown].self, from: data) else {
            return []
        }

        return decoded.sorted { $0.targetDate < $1.targetDate }
    }
}
