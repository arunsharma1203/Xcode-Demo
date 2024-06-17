//
//  LessonShapes.swift
//  Xcode Demo
//
//  Created by Arun Sharma on 15/06/24.
//

import SwiftUI

struct LessonShapes: View {
    @State private var sliderValue: Double = 0.05
  var body: some View {
    // This is where you define the content of your view
     
 var popo = Rectangle()
          .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
          .offset()
          .foregroundStyle(.blue)
      HStack{
          popo
          popo
      }
      HStack{
          popo
          popo
      }
      Text("Windows XP")
          .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
          .foregroundStyle(.primary)
      Text("\(sliderValue, specifier: "%.2f")")
      Slider(value: $sliderValue, in: 0...100)
                     .padding(.horizontal, 40)
                     .background(
                         RoundedRectangle(cornerRadius: 5)
                             .stroke(Color.blue, lineWidth: 2)
                     )
                     .cornerRadius(5).padding(.horizontal , 30)
      
  }

}

#Preview {
    LessonShapes()
}
