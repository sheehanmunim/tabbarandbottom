import SwiftUI

struct InitialView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: ContentView().navigationBarHidden(true)) {
                Text("Please")
            }
        }
      
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
