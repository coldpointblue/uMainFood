//  ----------------------------------------------------
//
//  DCDetailsView.swift
//  Version 1.0
//
//  Unique ID:  BF657C0A-F8B4-4BF7-8DCA-322DE1F6123A
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-20.
//  
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  View details of specific restaurant   */
//  ----------------------------------------------------


import SwiftUI

// Details view with dynamic display
struct DCDetailsView: View {
    let title: String
    let subtitle: [String]
    let isOpen: Bool
    private let spaceToEdge: CGFloat = 18
    
    // Default parameter values
    init( title: String = "Title", subtitle: [String] = ["Take-Out", "Fast Delivery", "Eat In"], isOpen : Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.isOpen = isOpen
    }
    
    var body: some View {
        ZStack {
            detailsBackground
            content
        }
        .padding(EdgeInsets(top: 0, leading: spaceToEdge, bottom: 0, trailing: spaceToEdge))
    }
    
    private var detailsBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .cardBackgroundStyle()
            .frame(width: DCConst.picSize.width - (spaceToEdge * 2), height: DCConst.picSize.height)
    }
    
    private var content: some View {
        VStack {
            DCTitleView(title: title)
            TagsView(activeTags: subtitle, isCompact: false)
                .padding(.vertical, 4)
            DCOpenOrNotView(isOpen: isOpen)
        }
        .padding(EdgeInsets(top: 0, leading: DCConst.overViewPadding + 8, bottom: 0, trailing: DCConst.overViewPadding))
    }
}

struct DCDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DCDetailsView()
    }
}
