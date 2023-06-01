//
//  ContentView.swift
//  TestPicker
//
//  Created by Ekaterina Grishina on 30/05/23.
//

import SwiftUI
import SnapPickerView

struct ContentView: View {
    @State private var selectedSPF: String = "0"
    @State private var index: Int = 0
    var spfFactors = ["0", "15", "20", "30", "50"]
    @State var offset: CGFloat = 0

        var body: some View {

            VStack {
                Text("\(offset)")

                // This one from Kavsoft
                HorizontalPicker(pickerCount: spfFactors.count, offset: $offset) {
                    HStack(spacing: 8) {
                        ForEach(spfFactors, id: \.self) { element in
                            HStack {
                                Text(element)
                                    .font(Font.custom(".SFProText-Semibold", size: 30))
                                if element != spfFactors.last {
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray4))
                                        .cornerRadius(4)
                                        .frame(width: 2, height: 12)
                                        .padding(.horizontal)
                                }
                            }

                        }
                    }
                }
                .frame(height: 55)

                // This one I started almost from scratch
                VStack(alignment: .center) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 8) {
                            ForEach(spfFactors, id: \.self) { element in
                                GeometryReader { proxy in
                                    let scale = getScale(proxy: proxy)

                                    Text(element)
                                        .font(.system(size: 20, weight: .semibold))
                                        .frame(width: 50, height: 50)
                                        .scaleEffect(.init(width: scale, height: scale))
                                        .animation(.easeOut(duration: 0.3))

                                        .padding(.vertical)

                                }
                            }
                        }
                        .frame(width: 250) // this defines the width of content inside scroll view
                        .offset(x: (150 - 30) / 2 ) // needs to put first element to center
                        .padding(.trailing, 150 - 30) // needs to be able to scroll last element to the center
                    }
                    .frame(width: 150) // this defines the viewport - so we actually can see only width of 150 even though it is much longer(width 250 of scroll view content)
                    .overlay(content: {
                        VStack {
                            HStack {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 2, height: 12)
                                    .offset(x: -7, y: 36)
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 2, height: 12)
                                    .offset(x: 28, y: 36)
                            }
                            Spacer()
                        }
                    })



                }
            }
        }

    // This function just get position of each element inside scroll view and check if it is in the center of the screen and returns the scale for this element
    func getScale(proxy: GeometryProxy) -> CGFloat {

        let viewFrame = proxy.frame(in: CoordinateSpace.global)
        let midView = UIScreen.main.bounds.width/2

        let rect = CGRect(x: Int(midView) - 30, y: Int(viewFrame.origin.y), width: 60, height: 60)

        let intersection = rect.intersection(viewFrame)

        if intersection.width >= 40 && intersection.height >= 40 {
            return 1.5
        }
        return 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
