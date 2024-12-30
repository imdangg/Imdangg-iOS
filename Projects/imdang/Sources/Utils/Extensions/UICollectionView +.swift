//
//  UICollectionView +.swift
//  imdang
//
//  Created by 임대진 on 11/26/24.
//

import UIKit

extension UICollectionReusableView: Reusable { }

extension UICollectionView {
    func cellForItem<T: UICollectionViewCell>(atIndexPath indexPath: IndexPath) -> T {
        guard
            let cell = cellForItem(at: indexPath) as? T
        else {
            fatalError("Could not cellForItemAt at indexPath: \(T.reuseIdentifier)")
        }
        return cell
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableHeader<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath, headerType: T.Type = T.self) -> T {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue header with identifier: \(T.reuseIdentifier)")
        }
        return header
    }
    
    func dequeueReusableFooter<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath, footerType: T.Type = T.self) -> T {
        guard let footer = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue footer with identifier: \(T.reuseIdentifier)")
        }
        return footer
    }

    func register<T>(cell: T.Type) where T: UICollectionViewCell {
        register(cell, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    func register<T>(header: T.Type) where T: UICollectionReusableView {
        register(header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: header.reuseIdentifier)
    }
    
    func register<T>(footer: T.Type) where T: UICollectionReusableView {
        register(footer, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footer.reuseIdentifier)
    }
}
