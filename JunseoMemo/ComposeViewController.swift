//
//  ComposeViewController.swift
//  JunseoMemo
//
//  Created by 박준서 on 2022/08/29.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    var originalMemoContent: String?
    
    
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
            originalMemoContent = memo.content
        }else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        memoTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        navigationController?.presentationController?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        
        navigationController?.presentationController?.delegate = nil
    }
    
}
    
    extension ComposeViewController: UITextViewDelegate{
        func textViewDidChange(_ textView: UITextView){
            if let original = originalMemoContent, let edited = textView.text{
                if #available(iOS 13.0, *){
                    isModalInPresentation = original != edited
                }else{
                }
            }
        }
    }
    
extension ComposeViewController: UIAdaptivePresentationControllerDelegate{
    func presntationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController){
        let alert = UIAlertController(title: "알림", message: "편집할 내용을 저장할까요??", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default){[weak self](action) in
            self?.save(action)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel){[weak self](action) in
            self?.close(action)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
    
    extension ComposeViewController{
        static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
        static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
        
        
}
