/*  Goal explanation:  View restaurant title and its rating in one line   */


import SwiftUI

struct RCHeadlineView: View {
    let title: String
    let rating: Double
    
    var body: some View {
        HStack {
            DynamicScaleTextLine(text: title)
                .frame(height:  32)
            Spacer()
            RCRatingView(rating: rating)
        }
    }
}

struct RCHeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        RCHeadlineView(title: "Long Example Which Must Fit One Line", rating: 4.5)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
