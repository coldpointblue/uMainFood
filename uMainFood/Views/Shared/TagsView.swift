/*  Goal explanation:  View formatted tags   */


import SwiftUI

struct TagsView: View {
    let activeTags: [String]
    let isCompact : Bool
    
    var body: some View {
        HStack {
            let style = isCompact ? FontStyleCombo.compactStyle : FontStyleCombo.regularStyle
            
            Text(activeTags.joined(separator: " • "))
                .foregroundColor(TVConst.grayTagShadeColor)
                .font(style.font)
                .fontWeight(style.weight)
            Spacer()
        }
    }
}

struct FontStyleCombo {
    var font: Font
    var weight: Font.Weight
}

extension FontStyleCombo {
    static let compactStyle = FontStyleCombo(font: .subheadline, weight: .heavy)
    static let regularStyle = FontStyleCombo(font: .title2, weight: .regular)
}

// Constants for simpler updates
typealias TVConst = TagsViewConst

struct TagsViewConst {
    static let grayTagShadeColor = Color.gray.opacity(0.7706)
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView(activeTags: ["ExampleTag", "OtherExampleTag"], isCompact: true)
    }
}
