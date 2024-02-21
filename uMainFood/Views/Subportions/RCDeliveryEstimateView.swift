//  ----------------------------------------------------
//
//  RCDeliveryEstimateView.swift
//  Version 1.0
//
//  Unique ID:  962BD4A3-AE91-4291-A231-82D09717F48B
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
/*  Goal explanation:  View time converted from minutes into words   */
//  ----------------------------------------------------


import SwiftUI

struct RCDeliveryEstimateView: View {
    let minutes: Int
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .scaleEffect(x: -1, y: 1)
                .foregroundColor(.red)
            Text(TimeIntoWordsFormatter.format(minutes: minutes))
            Spacer()
        }
        .font(.footnote)
    }
}

struct RCDeliveryEstimateView_Previews: PreviewProvider {
    static var previews: some View {
        RCDeliveryEstimateView(minutes: 121)
    }
}
