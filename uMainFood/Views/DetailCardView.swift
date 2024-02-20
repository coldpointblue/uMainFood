//  ----------------------------------------------------
//
//  DetailCardView.swift
//  Version 1.0
//
//  Unique ID:  4F781359-DDE8-4482-B09C-A5CEC481173F
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
/*  Goal explanation:  View details of a restaurant and its food image   */
//  ----------------------------------------------------


import SwiftUI

struct DetailCardView: View {
    var body: some View {
        ZStack {
            Color(Color.grayLightShadeColor)
            VStack(spacing: 0) {
                RCFoodImageView(imageName: "exampleImage")
                DCDetailsView(title: "Emilias Fancy Food")
                    .offset(y: -DCConst.picSize.height/5)
            }
        }
    }
}

// Constants for simpler updates
typealias DCConst = DetailCardViewConstants

struct DetailCardViewConstants {
    static let picSize = CGSize(width: 375, height: 220)
    static let overViewPadding: CGFloat = 8
}

struct DetailCardView_Previews: PreviewProvider {
    static var previews: some View {
        DetailCardView()
    }
}

