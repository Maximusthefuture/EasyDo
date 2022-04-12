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
    func getAttachments()
}

class AttachmentsViewModel: AttachmentsViewModelProtocol {
    
    var coreDataStack: CoreDataStack?
    var task: Task?
    var attachmetsImages: [UIImage]?
    
    
    init() {
        getAttachments()
    }
    
    func saveImageToCoreData(_ image: Data?) {
        let attachments = Attachments(context: coreDataStack!.managedContext)
        attachments.images?.append(image ?? Data())
        if let task = task {
            task.attachments = attachments
        }
        coreDataStack?.saveContext()
    }
    
    func getAttachments() {
        let fetch = Attachments.fetchRequest()
        let attachments = try? coreDataStack?.managedContext.fetch(fetch)
        
        attachments?.compactMap { attachment in
            attachment.images?.compactMap({ data in
                let image = UIImage(data: data)
                self.attachmetsImages?.append(image ?? UIImage())
            })
        }
    }
}
