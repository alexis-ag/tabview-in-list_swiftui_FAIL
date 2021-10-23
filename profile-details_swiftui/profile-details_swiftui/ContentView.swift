import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: ProfileDetailsView()) {
                Text("Open profile details")
            }
        }
    }
}