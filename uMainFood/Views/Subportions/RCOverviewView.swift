/*  Goal explanation:  View restaurant overview info at a glance   */


import SwiftUI

// Overview view with dynamic display
struct RCOverviewView: View {
    let rating: Double
    let deliveryTimeInMinutes: Int
    let activeTags: [String]
    let title: String
    
    // Default parameter values
    init(rating: Double = 5.0,
         deliveryTimeInMinutes: Int = 30,
         activeTags: [String] = ["Tag", "Tag", "Tag"],
         title: String = "Title") {
        self.rating = rating
        self.deliveryTimeInMinutes = deliveryTimeInMinutes
        self.activeTags = activeTags
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
                .padding()
                .background(Rectangle()
                    .cardBackgroundStyle())
            Spacer()
        }
    }
    
    private var content: some View {
        VStack {
            RCHeadlineView(title: title, rating: rating)
            TagsView(activeTags: activeTags, isCompact: true)
            RCDeliveryEstimateView(minutes: deliveryTimeInMinutes)
        }
        .padding(.leading, RCVConst.overViewPadding)
    }
}

struct RCOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        RCOverviewView()
    }
}
