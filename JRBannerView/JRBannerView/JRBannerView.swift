//
//  JRBannerView.swift
//  JRBannerView
//
//  Created by wenhao lei on 2021/12/2.
//

import UIKit

let kBannerCount = 500

class JRBannerView: UIView {
    
    private var dataSource: [Any] = []
    
    private var beganDragging: Bool = false
    
    private var config: JRBannerConfig
    
    private var timer: Timer?
    
    init(config: JRBannerConfig = .init()) {
        self.config = config
        super.init(frame: config.frame)
        
       setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let _imaegView = UIImageView(frame: bounds)
        return _imaegView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = JRBannerCollectionViewFlowLayout(config: config)
        let _collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        _collectionView.showsVerticalScrollIndicator = false
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.backgroundColor = .clear
        _collectionView.delegate = self
        _collectionView.dataSource = self
        guard var spaceName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            return _collectionView
        }
        spaceName = spaceName.replacingOccurrences(of: "-", with: "_")
        guard let cellClass = NSClassFromString(spaceName + "." + config.identifier) as? UICollectionViewCell.Type else {
            return _collectionView
        }
        _collectionView.register(cellClass, forCellWithReuseIdentifier: config.identifier)
        return _collectionView
    }()
}

extension JRBannerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return config.isRepeat ? dataSource.count * kBannerCount : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = config.isRepeat ? indexPath.row % dataSource.count : indexPath.row
        return config.collectionViewCell?(collectionView, IndexPath(row: row, section: 0), dataSource[row]) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = config.isRepeat ? indexPath.row % dataSource.count : indexPath.row
        config.didSelectItem?(collectionView, indexPath, dataSource[row])
    }
    
    // MARK: - - - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beganDragging = true
        if config.isAuto {
            cancelTimer()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.isPagingEnabled {
            let index = config.isVertical ? scrollView.contentOffset.y / scrollView.frame.height : scrollView.contentOffset.x / scrollView.frame.width
            config.currentIndex = Int(index)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        beganDragging = false
        if !collectionView.isPagingEnabled {
            
        }
        
        if config.isAuto {
            createTimer()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if !collectionView.isPagingEnabled {
            
        }
    }
    
}

extension JRBannerView {

    private func setupView() {
        addSubview(collectionView)
        collectionView.isScrollEnabled = config.isScrollEnabled
        collectionView.isPagingEnabled = config.itemSize.width == collectionView.frame.size.width && config.lineSpacing == 0
        
        resetCollection()
    }
    
    private func resetCollection() {
        UIView.animate(withDuration: 0.1) { [self] in
            collectionView.reloadData()
            
            let row = config.isRepeat ? kBannerCount / 2 * dataSource.count + config.selectIndex : config.selectIndex
            let indexPath = IndexPath.init(row: row, section: 0)
            scroll(to: indexPath, animated: false)
            
            config.currentIndex = row
            if config.isAuto {
                createTimer()
            } else {
                cancelTimer()
            }
        }
    }
    
    func reloadView() {
        dataSource = config.dataSource
        resetCollection()
    }
    
    private func createTimer() {
        cancelTimer()
        
        timer = Timer.scheduledTimer(timeInterval: config.timeInterval, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func cancelTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc private func timerAction() {
        if beganDragging {
            return
        }
        if !config.isAuto {
            cancelTimer()
            return
        }
        
        config.currentIndex += 1
        
        if config.isRepeat && config.currentIndex == dataSource.count * kBannerCount {
            config.currentIndex = 0
        } else if !config.isRepeat && config.currentIndex == dataSource.count {
            cancelTimer()
            return
        }
        let indexPath = IndexPath(row: config.currentIndex, section: 0)
        scroll(to: indexPath, animated: true)
    }
}

extension JRBannerView {
    func scroll(to indexPath: IndexPath, animated: Bool) {
        let reuslt = config.isRepeat ? indexPath.row > dataSource.count * kBannerCount - 1 : indexPath.row > dataSource.count - 1
        if reuslt {
            cancelTimer()
            return
        }
        if dataSource.count == 0 {
            return
        }
        
        if collectionView.isPagingEnabled {
            collectionView.scrollToItem(at: indexPath, at: config.isVertical ? .centeredVertically : .centeredHorizontally, animated: animated)
            return
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        }
        
        if config.contentOffsetX > 0.5 {
            collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x - (config.contentOffsetX - 0.5) * collectionView.frame.width, y: collectionView.contentOffset.y)
        } else if config.contentOffsetX < 0.5 {
            collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x + (0.5 - config.contentOffsetX) * collectionView.frame.width, y: collectionView.contentOffset.y)
        }
    }
}
