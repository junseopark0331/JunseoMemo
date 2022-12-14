//
//  DetailViewController.swift
//  JunseoMemo
//
//  Created by 박준서 on 2022/09/06.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var memoTableView: UITableView!
    
    
    var memo: Memo? //이전화면에서 전달할 메모를 저장할 속성
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        
        guard let memo = memo?.content else{return}
        
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        present(vc,animated: true,completion: nil)
        
        if let pc = vc.popoverPresentationController{
            pc.barButtonItem = sender
        }
        
        
    }
    
    
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "삭제", style: .destructive){ [weak self]
            (action) in
            DataManager.shared.deleteMemo(memo: self?.memo)
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as?
            ComposeViewController{
            vc.editTarget = memo
        }
    }
    
    
    var token: NSObjectProtocol?
    
    deinit{
        if let token = token{
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange,
            object: nil, queue: OperationQueue.main, using: { [weak self](noti) in
            self?.memoTableView.reloadData()
        })
       
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

extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        //테이블 뷰가 표시할 셀 개수를 물어볼때 호출되는 메서드
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            
            cell.textLabel?.text = memo?.content
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            return cell
            
        default:
            fatalError()
            //default에러에서 빈 셀을 보내므로 fatal error를 사용해 크러시가 발생하게해 새로운 코드가 필요하다는 것을 확실히 알려줌.
        }
    }
    
    
}
