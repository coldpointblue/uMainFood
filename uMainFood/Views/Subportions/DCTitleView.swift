/*  Goal explanation:  View title in Detail Card   */


import SwiftUI

struct DCTitleView: View {
    let title: String
    
    var body: some View {
        DynamicScaleTextLine(text: title)
            .frame(height:  38)
    }
}

struct DCTitleView_Previews: PreviewProvider {
    static var previews: some View {
        DCTitleView(title: "ExampleTitle")
    }
}
