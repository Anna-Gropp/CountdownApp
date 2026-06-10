import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: CountdownStore
    
    @State private var showingAddSheet = false
    @State private var selectedCountdown: Countdown?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.countdowns) { countdown in
                    CountdownCardView(countdown: countdown)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCountdown = countdown
                        }
                        .listRowSeparator(.hidden)
                }
                .onDelete(perform: store.delete)
            }
            .listStyle(.plain)
            .navigationTitle("Countdowns")
            .toolbar {
                Button {
                    showingAddSheet = true
                } label: {
                    Label("Neu", systemImage: "plus")
                }
            }
            
            Button {
                showingAddSheet = true
            } label: {
                Label("Neu", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddCountdownView()
                .environmentObject(store)
        }
        .sheet(item: $selectedCountdown) { countdown in
            EditCountdownView(countdown: countdown)
                .environmentObject(store)
        }
        
        .frame(minWidth: 420, minHeight: 520)
    }
}
