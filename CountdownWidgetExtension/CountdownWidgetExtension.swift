import WidgetKit
import SwiftUI

struct CountdownWidgetEntry: TimelineEntry {
    let date: Date
    let countdown: Countdown?
}

struct CountdownWidgetProvider: AppIntentTimelineProvider {
    let storageKey = "savedCountdowns"
    let appGroupID = "group.com.GroppAnna.countdownwidget"

    func placeholder(in context: Context) -> CountdownWidgetEntry {
        CountdownWidgetEntry(
            date: Date(),
            countdown: Countdown(
                title: "Geburtstag",
                targetDate: Date().addingTimeInterval(86400 * 12)
            )
        )
    }

    func snapshot(for configuration: CountdownSelectionIntent, in context: Context) async -> CountdownWidgetEntry {
        CountdownWidgetEntry(
            date: Date(),
            countdown: selectedCountdown(from: configuration) ?? loadCountdowns().first
        )
    }

    func timeline(for configuration: CountdownSelectionIntent, in context: Context) async -> Timeline<CountdownWidgetEntry> {
        let countdown = selectedCountdown(from: configuration) ?? loadCountdowns().first

        var entries: [CountdownWidgetEntry] = []
        let calendar = Calendar.current
        let now = Date()

        for dayOffset in 0..<30 {
            if let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: now) {
                let startOfDay = calendar.startOfDay(for: entryDate)

                entries.append(
                    CountdownWidgetEntry(
                        date: startOfDay,
                        countdown: countdown
                    )
                )
            }
        }

        let nextReload = calendar.date(
            byAdding: .day,
            value: 30,
            to: now
        ) ?? now.addingTimeInterval(86400 * 30)

        return Timeline(entries: entries, policy: .after(nextReload))
    }

    private func selectedCountdown(from configuration: CountdownSelectionIntent) -> Countdown? {
        guard let selectedID = configuration.countdown?.id else {
            return nil
        }

        return loadCountdowns().first {
            $0.id.uuidString == selectedID
        }
    }

    private func loadCountdowns() -> [Countdown] {
        let defaults = UserDefaults(suiteName: appGroupID)

        guard let data = defaults?.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Countdown].self, from: data) else {
            return []
        }

        return decoded.sorted { $0.targetDate < $1.targetDate }
    }
}

struct CountdownWidgetView: View {
    var entry: CountdownWidgetProvider.Entry

    var body: some View {
        if let countdown = entry.countdown {
            VStack(spacing: 8) {
                Text(countdown.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)

                Spacer()

                Text(daysText(until: countdown.targetDate, currentDate: entry.date))                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)

                Spacer()

                Text(
                    countdown.targetDate.formatted(
                        .dateTime
                            .day(.twoDigits)
                            .month(.twoDigits)
                            .year()
                    )
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerBackground(.fill.tertiary, for: .widget)
        } else {
            VStack(spacing: 8) {
                Text("Kein Event")
                    .font(.headline)

                Text("Öffne die App und erstelle ein Event.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
        }
    }

    private func daysText(until date: Date, currentDate: Date) -> String {
        let calendar = Calendar.current

        let today = calendar.startOfDay(for: currentDate)
        let targetDay = calendar.startOfDay(for: date)

        let days = calendar.dateComponents(
            [.day],
            from: today,
            to: targetDay
        ).day ?? 0

        if days < 0 {
            return "Done"
        }

        if days == 0 {
            return "Today"
        }

        if days == 1 {
            return "1 day"
        }

        return "\(days) days"
    }
}

struct CountdownWidgetExtension: Widget {
    let kind: String = "CountdownWidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: CountdownSelectionIntent.self,
            provider: CountdownWidgetProvider()
        ) { entry in
            CountdownWidgetView(entry: entry)
        }
    }
}
