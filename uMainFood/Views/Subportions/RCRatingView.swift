//  ----------------------------------------------------
//
//  RCRatingView.swift
//  Version 1.0
//
//  Unique ID:  6CBF4240-9A5B-4275-B657-13EA3241B522
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
/*  Goal explanation:  View restaurant rating in stars from 0.0 to 5.0   */
//  ----------------------------------------------------


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
