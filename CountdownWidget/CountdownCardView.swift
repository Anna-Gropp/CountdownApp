import SwiftUI

struct CountdownCardView: View {
    let countdown: Countdown

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(countdown.title)
                .font(.title2)
                .fontWeight(.semibold)

            Text(countdown.timeRemainingText)
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text(countdown.targetDate.formatted(date: .long, time: .omitted))
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.vertical, 6)
    }
}
