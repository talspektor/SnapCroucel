//
//  SnapCaroucel.swift
//  SnapCroucel
//
//  Created by Tal talspektor on 01/04/2022.
//

import SwiftUI

// Tofor Accepting List....
struct SnapCaroucel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]

    // Properties...
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int

    init(spacing: CGFloat = 15, trailinSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailinSpace
        self._index = index
        self.content = content
    }

    // Offset...
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0

    var body: some View {

        GeometryReader { proxy in

            // Setting correct width for snap Carousel...

            // One Sided Snap Caroucel...

            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing

            HStack(spacing: spacing) {

                ForEach(list) { item in

                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            // Spacing will be horizontal padding...
            .padding(.horizontal, spacing)
            // setting only after 0th index...
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(

                DragGesture()
                    .updating($offset, body: { value, out, _ in

                        out = value.translation.width
                    })
                    .onEnded({ value in

                        // Updating Current Index...
                        let offsetX = value.translation.width

                        // were going to convert the translation into progress (0 - 1)
                        // and round the value...
                        // based on the progress increasing or decreasing the currentIndex...

                        let progress = -offsetX / width

                        let roundIndex = progress.rounded()

                        // setting max...
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)

                        // jupdateing indax...
                        currentIndex = index
                    })
                    .onChanged({ value in
                        // updating only index...

                        // Updating Current Index...
                        let offsetX = value.translation.width

                        // were going to convert the translation into progress (0 - 1)
                        // and round the value...
                        // based on the progress increasing or decreasing the currentIndex...

                        let progress = -offsetX / width

                        let roundIndex = progress.rounded()

                        // setting max...
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)

                    })
            )
        }
        // Animationg when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }

}

struct SnapCaroucel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
