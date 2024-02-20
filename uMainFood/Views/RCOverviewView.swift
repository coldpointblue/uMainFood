//  ----------------------------------------------------
//
//  RCOverviewView.swift
//  Version 1.0
//
//  Unique ID:  783B1EFF-09D9-410A-B8D9-E1D3C515F2D0
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-19.
//
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  View restaurant overview info at a glance   */
//  ----------------------------------------------------


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
                .padding(.horizontal, RCVConst.overViewPadding)
                .padding(.vertical)
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
    }
}

struct RCOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        RCOverviewView()
    }
}
