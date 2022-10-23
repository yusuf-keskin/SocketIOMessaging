//
//  CoreMessage+CoreDataProperties.swift
//  
//
//  Created by YUSUF KESKİN on 16.10.2022.
//
//

import Foundation
import CoreData


extension CoreMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreMessage> {
        return NSFetchRequest<CoreMessage>(entityName: "CoreMessage")
    }

    @NSManaged public var message: String?
    @NSManaged public var messageDate: String?
    @NSManaged public var nickname: String?
}
