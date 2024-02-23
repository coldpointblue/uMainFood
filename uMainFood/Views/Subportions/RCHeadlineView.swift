/*  Goal explanation:  View restaurant title and its rating in one line   */


import SwiftUI

struct RCHeadlineView: View {
    let title: String
    let rating: Double
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title)
            Spacer()
            RCRatingView(rating: rating)
        }
    }
}

struct RCHeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        RCHeadlineView(title: "ExampleTitle", rating: 5.0)
    }
}
