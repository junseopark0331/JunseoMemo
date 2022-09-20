//
//  DataManager.swift
//  JunseoMemo
//
//  Created by 박준서 on 2022/09/18.
//

import Foundation
import CoreData

class DataManager {
    static let  shared = DataManager()
    private init() {

    }

    var mainContenxt: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var memoList = [Memo]()

    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()

        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]

        do {
            memoList = try mainContenxt.fetch(request)
        } catch {
            print(error)
        }
    }

    func addNewMemo( memo: String?) {
        let newMemo = Memo(context: mainContenxt)
        newMemo.content = memo
        newMemo.insertDate = Date()

        memoList.insert(newMemo, at: 0)

        saveContext()
    }

    func deleteMemo( memo: Memo?) {
        if let memo = memo {
            mainContenxt.delete(memo)
            saveContext()
        }
    }

    func addNewMemo(_ memo: String?){
        let newMemo = Memo(context: mainContenxt)
        newMemo.content = memo
        newMemo.insertDate = Date()
        
    }
    

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Memomo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error (error), (error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error (nserror), (nserror.userInfo)")
            }
        }
    }
}
