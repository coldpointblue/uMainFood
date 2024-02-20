//  ----------------------------------------------------
//
//  RestaurantCardView.swift
//  Version 1.0
//
//  Unique ID:  968BD13F-A39A-4F94-BC9A-6EA3410EDA99
//
//  part of the uMainFood™ product.
//
//  Written in Swift 5.0 on macOS 14.3
//
//  https://github.com/coldpointblue
//  Created by Hugo Diaz on 2024-02-17.
//
//  ----------------------------------------------------

//  ----------------------------------------------------
/*  Goal explanation:  View the Restaurant Card overview info   */
//  ----------------------------------------------------


import SwiftUI

struct RestaurantCardView: View {
    var body: some View {
        ZStack {
            Color(Color.clear)
            VStack(spacing: 0) {
                RCFoodImageView(imageName: "wanted_image_name")
                    .roundTopCorners()
                RCOverviewView(rating: 5, deliveryTimeInMinutes: 121, activeTags: ["Tag", "Tag", "Tag"], title: "Title")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(RCVConst.picSize.width / RCVConst.picSize.height, contentMode: .fit)
        }
    }
}

// Constants for simpler updates
typealias RCVConst = RestaurantCardViewConst

struct RestaurantCardViewConst {
    static let picSize = CGSize(width: 375, height: 220)
    static let overViewPadding: CGFloat = 8
}

struct RestaurantCardView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCardView()
    }
}
