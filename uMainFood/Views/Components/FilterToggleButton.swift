/*  Goal explanation:  Filter toggle button with customizable icon and visual feedback   */


import SwiftUI

// Toggle button with customizable icon
struct FilterToggleButton<Icon: View>: View {
    @Binding var isOn: Bool
    let icon: Icon
    let tag: String
    private let onColor: Color = .selected
    private let offColor: Color = .grayLightShadeColor
    private let iconWidth : CGFloat = 48
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: toggleState) {
            buttonContent
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .animation(.easeInOut(duration: 0.3), value: isPressed)
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: 10,
            perform: {},
            onPressingChanged: { isPressing in
                isPressed = isPressing
            }
        )
    }
    
    private var buttonContent: some View {
        HStack {
            icon
                .frame(width: iconWidth, height: iconWidth)
                .background(.clear)
                .cornerRadius(iconWidth/2)
            
            Text(tag)
                .font(.title3)
                .foregroundColor(.darkText)
                .padding(.leading, isPressed ? iconWidth/2 : 0)
                .padding(.trailing)
        }
        .frame(height: iconWidth)
        .background(isOn ? onColor : offColor)
        .cornerRadius(24)
        .scaleEffect(isPressed ? 1.1 : 1.0)
    }
    
    private func toggleState() {
        isOn.toggle()
    }
}

// Example Usage with BlankIcon
struct BlankIcon: View {
    var body: some View {
        ZStack {
            Image(systemName: "circle.dashed")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Image(systemName: "icloud.slash")
                .imageScale(.large)
        }
    }
}

struct FilterToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterToggleButtonStatePreview()
    }
    
    private struct FilterToggleButtonStatePreview: View {
        @State private var isOn = false
        
        var body: some View {
            FilterToggleButton(isOn: $isOn, icon: BlankIcon(), tag: "Fast Delivery")
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Filter Toggle Button")
        }
    }
}
