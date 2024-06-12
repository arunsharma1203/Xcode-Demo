import SwiftUI

struct ContentView: View {
    @State var x = 0.0
    @State private var isEditing = false

    var body: some View {
     Text("Hello World!")
        .padding()
        Image(systemName: "globe")
            .foregroundColor(Color(hue: 0.611, saturation: 0.772, brightness: 0.841))
    }
}

#Preview {
    ContentView()
}
