//
//  CustomCollectionViewCell.swift
//  JRBannerView
//
//  Created by wenhao lei on 2021/12/3.
//

import UIKit
import Kingfisher

class CustomCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { "\(self)" }
    
    static func cell(collectionView: UICollectionView, indexPath: IndexPath) -> CustomCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CustomCollectionViewCell
        return cell
    }
    
    var model: Model? {
        didSet {
            guard let model = model else {
                return
            }
            imageViem.kf.setImage(with: URL(string: model.image))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.addSubview(imageViem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageViem: UIImageView = {
        let _imageView = UIImageView(frame: bounds)
        _imageView.backgroundColor = .yellow
        return _imageView
    }()
}
