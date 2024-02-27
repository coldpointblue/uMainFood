/*  Goal explanation:  View an open or closed sign   */


import SwiftUI

struct DCOpenOrNotView: View {
    // Mock isOpen random because API.Model.Restaurant has no schedule
    @State private var isOpen: Bool = true
    
    var body: some View {
        HStack {
            Text(isOpen ?
                 "open_sign" : "closed_sign")
            .font(.title)
            .foregroundColor(isOpen ? .green : .red)
            Spacer()
        }
        .onAppear {
            isOpen = Bool.random()
        }
    }
}

struct DCOpenOrNotView_Previews: PreviewProvider {
    static var previews: some View {
        DCOpenOrNotView()
    }
}
