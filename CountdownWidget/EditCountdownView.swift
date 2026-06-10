import SwiftUI

struct EditCountdownView: View {
    @EnvironmentObject var store: CountdownStore
    @Environment(\.dismiss) private var dismiss

    let countdown: Countdown

    @State private var title: String
    @State private var targetDate: Date

    init(countdown: Countdown) {
        self.countdown = countdown
        _title = State(initialValue: countdown.title)
        _targetDate = State(initialValue: countdown.targetDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Countdown bearbeiten")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Titel", text: $title)

            DatePicker(
                "Zieldatum",
                selection: $targetDate,
                displayedComponents: .date
            )

            HStack {
                Button("Löschen", role: .destructive) {
                    store.delete(countdown)
                    dismiss()
                }

                Spacer()

                Button("Abbrechen") {
                    dismiss()
                }

                Button("Speichern") {
                    store.update(
                        countdown: countdown,
                        title: title.isEmpty ? "Ohne Titel" : title,
                        targetDate: targetDate
                    )
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 380)
    }
}
