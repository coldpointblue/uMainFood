/*  Goal explanation:  View title in Detail Card   */


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
