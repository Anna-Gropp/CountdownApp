import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var store: CountdownStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if store.countdowns.isEmpty {
                Text("Keine Countdowns")
            } else {
                ForEach(store.countdowns.prefix(5)) { countdown in
                    VStack(alignment: .leading) {
                        Text(countdown.title)
                            .fontWeight(.semibold)

                        Text(countdown.timeRemainingText)
                            .foregroundStyle(.secondary)
                    }

                    Divider()
                }
            }

            Button("App öffnen") {
                NSApp.activate(ignoringOtherApps: true)
            }

            Button("Beenden") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 260)
    }
}
