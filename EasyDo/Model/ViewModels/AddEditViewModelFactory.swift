//
//  AddEditViewModelFactory.swift
//  EasyDo
//
//  Created by Maximus on 01.02.2022.
//

import Foundation

protocol AddEditViewModelFactoryProtocol {
    func makePomodoroViewModel() -> PomodoroCountViewModelProtocol
    func makeAttachmentViewModel() -> AttachmentsViewModelProtocol
    func makeCardAddTagsViewModel() -> CardAddTagsViewModelProtocol
}


class AddEditViewModelFactory: AddEditViewModelFactoryProtocol {
   
    lazy var pomodoroViewModel = PomodoroCountViewModel()
    lazy var attachmentViewModel = AttachmentsViewModel()
    lazy var cardAddTagsViewModel = CardAddTagsViewModel()
    
    func makePomodoroViewModel() -> PomodoroCountViewModelProtocol {
        return pomodoroViewModel
    }
    
    func makeAttachmentViewModel() -> AttachmentsViewModelProtocol {
        return attachmentViewModel
    }
    
    func makeCardAddTagsViewModel() -> CardAddTagsViewModelProtocol {
        return cardAddTagsViewModel
    }
}
