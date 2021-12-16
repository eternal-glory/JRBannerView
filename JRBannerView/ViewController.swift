//
//  ViewController.swift
//  JRBannerView
//
//  Created by wenhao lei on 2021/12/3.
//

import UIKit

class ViewController: UIViewController {

    var config: JRBannerConfig = .init()
    var bannerView: JRBannerView = .init()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        config = JRBannerConfig()
            .setFrame(by: .init(x: 0, y: 100, width: view.frame.width, height: 400))
            .setItemSize(by: .init(width: view.frame.width, height: 400))
            .setLineSpacing(by: 10)
            .setSectionInset(by: .init(top: 0, left: 40, bottom: 0, right: 40))
            .setOrSoCellPosition(by: .bottom)
//            .setVertical(by: true)
            .setIsScale(by: true)
            .setAutoScroll(by: true)
            .setRepeatScroll(by: true)
            .setRepeatScroll(by: true)
            .setCellIdentifier(by: CustomCollectionViewCell.identifier)
            .setCollectionViewCell { collectionView, indexPath, model in
                let cell = CustomCollectionViewCell.cell(collectionView: collectionView, indexPath: indexPath)
                cell.model = model
                return cell
            }
            .setDidSelectedItem(by: { collectionView, indexPath, model in
                
            })
        bannerView = JRBannerView(config: config)
        view.addSubview(bannerView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let _ = self.config.setDataSource(by: [
                "http://f.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=64fdb384ce5c1038242bc6c68721bf25/060828381f30e92435342faf44086e061c95f798.jpg",
                "http://dmimg.5054399.com/allimg/optuji/qbanop/38.jpg",
                "http://gss0.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/09fa513d269759ee1100528cb2fb43166d22df20.jpg"
            ])
            self.bannerView.reloadView()
        }
    }
}


extension ViewController {
    
}
