import SwiftUI
import PhotosUI

struct LessonImageEditor: View {
    @State var brightness: Double = 0.0 // Default to 0.0 for centered start
    @State var saturation: Double = 1.0
    @State var hue: Double = 0.0
    @State var contrast: Double = 1.0
    @State var grayscale: Double = 0.0
    @State var blur: Double = 0.0
    @State private var selectedImage: UIImage?
    @State private var image: Image?
    @State private var isImagePickerPresented = false
    @State private var activeSlider: SliderType? = nil
    @State private var showMenu = false

    enum SliderType {
        case brightness, saturation, hue, contrast, grayscale, blur
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Image Adjustments")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    if let image = image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom, 200.0)
                            .brightness(brightness) // Directly apply brightness
                            .saturation(saturation)
                            .hueRotation(Angle(degrees: hue * 360))
                            .contrast(contrast)
                            .grayscale(grayscale)
                            .blur(radius: blur)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }

                    Spacer()

                    HStack {
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            Text("Select Image")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage, image: $image)
                        }
                        
                        if selectedImage != nil {
                            Button(action: saveImage) {
                                Text("Save Image")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding()
                }

                // Sliding menu
                VStack {
                    Spacer()

                    if showMenu {
                        VStack {
                            // Horizontal ScrollView for buttons
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    SliderButton(title: "Brightness", isActive: activeSlider == .brightness) {
                                        withAnimation {
                                            activeSlider = .brightness
                                        }
                                    }
                                    SliderButton(title: "Saturation", isActive: activeSlider == .saturation) {
                                        withAnimation {
                                            activeSlider = .saturation
                                        }
                                    }
                                    SliderButton(title: "Hue", isActive: activeSlider == .hue) {
                                        withAnimation {
                                            activeSlider = .hue
                                        }
                                    }
                                    SliderButton(title: "Contrast", isActive: activeSlider == .contrast) {
                                        withAnimation {
                                            activeSlider = .contrast
                                        }
                                    }
                                    SliderButton(title: "Grayscale", isActive: activeSlider == .grayscale) {
                                        withAnimation {
                                            activeSlider = .grayscale
                                        }
                                    }
                                    SliderButton(title: "Blur", isActive: activeSlider == .blur) {
                                        withAnimation {
                                            activeSlider = .blur
                                        }
                                    }
                                }
                                .padding()
                            }

                            // Conditional Slider
                            if let activeSlider = activeSlider {
                                switch activeSlider {
                                case .brightness:
                                    CustomSliderView(value: $brightness, range: -0.5...0.5)
                                case .saturation:
                                    CustomSliderView(value: $saturation, range: 0...2)
                                case .hue:
                                    CustomSliderView(value: $hue, range: 0...1)
                                case .contrast:
                                    CustomSliderView(value: $contrast, range: 0.5...1.5)
                                case .grayscale:
                                    CustomSliderView(value: $grayscale, range: 0...1)
                                case .blur:
                                    CustomSliderView(value: $blur, range: 0...10)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground).opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .transition(.move(edge: .bottom))
                    }

                    Button(action: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }) {
                        Image(systemName: showMenu ? "chevron.down" : "chevron.up")
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 80)
                }
            }
            .navigationBarHidden(true)
        }
    }

    // Function to save the edited image
    func saveImage() {
        guard let inputImage = selectedImage else { return }

        // Apply brightness filter
        let context = CIContext()
        let ciImage = CIImage(image: inputImage)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(brightness, forKey: kCIInputBrightnessKey) // Directly apply brightness
        filter?.setValue(saturation, forKey: kCIInputSaturationKey)
        filter?.setValue(contrast, forKey: kCIInputContrastKey)

        // Ensure the output image is created successfully
        if let outputImage = filter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        }
    }
}

struct SliderButton: View {
    var title: String
    var isActive: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(isActive ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var image: Image?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                        if let selectedImage = self.parent.selectedImage {
                            self.parent.image = Image(uiImage: selectedImage)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
