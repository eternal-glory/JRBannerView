//
//  JRBannerCollectionViewFlowLayout.swift
//  JRBannerView
//
//  Created by wenhao lei on 2021/12/2.
//

import UIKit

class JRBannerCollectionViewFlowLayout<T: Codable>: UICollectionViewFlowLayout {
    
    private var config: JRBannerConfig<T>
    
    init(config: JRBannerConfig<T>) {
        self.config = config
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        itemSize = config.itemSize
        minimumInteritemSpacing = 0
        minimumLineSpacing = config.lineSpacing
        sectionInset = config.sectionInset
        guard let collectionView = collectionView else { return }
        if collectionView.isPagingEnabled {
            scrollDirection = config.isVertical ? .vertical: .horizontal
        } else {
            scrollDirection = .horizontal
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cardScaleType(by: rect)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        if !collectionView.isPagingEnabled {
            var rect = CGRect.zero
            rect.origin.y = 0
            rect.origin.x = proposedContentOffset.x
            rect.size = collectionView.frame.size
            if let array = super.layoutAttributesForElements(in: rect) {
                let centerX = proposedContentOffset.x + collectionView.frame.size.width * config.contentOffsetX
                var minDelta = CGFloat(MAXFLOAT)
                for attributes in array {
                    if abs(minDelta) > abs(attributes.center.x - centerX) {
                        minDelta = attributes.center.x - centerX
                    }
                }
                var new = proposedContentOffset
                new.x += minDelta
                config.currentIndex = Int(round(abs(new.x)) / (config.itemSize.width + config.lineSpacing))
                return new
            }
        }
        return proposedContentOffset
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return super.shouldInvalidateLayout(forBoundsChange: newBounds)
        }
        return !collectionView.isPagingEnabled
    }
}

extension JRBannerCollectionViewFlowLayout {
    
    func cardScaleType(by rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = collectionView else { return [] }
        
        guard let atts = super.layoutAttributesForElements(in: rect) else { return [] }
        let array = getCopy(of: atts)
        
        if !config.isScale {
            return array
        }
        
        var visibleRect = CGRect.zero
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        for attributes in array {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = abs(distance/config.activeDistance)
            let zoom = 1 - config.scaleFactor * normalizedDistance
            attributes.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0)
            attributes.frame = .init(x: attributes.frame.origin.x, y: attributes.frame.origin.y + zoom, width: attributes.size.width, height: attributes.size.height)
            if config.orSoCellAlpha < 1 {
                let collectionCenter = collectionView.frame.size.width / 2
                let offsetX = collectionView.contentOffset.x
                let normalizedCenter = attributes.center.x - offsetX
                let maxDistance = itemSize.width + minimumLineSpacing
                let distance1 = min(abs(collectionCenter - normalizedCenter), maxDistance)
                let ratio = (maxDistance - distance1) / maxDistance
                let alpha = ratio * (1 - config.orSoCellAlpha) + config.orSoCellAlpha
                attributes.alpha = alpha
            }
            
            var center = CGPoint(x: attributes.center.x, y: collectionView.center.y)
            if config.orSoCellPosition == .top {
                center = CGPoint(x: attributes.center.x, y: attributes.center.y - attributes.size.height * (1 - zoom))
            } else if config.orSoCellPosition == .bottom {
                center = CGPoint(x: attributes.center.x, y: attributes.center.y + attributes.size.height * (1 - zoom))
            }
            attributes.center = center
        }
        return array
    }
    
    func getCopy(of attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        var copys: [UICollectionViewLayoutAttributes] = []
        for attribute in attributes {
            copys.append(attribute)
        }
        return copys
    }
}
