//  ----------------------------------------------------
//
//  RCHeadlineView.swift
//  Version 1.0
//
//  Unique ID:  D8F92FB2-ED13-45CA-AF4E-92712E9BF7A5
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
/*  Goal explanation:  View restaurant title and its rating in one line   */
//  ----------------------------------------------------


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
