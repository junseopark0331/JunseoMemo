//
//  Model.swift
//  JunseoMemo
//
//  Created by 박준서 on 2022/08/23.
//

import Foundation


class Memo {
    var content: String
    var insertDate: Date
    
    init(content: String){
        self.content = content
        insertDate = Date()
    }
    static var dummyMemoList = [
        Memo(content: "Lorem Ipsum"),
        Memo(content: "Subscribe + 👍🏻 = ❤️"),
    
    ]
    
    
}
