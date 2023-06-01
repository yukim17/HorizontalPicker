//
//  HorizontalPicker.swift
//  TestPicker
//
//  Created by Ekaterina Grishina on 30/05/23.
//

import Foundation
import SwiftUI

struct HorizontalPicker<Content: View>: UIViewRepresentable {

    var content: Content
    @Binding var offset: CGFloat
    var pickerCount: Int

    init(pickerCount: Int, offset: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._offset = offset
        self.pickerCount = pickerCount
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()

        guard let contentView = UIHostingController(rootView: content).view else { return scrollView }
        let width  = CGFloat(pickerCount * 61) + (UIScreen.main.bounds.width - 61)
        contentView.frame = CGRect(x: 0, y: 0, width: width, height: 50)

        scrollView.contentSize = contentView.frame.size
        scrollView.addSubview(contentView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator

        return scrollView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return HorizontalPicker.Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {

        var parent: HorizontalPicker

        init(parent: HorizontalPicker) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            let value = (offset / 20).rounded(.toNearestOrAwayFromZero)
            scrollView.setContentOffset(CGPoint(x: value * 20, y: 0), animated: false)
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            guard !decelerate else { return }
            let offset = scrollView.contentOffset.x
            let value = (offset / 20).rounded(.toNearestOrAwayFromZero)
            scrollView.setContentOffset(CGPoint(x: value * 20, y: 0), animated: false)
        }
    }
}
