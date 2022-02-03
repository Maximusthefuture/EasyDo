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
    func addRecentlyUsedTag(tag: String?)
    var recentlyUsedTagsBinding: ((String) -> Void)? { get set }// Color?
}

class CardAddTagsViewModel: CardAddTagsViewModelProtocol {
    var tagName: String?
    var recentlyUsedTagsBinding: ((String) -> Void)?
    var recentlyUsedTags: [String]? = ["Some", "Of", "Tags", "Is", "Here?", "LOng tag is here", "Here toooooooo"]
    
    func addRecentlyUsedTag(tag: String?) {
        recentlyUsedTags?.append(tag ?? "")
        recentlyUsedTagsBinding?(tag ?? "")
    }
    
    
}
