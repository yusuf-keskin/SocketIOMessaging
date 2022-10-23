//
//  CoreDataService.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 16.10.2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    
    static let shared = CoreDataService()
    
    let newSemaphore = DispatchSemaphore(value : 0)
    let newQueue = DispatchQueue.main
    
    func saveItemsToCache(messageArray : [ChatMessage]) {
        newQueue.async {
            
            self.newSemaphore.wait()
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            guard let context = appDelegate?.persistentContainer.viewContext else{
                print("Error occured")
                return
            }

            for message in messageArray {
                let newMessage = NSEntityDescription.insertNewObject(forEntityName: "CoreMessage", into: context)
                newMessage.setValue(message.nickname, forKey: "nickname")
                newMessage.setValue(message.date, forKey: "messageDate")
                newMessage.setValue(message.message, forKey: "message")
                
                do{
                    try context.save()
                } catch let error {
                    print(error)
                }
            }
        
        }

        newSemaphore.signal()

    }
    
    
    func loadItemsFromCache(completion: @escaping ([ChatMessage]) -> ()) {
        
        newQueue.async {
            
            self.newSemaphore.wait()
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            guard let context = appDelegate?.persistentContainer.viewContext else{
                print("Error")
                return
            }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreMessage")
            
            do{
                let  messageArray = try(context.fetch(fetchRequest) as? [CoreMessage] )!
                print("Fetch succcesfull")
                
                var dataArray = [ChatMessage]()
                var data : ChatMessage?
                
                for coreMessage in messageArray {

                    let nickname = coreMessage.nickname
                    let date = coreMessage.messageDate
                    let message = coreMessage.message
                    
                    data = ChatMessage(date: date, message: message, nickname: nickname)
                    dataArray.append(data!)
                }
                
                completion(dataArray)
            } catch let error {
                print(error)
            }
        }
        
        newSemaphore.signal()
    }
    
    func cleanCoreDataStorage() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            guard let context = appDelegate?.persistentContainer.viewContext else{
                print("Error")
                return
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreMessage")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
            } catch let error {
                print(error)
            }
        }
    }

}
