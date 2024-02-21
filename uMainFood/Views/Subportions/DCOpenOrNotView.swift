//  ----------------------------------------------------
//
//  DCOpenOrNotView.swift
//  Version 1.0
//
//  Unique ID:  4262897A-53CD-4D2F-9F59-FC5A1C851710
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
/*  Goal explanation:  View an open or closed sign   */
//  ----------------------------------------------------


import SwiftUI

struct DCOpenOrNotView: View {
    let isOpen: Bool
    
    var body: some View {
        HStack {
            Text(isOpen ?
                 "open_sign" : "closed_sign")
            .font(.title)
            .foregroundColor(isOpen ? .green : .red)
            Spacer()
        }
    }
}

struct DCOpenOrNotView_Previews: PreviewProvider {
    static var previews: some View {
        DCOpenOrNotView(isOpen: true)
    }
}
