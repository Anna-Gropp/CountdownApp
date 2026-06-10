import AppIntents
import Foundation

struct CountdownSelectionIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Countdown auswählen"
    static var description = IntentDescription("Wähle aus, welcher Countdown im Widget angezeigt wird.")

    @Parameter(title: "Countdown")
    var countdown: CountdownEntity?
}
