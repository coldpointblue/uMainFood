/*  Goal explanation:  View details of specific restaurant   */


import SwiftUI

// Details view with dynamic display
struct DCDetailsView: View {
    let title: String
    let subtitle: [String]
    let isOpen: Bool
    private let spaceToEdge: CGFloat = 18
    
    // Default parameter values
    init( title: String, subtitle: [String], isOpen : Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.isOpen = isOpen
    }
    
    var body: some View {
        ZStack {
            detailsBackground
            content
        }
        .frame(width: DCConst.picSize.width - (spaceToEdge * 2), height: DCConst.picSize.height)
        .padding(EdgeInsets(top: 0, leading: spaceToEdge, bottom: 0, trailing: spaceToEdge))
    }
    
    private var detailsBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .cardBackgroundStyle()
    }
    
    private var content: some View {
        VStack {
            DCTitleView(title: title)
            TagsView(activeTags: subtitle, isCompact: false)
                .padding(.vertical, 4)
            DCOpenOrNotView()
        }
        .padding(EdgeInsets(top: 0, leading: DCConst.overViewPadding + 8, bottom: 0, trailing: DCConst.overViewPadding))
    }
}

struct DCDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DCDetailsView(title: API.Model.Restaurant.example.name, subtitle: [])
    }
}
