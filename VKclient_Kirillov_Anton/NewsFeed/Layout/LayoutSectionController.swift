//
//  LayoutSectionController.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 22.10.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import IGListKit

final class LayoutSectionController: ListSectionController {
        
    private var viewModel: LayoutViewModel?
    
    init(viewModel: LayoutViewModel?) {
        super.init()
        self.viewModel = viewModel
    }
    convenience init(object: Any) {
        self.init(viewModel: object as? LayoutViewModel)
    }
    // MARK: - ListSectionController
    override func didUpdate(to object: Any) {
        guard let viewModel = object as? LayoutViewModel else {
            return
        }
        self.viewModel = viewModel
    }
    override func numberOfItems() -> Int {
        return 1
    }
    override func sizeForItem(at index: Int) -> CGSize {
        return viewModel?.size ?? .zero
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: UICollectionViewCell.self, for: self, at: index)
        viewModel?.makeViews(in: cell.contentView)
        return cell
    }
    override func didSelectItem(at index: Int) {
        viewModel?.didSelect()
    }
}

