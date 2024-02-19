//  ----------------------------------------------------
//
//  RCFoodImageView.swift
//  Version 1.0
//
//  Unique ID:  26254467-E3C9-4440-9F2B-63FC3347D0AA
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
/*  Goal explanation:  View with image of food from specific restaurant   */
//  ----------------------------------------------------


import SwiftUI

// Image view with conditional loading
struct RCFoodImageView: View {
    let imageName: String
    @State private var showErrorImage = false
    
    var body: some View {
        Group {
            if let image = UIImage(named: imageName), !showErrorImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(RCVConst.picSize, contentMode: .fill)
                    .clipped()
            } else {
                placeholderImage
            }
        }
        .onAppear {
            if UIImage(named: imageName) == nil {
                showErrorImage = true
            }
        }
        .frame(width: RCVConst.picSize.width, height: RCVConst.picSize.height)
    }
    
    private var placeholderImage: some View {
        ZStack {
            Color.red.opacity(0.09)
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .padding(40)
                .foregroundColor(RCVConst.grayPlaceholderShadeColor)
                .frame(width: RCVConst.picSize.width, height: RCVConst.picSize.height)
                .font(.system(size: 100))
        }
    }
}

struct RCFoodImageView_Previews: PreviewProvider {
    static var previews: some View {
        RCFoodImageView(imageName: "exampleImage")
    }
}
