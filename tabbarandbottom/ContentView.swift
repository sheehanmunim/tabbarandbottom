import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var showSheet = true
    @State private var settingsSheet = false
    
    var body: some View {
        TabView(selection: $selectedTab){
            HomeView(showSheet: $showSheet, settingsSheet: $settingsSheet, selectedTab: selectedTab)
                .tabItem{
                Label("Home", systemImage: "house")
            }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.background, for: .tabBar)
                .tag(0)
            
            HomeView(showSheet: $showSheet, settingsSheet: $settingsSheet, selectedTab: selectedTab)
                .tabItem{
                Label("Tab 2", systemImage: "2.square.fill")
            }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.background, for: .tabBar)
                .tag(1)
            
        }
        .sheet(isPresented: $settingsSheet)
        {
            SettingsView()
                .presentationCornerRadius(25)
        }
    }
    
}

struct HomeView: View {
    @Binding var showSheet: Bool
    @Binding var settingsSheet: Bool
    
    var selectedTab: Int
    
    var body: some View {
        VStack{
            Button("Settings"){
                settingsSheet.toggle()
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom){
            if showSheet {
                SheetContent(selectedTab: selectedTab)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: showSheet)
        
        
        
    }
}

struct SheetContent: View {
    let minHeight: CGFloat = 100
    let snapHeight: CGFloat = 150
    let midHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    @State private var extraHeight = CGFloat.zero
    @State private var dragHeight = CGFloat.zero
    
    var selectedTab: Int
    
    init(selectedTab: Int, extraHeight: CGFloat = 0){
        self.selectedTab = selectedTab
        _extraHeight = State(initialValue: snapHeight - minHeight)
    }
    
    var body: some View{
        VStack{
            if selectedTab == 0 {
                Text("First Tab")
            }
            else if selectedTab == 1 {
                Text("Second Tab")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: minHeight + extraHeight)
        .offset(y: -dragHeight / 2)
        .background{
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20, topTrailing: 20))
                .padding(.bottom, -300)
                .foregroundStyle(.yellow)
                .offset(y: -dragHeight)
        }
        .overlay(alignment: .top){
            Capsule()
                .frame(width: 36, height: 5)
                .foregroundStyle(.secondary)
                .padding(5)
                .offset(y: -dragHeight)
        }
        .animation(.easeInOut, value: extraHeight)
        .animation(.easeInOut, value: dragHeight)
        .gesture(
            DragGesture()
                .onChanged { val in
                    let dy = -val.translation.height
                    let minDragHeight = minHeight - (minHeight + extraHeight)
                    let maxDragHeight = maxHeight - (minHeight + extraHeight)
                    dragHeight = min(max(dy, minDragHeight), maxDragHeight)
                }
                .onEnded { _ in
                    let snapPoints: [CGFloat] = [snapHeight, midHeight, maxHeight]
                    let currentHeight = minHeight + extraHeight + dragHeight
                    let closestSnapPoint = snapPoints.min(by: {abs($0 - currentHeight) < abs($1 - currentHeight) }) ?? snapHeight
                    withAnimation(.easeInOut){
                        extraHeight = closestSnapPoint - minHeight
                        dragHeight = 0
                    }
                }
        )
    }
}

#Preview{
    ContentView()
}
