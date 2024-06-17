import SwiftUI

struct CustomSliderView: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    var numberOfLines: Int = 100
    var lineHeight: CGFloat = 30
    var mediumLineHeight: CGFloat = 20
    var smallLineHeight: CGFloat = 10
    var lineWidth: CGFloat = 3
    
    
    @State private var lastDragValue: Double = 0.0

    // Haptic feedback generator
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack {
            // Display the current value
            Text(String(format: "%.2f", value))
                .font(.title)
                .foregroundColor(.white)
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let spacing = width / CGFloat(numberOfLines)
                
                
                ZStack {
                    HStack(spacing: spacing) {
                        ForEach(0..<numberOfLines, id: \.self) { index in
                            let lineHeight = index % 5 == 0 ? self.lineHeight : (index % 5 == 2 ? self.mediumLineHeight : self.smallLineHeight)
                            let lineColor: Color = .white
                            
                            Rectangle()
                                .fill(lineColor)
                                .frame(width: lineWidth, height: lineHeight)
                        }
                    }
                    .offset(x: self.offsetForValue(value, width: width, spacing: spacing))
                    
                    // The yellow line indicating the current value, always centered
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 6, height: lineHeight)
                        .offset(x: -147)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            let translation = gesture.translation.width
                            let sliderRange = range.upperBound - range.lowerBound
                            let deltaValue = Double(translation / width) * sliderRange
                            value = (lastDragValue + deltaValue).clamped(to: range)
                            feedbackGenerator.impactOccurred() // Trigger haptic feedback
                        }
                        .onEnded { _ in
                            lastDragValue = value
                        }
                )
            }
            .frame(height: lineHeight)
        }
        .onAppear {
            feedbackGenerator.prepare() // Prepare the haptic feedback generator
            lastDragValue = value
        }
    }
    
    private func offsetForValue(_ value: Double, width: CGFloat, spacing: CGFloat) -> CGFloat {
        let sliderRange = range.upperBound - range.lowerBound
        let relativeValue = (value - range.lowerBound) / sliderRange
        return -CGFloat(relativeValue) * width + width / 2
    }
}

extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}
