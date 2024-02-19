//  ----------------------------------------------------
//
//  TagsView.swift
//  Version 1.0
//
//  Unique ID:  4CE41DCF-A325-47EE-81F1-F0F2C53E7C43
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
/*  Goal explanation:  View formatted tags   */
//  ----------------------------------------------------


import SwiftUI

struct TagsView: View {
    let activeTags: [String]
    
    var body: some View {
        HStack {
            Text(activeTags.joined(separator: " • "))
                .foregroundColor(RCVConst.grayTagShadeColor)
                .font(.subheadline)
                .fontWeight(.heavy)
            Spacer()
        }
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView(activeTags: ["ExampleTag", "OtherExampleTag"])
    }
}
