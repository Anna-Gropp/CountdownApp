import SwiftUI

@main
struct CountdownWidgetApp: App {
    @StateObject private var store = CountdownStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }

        MenuBarExtra("Countdown", systemImage: "timer") {
            MenuBarView()
                .environmentObject(store)
        }
    }
}
