/*  Goal explanation:  View an open or closed sign   */


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
