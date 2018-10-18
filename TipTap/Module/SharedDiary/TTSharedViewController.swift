//
//  TTSharedViewController.swift
//  TipTap
//
//  Created by Haehyeon Jeong on 2018. 8. 15..
//  Copyright © 2018년 Tiptap. All rights reserved.
//

import UIKit
import Darwin

import ScratchCard


class TTSharedViewController: TTBaseViewController, TTCanShowAlert {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private lazy var service = TTSharedDiaryService()
    
    var scratchView : ScratchUIView!
    var diaryDataList: [TTDiaryData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachScratchView()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
        collectionView.contentInset = UIEdgeInsetsMake(-70, 0, 0, 0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestSharedDiaryData()
    }

    func attachScratchView(){
        //Coupon : 지우고 나서의 원본 이미지
        //MaskImage : 지울 이미지
        
        let randomNumber = arc4random_uniform(3) + 1
        scratchView  = ScratchUIView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height),
                                     Coupon: self.view.asImage(),
                                     MaskImage: "scratch0\(randomNumber).png",
                                     ScratchWidth: CGFloat(40))
        scratchView.delegate = self
        self.view.addSubview(scratchView)
    }
    
    func requestSharedDiaryData() {
        service.fetchSharedDiaryList {
            (result) in
            switch result {
            case .success(let result):
                print("result : \(result)")
                self.diaryDataList = result
                break
            case .errorMessage(let errorMsg):
                print("errorMsg : \(errorMsg)")
                self.showAlert(title: "", message: errorMsg)
            default: break
            }
        }
    }
}

extension TTSharedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.diaryDataList?.count else {
            return 1
        }
        
        return count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let diaryList = self.diaryDataList!
        
        if (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SharedDiaryCell", for: indexPath) as! TTSharedCollectionViewDiaryCell
            cell.titleLabel.text = "\(diaryList.count)\nTIPTAP"
            cell.locationLabel.text = diaryList[0].location
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SharedDiaryListCell", for: indexPath) as! TTSharedCollectionViewListCell
            
            let diary = diaryList[indexPath.row - 1]
            
            let date = diary.createdAt!
            let range = date.index(date.startIndex, offsetBy: 11)...date.index(date.startIndex, offsetBy: 15)
            cell.timeLabel.text = String(date[range])
            cell.diaryNumberLabel.text = "\(indexPath.row - 1)"
            cell.locationLabel.text = diary.location
            
            let font = UIFont.systemFont(ofSize: 12)
            let style = NSMutableParagraphStyle()
            style.paragraphSpacing = -0.2
            style.lineSpacing = 5
            let attribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:style]
            cell.bodyLabel.attributedText = NSMutableAttributedString(string: diary.content!, attributes: attribute)
            
            return cell
        }
    }
}

extension TTSharedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.row == 0 ) {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 1, height: 1)
        }
    }
}


