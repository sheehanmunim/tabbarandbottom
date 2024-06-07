import SwiftUI

// Shared ViewModel to manage the sheet presentation state
class SharedViewModel: ObservableObject {
    @Published var isSettingsPresented = false
}

struct ContentView: View {
    @State private var isSheetPresented = true
    @StateObject private var viewModel = SharedViewModel()
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                viewModel.isSettingsPresented = true
            }) {
                Text("Show Settings in First Tab")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $isSheetPresented, onDismiss: {
            // Re-present the sheet immediately if it gets dismissed
            isSheetPresented = true
        }) {
            SheetView()
                .environmentObject(viewModel)
                .presentationDetents([.height(150), .medium, .large])
                .presentationCornerRadius(25)
                .presentationBackground(.regularMaterial)
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .interactiveDismissDisabled()
        }
    }
}

struct SheetView: View {
    @EnvironmentObject var viewModel: SharedViewModel
    
    var body: some View {
        TabView {
            FirstTabView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First Tab")
                }
            SecondTabView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second Tab")
                }
        }
    }
}

struct FirstTabView: View {
    @EnvironmentObject var viewModel: SharedViewModel
    
    var body: some View {
        VStack {
            Text("This is the first tab!")
                .font(.largeTitle)
                .padding()
        }
        .sheet(isPresented: $viewModel.isSettingsPresented) {
            SettingsContentView()
                .presentationCornerRadius(25)
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
        }
        .padding()
    }
}

struct SecondTabView: View {
    var body: some View {
        VStack {
            Text("This is the second tab!")
                .font(.largeTitle)
                .padding()
            // Additional content for the second tab
        }
        .padding()
    }
}



#Preview {
    ContentView()
}
