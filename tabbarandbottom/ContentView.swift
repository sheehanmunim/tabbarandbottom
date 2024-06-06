import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var overlayHeight: CGFloat = 300 // Initial height
    @State private var isDragging = false
    @State private var dragGestureVerticalDirection: VerticalDirection? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .bottom) {
                MainView()
                
                VStack(spacing: 0) {
                    OverlayView(height: $overlayHeight, selectedTab: selectedTab)
                        .frame(maxWidth: .infinity)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    let gestureVerticalDirection: VerticalDirection = value.translation.height < 0 ? .up : .down
                                    if dragGestureVerticalDirection == nil {
                                        dragGestureVerticalDirection = gestureVerticalDirection
                                    }
                                    if gestureVerticalDirection != dragGestureVerticalDirection {
                                        dragGestureVerticalDirection = nil
                                    }
                                    
                                    var proposed: CGFloat
                                    if gestureVerticalDirection == .up {
                                        proposed = max(150, min(UIScreen.main.bounds.height - value.location.y, UIScreen.main.bounds.height - 200))
                                    } else {
                                        proposed = max(150, min(overlayHeight - value.translation.height, UIScreen.main.bounds.height - 200))
                                    }
                                    
                                    withAnimation {
                                        overlayHeight = proposed
                                    }
                                }
                                .onEnded { value in
                                    isDragging = false
                                    dragGestureVerticalDirection = nil
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        overlayHeight = snapHeight(overlayHeight)
                                    }
                                }
                        )
                    
                    TabView(selection: $selectedTab) {
                        Color.clear
                            .tabItem {
                                Label("Tab 1", systemImage: "1.square.fill")
                            }
                            .tag(0)
                        
                        Color.clear
                            .tabItem {
                                Label("Tab 2", systemImage: "2.square.fill")
                            }
                            .tag(1)
                    }
                    .frame(height: 50)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    // Function to snap the height to the nearest snapping point
    private func snapHeight(_ proposedHeight: CGFloat) -> CGFloat {
        if proposedHeight >= UIScreen.main.bounds.height - 200 {
            return UIScreen.main.bounds.height - 200
        } else if proposedHeight >= 300 {
            return 300
        } else if proposedHeight >= 150 {
            return 150
        } else {
            return proposedHeight
        }
    }
    
    enum VerticalDirection {
        case up
        case down
    }
}



struct MainView: View {
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
            Text("Main View")
                .font(.largeTitle)
                .padding()
            Spacer()
            
            Button(action: {
                isSheetPresented = true
            }) {
                Text("Button in Main View")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $isSheetPresented) {
                // The content to be presented in the sheet
                SheetContentView()
            }
            Spacer() // Add Spacer to push the button to the bottom
        }
    }
}


struct OverlayView: View {
    @Binding var height: CGFloat
    var selectedTab: Int
    let handleHeight: CGFloat = 5
    let handleWidth: CGFloat = 50
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                if selectedTab == 0 {
                    Text("Overlay View for Tab 1")
                        .padding()
                } else if selectedTab == 1 {
                    Text("Overlay View for Tab 2")
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .fill(Color.blue.opacity(0.8))
                    .shadow(radius: 10)
            )
            .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 10))
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: handleWidth, height: handleHeight)
                .foregroundColor(.white)
                .opacity(0.5)
                .padding(.top, 10)
        }
    }
}



struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
