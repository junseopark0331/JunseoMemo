//
//  ComposeViewController.swift
//  JunseoMemo
//
//  Created by 박준서 on 2022/08/29.
//

import UIKit

class ComposeViewController: UIViewController {

    var editTarget: Memo?
    
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func save(_ sender: Any) {
        
        guard let memo = memoTextView.text,
            memo.count > 0 else{
            alert(message: "메모를 입력하세요")
            return
        }
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        if let target = editTarget{
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange ,object: nil)
        }else{
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
            
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget{
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
        }else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        
    }
}

extension ComposeViewController{
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
