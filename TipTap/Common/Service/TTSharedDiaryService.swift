//
//  TTSharedDiaryService.swift
//  TipTap
//
//  Created by GAIN LEE on 2018. 10. 18..
//  Copyright © 2018년 Tiptap. All rights reserved.
//

import Foundation

class TTSharedDiaryService {
    private let URL = ""
    private var myDiartData : [String]?
    
    func fetchSharedDiaryList(completion: @escaping (TTResult<[TTDiaryData]>) -> ()) {
        TTAPIManager.sharedManager.requestAPI("\(TTAPIManager.API_URL)/diary/random", method: .get) { (result) in
            print("result: \(result)")
            let resultData = TTDiaryDataSet(rawJson: result)
            guard let dataList = resultData.diaryDataList else { return }
            
            completion(.success(dataList))
        }
    }
}
