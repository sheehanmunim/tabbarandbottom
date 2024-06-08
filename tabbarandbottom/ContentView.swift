import SwiftUI

struct ContentView: View {
    @State private var isShowingOverlay = true
    @State private var overlayHeight: CGFloat = 200
    private let tabBarHeight: CGFloat = 100
    private let minHeight: CGFloat = 100
    private let maxHeight: CGFloat = 655
    private let snapPositions: [CGFloat] = [200, 400, 655] // Define snap positions

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if isShowingOverlay {
                    // Overlay
                    Rectangle()
                        .foregroundColor(.red)
                        .frame(height: overlayHeight)
                        .padding(.bottom, tabBarHeight)
                        .transition(.move(edge: .bottom))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newHeight = overlayHeight - value.translation.height
                                    overlayHeight = min(max(newHeight, minHeight), maxHeight)
                                }
                                .onEnded { value in
                                    withAnimation(.spring()) {
                                        overlayHeight = nearestSnapPosition(to: overlayHeight)
                                    }
                                }
                        )
                }

                // TabBar
                TabBar()
                    .frame(height: tabBarHeight)
                    .background(Color.blue)
            }
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }

    // Method to find the nearest snap position
    private func nearestSnapPosition(to height: CGFloat) -> CGFloat {
        let nearestPosition = snapPositions.min(by: { abs($0 - height) < abs($1 - height) }) ?? height
        return nearestPosition
    }
}

struct TabBar: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Tab 1")
            Spacer()
            Text("Tab 2")
            Spacer()
            Text("Tab 3")
            Spacer()
        }
        .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
