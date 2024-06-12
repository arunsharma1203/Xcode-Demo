import SwiftUI

struct ContentView: View {
    @State var x = 0.0
    @State private var isEditing = false

    var body: some View {
        VStack {
            Image("kota")
                .resizable()
                .cornerRadius(30.0)
                .padding(10)
                .aspectRatio(contentMode: .fit)
                .brightness(x / 10.0) // Adjust brightness based on the slider value
                .imageScale(.small)
                .foregroundStyle(.clear)

            Slider(
                value: $x,
                in: 0...10,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            .padding(30)

            Text("Adjust Image Brightness")

            Text("\(x)")
                .padding(.top, 8.0)
        }

        HStack {
            Button(action: { x = max(0, x - 1) }, label: {
                Text("-")
            })
            .padding(.trailing, 30.0)

            Button(action: { x = min(10, x + 1) }, label: {
                Text("+")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
