//
//  ComposeViewController.swift
//  JunseoMemo
//
//  Created by 박준서 on 2022/08/29.
//

import UIKit

class ComposeViewController: UIViewController {

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBOutlet weak var memoTextView: UITextView!
    
    
    
    @IBAction func save(_ sender: Any) {
        
        guard let memo = memoTextView.text,
            memo.count > 0 else{
            alert(message: "메모를 입력하세요")
            return
        }
        let newMemo = Memo(content: memo)
        Memo.dummyMemoList.append(newMemo)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
