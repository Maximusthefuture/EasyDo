//
//  CardAddTagsViewModel.swift
//  EasyDo
//
//  Created by Maximus on 28.01.2022.
//

import Foundation

protocol CardAddTagsViewModelProtocol: AnyObject {
    var tagName: String? { get set }
    var recentlyUsedTags: [String]? { get set }
    func addRecentlyUsedTag(tag: String?) // Color?
}

class CardAddTagsViewModel: AttachmentsViewModelProtocol {
    var tagName: String?
    
    var recentlyUsedTags: [String]? = ["Some", "Of", "Tags", "Is", "Here?"]
    
    func addRecentlyUsedTag(tag: String?) {
        recentlyUsedTags?.append(tag ?? "")
    }
    
    
}
