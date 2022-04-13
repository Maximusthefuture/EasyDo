//
//  AttachmentsViewModel.swift
//  EasyDo
//
//  Created by Maximus on 28.01.2022.
//

import Foundation
import UIKit

protocol AttachmentsViewModelProtocol: AnyObject {
    var coreDataStack: CoreDataStack? { get set }
    var task: Task? { get set }
    var attachmetsImages: [UIImage]? { get set }
    func saveImageToCoreData(_ image: Data?)
    func getAttachments(completion: @escaping ([Attachments]?) -> Void)
}

class AttachmentsViewModel: AttachmentsViewModelProtocol {
  
    var coreDataStack: CoreDataStack?
    var task: Task?
    var attachmetsImages: [UIImage]?
    
    
    init() {
        
    }
    
    func saveImageToCoreData(_ image: Data?) {
        let attachments = Attachments(context: coreDataStack!.managedContext)
        
        if let task = task {
            attachments.images?.append(image ?? Data())
            task.attachments = attachments
        }
        coreDataStack?.saveContext()
    }
    
    func getTask(completion: @escaping () -> Void) {
        completion()
    }
    
    func getAttachments(completion: @escaping ([Attachments]?) -> Void) {
        let fetch = Attachments.fetchRequest()
        let attachments = try? coreDataStack?.managedContext.fetch(fetch)
        completion(attachments)
    }
}
