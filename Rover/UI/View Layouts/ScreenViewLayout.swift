//
//  ScreenViewLayout.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class ScreenViewLayout: UICollectionViewLayout {
    typealias AttributesMap = [IndexPath: ScreenViewLayoutAttributes]
    
    var screenViewModel: ScreenViewModel
    
    private var height: CGFloat = 0
    private var blockAttributesMap = AttributesMap()
    private var rowAttributesMap = AttributesMap()
    private var needsPreparation = true
    
    init(screenViewModel: ScreenViewModel) {
        self.screenViewModel = screenViewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    override func prepare() {
        guard needsPreparation else {
            return
        }
        
        var height: CGFloat = 0
        
        var rowAttributesMap = AttributesMap()
        var blockAttributesMap = AttributesMap()
        
        for (i, rowViewModel) in screenViewModel.rowViewModels.enumerated() {
            let rowIndex = IndexPath(row: 0, section: i)
            let rowOrigin = CGPoint(x: 0, y: height)
            let rowBounds = CGRect(origin: rowOrigin, size: collectionView!.frame.size)
            let rowFrame = rowViewModel.frame(inBounds: rowBounds)
            
            let rowAttributes = ScreenViewLayoutAttributes(forSupplementaryViewOfKind: RowView.defaultReuseIdentifier, with: rowIndex)
            rowAttributes.frame = rowFrame
            rowAttributes.referenceFrame = rowFrame
            rowAttributes.zIndex = 0
            
            rowAttributesMap[rowIndex] = rowAttributes
            
            var stackedHeight: CGFloat = 0
            
            for (j, blockViewModel) in rowViewModel.blockViewModels.enumerated() {
                let blockIndex = IndexPath(row: j, section: i)
                var blockOrigin = rowAttributes.frame.origin
                
                if blockViewModel.isStacked {
                    blockOrigin.y += stackedHeight
                }
                
                let blockBounds = CGRect(origin: blockOrigin, size: rowAttributes.frame.size)
                let blockFrame = blockViewModel.frame(inBounds: blockBounds)
                
                let blockAttributes = ScreenViewLayoutAttributes(forCellWith: blockIndex)
                blockAttributes.frame = blockFrame
                blockAttributes.referenceFrame = blockFrame
                blockAttributes.verticalAlignment = blockViewModel.verticalAlignment
                blockAttributes.zIndex = rowViewModel.blockViewModels.count - j
                
                blockAttributesMap[blockIndex] = blockAttributes
                
                stackedHeight += blockViewModel.stackedHeight(inBounds: blockBounds)
            }
            
            height += rowAttributes.frame.height
        }
        
        self.height = height
        self.rowAttributesMap = rowAttributesMap
        self.blockAttributesMap = blockAttributesMap
        
        needsPreparation = false
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let rowAttributes = attributes(from: rowAttributesMap, in: rect)
        let blockAttributes = attributes(from: blockAttributesMap, in: rect)
        
        guard screenViewModel.isStretchyHeaderEnabled else {
            return rowAttributes + blockAttributes
        }
        
        let offset = collectionView!.contentOffset.y + collectionView!.contentInset.top
        guard offset < 0 else {
            return rowAttributes + blockAttributes
        }
        
        let deltaY = fabs(offset)
        
        if let headerAttributes = rowAttributes.first(where: { $0.indexPath.section == 0 }) {
            var frame = headerAttributes.referenceFrame
            frame.size.height = max(0, frame.size.height + deltaY)
            frame.origin.y = frame.origin.y - deltaY
            headerAttributes.frame = frame
        }
        
        blockAttributes.forEach { attributes in
            guard attributes.indexPath.section == 0 else {
                return
            }
            
            var frame = attributes.referenceFrame
            
            switch attributes.verticalAlignment {
            case .bottom:
                break
            case .center:
                frame.origin.y -= deltaY / 2
            case .fill:
                frame.origin.y -= deltaY
                frame.size.height += deltaY
            case .top:
                frame.origin.y -= deltaY
            }
            
            attributes.frame = frame
        }
        
        return rowAttributes + blockAttributes
    }
    
    func attributes(from attributesMap: AttributesMap, in rect: CGRect) -> [ScreenViewLayoutAttributes] {
        return attributesMap.filter({ $0.1.frame.intersects(rect) }).map({ $0.1 })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return blockAttributesMap[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return rowAttributesMap[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard screenViewModel.isStretchyHeaderEnabled else {
            return false
        }
        
        return newBounds.origin.y < 0 - collectionView!.contentInset.top
    }
}
