import SwiftUI

struct AddCountdownView: View {
    @EnvironmentObject var store: CountdownStore
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var targetDate = Date().addingTimeInterval(86400)

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Neuer Countdown")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Titel", text: $title)

            DatePicker(
                "Zieldatum",
                selection: $targetDate,
                displayedComponents: .date
            )

            HStack {
                Button("Abbrechen") {
                    dismiss()
                }

                Spacer()

                Button("Speichern") {
                    store.add(title: title.isEmpty ? "Ohne Titel" : title, targetDate: targetDate)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 360)
    }
}
