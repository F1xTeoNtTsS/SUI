//
//  AspectVGrid.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 10.10.2022.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minWidth: CGFloat = self.widthThatFits(itemCount: self.items.count,
                                                       in: geometry.size,
                                                       itemAspectRatio: self.aspectRatio)
            LazyVGrid(columns: [self.adaptiveGridItem(minWidth: minWidth)], spacing: 0) {
                ForEach(self.items) { item in
                    content(item).aspectRatio(self.aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    private func adaptiveGridItem(minWidth: CGFloat) -> GridItem {
        GridItem(.adaptive(minimum: minWidth), spacing: .zero)
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}
