//
//  JRBannerConfig.swift
//  JRBannerView
//
//  Created by wenhao lei on 2021/12/2.
//

import UIKit

enum JRBanneRaroundCellPosition {
    case top
    case center
    case bottom
}

class JRBannerConfig: NSObject {
    
    /// bannerView位置大小
    private(set) var frame: CGRect = .zero
    
    /// 数据源
    private(set) var dataSource: [Any] = []
    
    /// 是否允许手势滑动
    private(set) var isScrollEnabled: Bool = true
    
    /// 是否垂直滚动
    private(set) var isVertical: Bool = false
    
    /// 滚动间隔时间
    private(set) var timeInterval: TimeInterval = 3.0
    
    /// 是否无限重复滚动
    private(set) var isRepeat: Bool = false
    
    /// 是否自动滚动
    private(set) var isAuto: Bool = false
    
    /// 是否隐藏PageControl
    private(set) var hiddenPageControl: Bool = false
    
    /// 默认展示第几个位置
    private(set) var selectIndex: Int = 0
    
    /// 滑动时候偏移距离 以倍数计算 default 0.5 正中间 横向
    private(set) var contentOffsetX: CGFloat = 0.5
    
    /// 开启缩放 default false
    private(set) var isScale: Bool = false
    
    /// 垂直缩放 数值越大缩放越小 default 400
    private(set) var activeDistance: CGFloat = 400
    
    /// 缩放系数 数值越大缩放越大 default 0.5
    private(set) var scaleFactor: CGFloat = 0.5
    
    /// cell的标识符
    private(set) var identifier: String = ""
    
    /// cell大小
    private(set) var itemSize: CGSize = .zero
    
    /// item之间的间隙 default 0
    private(set) var lineSpacing: CGFloat = 0.0
    
    private(set) var sectionInset: UIEdgeInsets = .zero
    
    /// 左右两边item的中心点位置
    private(set) var orSoCellPosition: JRBanneRaroundCellPosition = .center
    
    /// 左右两边item透明度
    private(set) var orSoCellAlpha: CGFloat = 1
    
    private(set) var collectionViewCell: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ model: Any)-> UICollectionViewCell)?
    
    private(set) var didSelectItem: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ model: Any)->())?
    
    /// 当前位置
    var currentIndex: Int = 0
}

extension JRBannerConfig {
    
    /// 配置位置大小
    /// - Parameter frame: 位置大小
    /// - Returns: Self
    func setFrame(by frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    /// 配置数据源
    /// - Parameter dataSource: 数组
    /// - Returns: Self
    func setDataSource(by dataSource: [Any]) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    /// 是否垂直
    /// - Parameter isVertical: bool类型
    /// - Returns: Self
    func setVertical(by isVertical: Bool) -> Self {
        self.isVertical = isVertical
        return self
    }
    
    /// 是否允许手势滑动
    /// - Parameter isScrollEnabled: bool类型
    /// - Returns: Self
    func setIsScrollEnabled(by isScrollEnabled: Bool) -> Self {
        self.isScrollEnabled = isScrollEnabled
        return self
    }
    
    /// 自动滚动间隔时间
    /// - Parameter timeInterval: 间隔时间
    /// - Returns: Self
    func setAutoScroll(by timeInterval: TimeInterval) -> Self {
        self.timeInterval = timeInterval
        return self
    }
    
    /// 开启无限滚动
    /// - Parameter isRepeat: default NO
    /// - Returns: Self
    func setRepeatScroll(by isRepeat: Bool) -> Self {
        self.isRepeat = isRepeat
        return self
    }
    
    /// 开启自动滚动
    /// - Parameter isAuto: bool类型 default NO
    /// - Returns: Self
    func setAutoScroll(by isAuto: Bool) -> Self {
        self.isAuto = isAuto
        return self
    }
    
    /// 当前选中item索引
    /// - Parameter currentIndex: 索引值 default 0
    /// - Returns: Self
    func setSelectIndex(by selectIndex: Int) -> Self {
        self.selectIndex = selectIndex
        return self
    }
    
    /// 隐藏pageControl
    /// - Parameter hidden: bool类型 default false
    /// - Returns: Self
    func setHiddenPageControl(by hidden: Bool) -> Self {
        self.hiddenPageControl = hidden
        return self
    }
    
    /// cell标识符
    /// - Parameter identifier: 标识字符串
    /// - Returns: Self
    func setCellIdentifier(by identifier: String) -> Self {
        self.identifier = identifier
        return self
    }
    
    /// cellItem大小
    /// - Parameter itemSize: 尺寸
    /// - Returns: Self
    func setItemSize(by itemSize: CGSize) -> Self {
        self.itemSize = itemSize
        return self
    }
    
    func setSectionInset(by sectionInset: UIEdgeInsets) -> Self {
        self.sectionInset = sectionInset
        return self
    }
    
    /// item之间的间隙
    /// - Parameter lineSpacing: float类型
    /// - Returns: Self
    func setLineSpacing(by lineSpacing: CGFloat) -> Self {
        self.lineSpacing = lineSpacing
        return self
    }
    
    /// 是否开启缩放
    /// - Parameter isScale: bool类型
    /// - Returns: Self
    func setIsScale(by isScale: Bool) -> Self {
        self.isScale = isScale
        return self
    }
    
    /// 缩放系数
    /// - Parameter scaleFactor: float类型
    /// - Returns: Self
    func setScaleFactor(by scaleFactor: CGFloat) -> Self {
        self.scaleFactor = scaleFactor
        return self
    }
    
    /// 垂直缩放
    /// - Parameter activeDistance: float类型
    /// - Returns: Self
    func setActiveDistance(by activeDistance: CGFloat) -> Self {
        self.activeDistance = activeDistance
        return self
    }
    
    /// 滑动时候偏移距离
    /// - Parameter contentOffsetX: default 0.5
    /// - Returns: Self
    func setContentOffsetX(by contentOffsetX: CGFloat) -> Self {
        self.contentOffsetX = contentOffsetX
        return self
    }
    
    /// 左右相邻item的中心点位置样式
    /// - Parameter cellPosition: 样式
    /// - Returns: Self
    func setOrSoCellPosition(by orSoCellPosition: JRBanneRaroundCellPosition) -> Self {
        self.orSoCellPosition = orSoCellPosition
        return self
    }
    
    /// 左右相邻item的透明度
    /// - Parameter raroundAlpha: float类型 0~1
    /// - Returns: Self
    func setOrSoAlpha(by orSoCellAlpha: CGFloat) -> Self {
        self.orSoCellAlpha = orSoCellAlpha
        return self
    }
    
    /// 初始化collectionCell
    /// - Parameter collectionViewCell: 需要返回collectionViewCell的闭包
    /// - Returns: Self
    func setCollectionViewCell(by collectionViewCell: @escaping ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ model: Any)-> UICollectionViewCell)) -> Self {
        self.collectionViewCell = collectionViewCell
        return self
    }
    
    /// 点击collectionCell
    /// - Parameter didSelectItem: collectionCell的闭包
    /// - Returns: Self
    func setDidSelectedItem(by didSelectItem: @escaping ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ model: Any)->Void)) -> Self {
        self.didSelectItem = didSelectItem
        return self
    }
}
