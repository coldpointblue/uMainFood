//  ----------------------------------------------------
//
//  DCTitleView.swift
//  Version 1.0
//
//  Unique ID:  DCB1EF96-4D26-4335-8EC1-1A339619A44E
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
/*  Goal explanation:  View title in Detail Card   */
//  ----------------------------------------------------


import SwiftUI

struct DCTitleView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
            Spacer()
        }
    }
}

struct DCTitleView_Previews: PreviewProvider {
    static var previews: some View {
        DCTitleView(title: "ExampleTitle")
    }
}
