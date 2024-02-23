/*  Goal explanation:  View time converted from minutes into words   */


import SwiftUI

struct RCDeliveryEstimateView: View {
    let minutes: Int
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .scaleEffect(x: -1, y: 1)
                .foregroundColor(.red)
            Text(TimeIntoWordsFormatter.format(minutes: minutes))
            Spacer()
        }
        .font(.footnote)
    }
}

struct RCDeliveryEstimateView_Previews: PreviewProvider {
    static var previews: some View {
        RCDeliveryEstimateView(minutes: 121)
    }
}
