/*  Goal explanation:  View restaurant rating in stars from 0.0 to 5.0   */


import SwiftUI

// Rating automatically corrects input to limits from 0.0 to 5.0
struct RCRatingView: View {
    let rating: Double
    
    var body: some View {
        HStack {
            Text("★").foregroundColor(.yellow)
            Text(String(format: "%.1f", max(0, min(rating, 5.0))))
                .bold()
                .padding(.trailing)
        }
    }
}

struct RCRatingView_Previews: PreviewProvider {
    static var previews: some View {
        RCRatingView(rating: 5.0)
    }
}
