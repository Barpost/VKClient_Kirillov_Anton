//
//  LayoutViewModel.swift
//  VKclient_Kirillov_Anton
//
//  Created by Антон Кириллов on 22.10.2017.
//  Copyright © 2017 Barpost. All rights reserved.
//

import Foundation
import LayoutKit
import IGListKit

public protocol LayoutViewModel: ListDiffable {
    var size: CGSize { get }
    func calculateLayout(for width: CGFloat)
    func makeViews(in view: UIView)
    func didSelect()
}

open class GenericLayoutViewModel<T: Equatable>: LayoutViewModel {
    let id: String
    let model: T
    init(id: String, model: T) {
        self.id = id
        self.model = model
    }
    private lazy var layout: Layout = makeLayout()
    func makeLayout() -> Layout {
        preconditionFailure()
    }
    private var arrangement: LayoutArrangement?
    
    // MARK: - LayoutViewModel
    
    public var size: CGSize {
        return arrangement?.frame.size ?? .zero
    }
    public func calculateLayout(for width: CGFloat) {
        arrangement = layout.arrangement(width: width)
    }
    public func makeViews(in view: UIView) {
        arrangement?.makeViews(in: view)
    }
    public func didSelect() {}
    
    // MARK: - ListDiffable
    
    public func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: id)
    }
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? GenericLayoutViewModel<T> else {
            return false
        }
        return self.model == object.model
    }
}
