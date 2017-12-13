//
//  LayoutListDataSource.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 22.10.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

final class LayoutListDataSource: NSObject, ListAdapterDataSource {
    private let updateQueue = DispatchQueue(label: "")
    private var viewModels = [LayoutViewModel]()
    private let adapter: ListAdapter
    
    init(viewController: UIViewController, collectionView: UICollectionView, workingRangeSize: Int = 0) {
        adapter = ListAdapter(
            updater: ListAdapterUpdater(),
            viewController: viewController,
            workingRangeSize: workingRangeSize
        )
        super.init()
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    func set(viewModels: [LayoutViewModel], animated: Bool = true) {
        precondition(Thread.isMainThread)
        performUpdates(animated) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewModels.removeAll()
            for viewModel in viewModels {
                viewModel.calculateLayout(for: UIScreen.main.bounds.width)
            }
            strongSelf.viewModels.append(contentsOf: viewModels)
        }
    }
    
    private func performUpdates(_ animated: Bool = true, _ updates: @escaping () -> Void) {
        updateQueue.async { [weak self] in
            updates()
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                if animated {
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    strongSelf.adapter.performUpdates(animated: true, completion: { _ in
                        UIApplication.shared.endIgnoringInteractionEvents()
                    })
                } else {
                    strongSelf.adapter.performUpdates(animated: false, completion: nil)
                }
            }
        }
    }
    
    // MARK: - ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModels as [ListDiffable]
    }
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return LayoutSectionController(object: object)
    }
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

