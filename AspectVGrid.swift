//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Nipuna Weerapperuma on 7/20/23.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item:Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) { // View builder flag (to support if/else logic) and escaping to be used outside init
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack { // Make it GeometryReader flexible
                let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio) // Way to calculate width
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) {item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0) // Something flexible to make parent flexible
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
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
        return floor(size.width/CGFloat(columnCount))
    }
}

//struct AspectVGrid_Previews: PreviewProvider { // Don't need preview for this
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
