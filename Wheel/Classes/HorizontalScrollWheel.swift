//
//  horizontalScrollWheel.swift
//  test
//
//  Created by Amir Shayegh on 2019-04-17.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    public var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }
    
    public var centerCellIndexPath: IndexPath? {
        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
}


public class HorizontalScrollWheel: UIView {
    
    class func nib<T: UIView>(bundle: Bundle? = Bundle.main) -> T {
        return bundle!.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    // MARK: Variables
    let paddingCells = 4
    let selection = UISelectionFeedbackGenerator()
    
    var items: [String] = [String]()
    var current: String = ""
    var currentCenterCellIndexPath: IndexPath?
    var lastCallbackValue: String = ""
    var selected: [IndexPath] = [IndexPath]()
    
    var selectionChanged: ((_ selection: String)-> Void)?
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Setup
    func setup(with elements: [String], initial: String, selectionChanged: @escaping(_ value: String)->Void) {
        self.items = elements
        self.current = initial
        self.selectionChanged = selectionChanged
        setupCollectionView()
    }
    
    func callback(with selection: String) {
        if selection == lastCallbackValue {return}
        lastCallbackValue = selection
        if let callBack = selectionChanged {
            callBack(selection)
        }
    }
}

extension HorizontalScrollWheel: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        register(cell: "HorizontalPickerCollectionViewCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = cellSize()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func cellSize() -> CGSize {
        let w: CGFloat = 90
        return CGSize(width: w, height: self.collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    func register(cell name: String) {
        let nib = UINib(nibName: name, bundle: Wheel.bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: name)
    }
    
    func getCell(indexPath: IndexPath) -> HorizontalPickerCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalPickerCollectionViewCell", for: indexPath) as! HorizontalPickerCollectionViewCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count + paddingCells
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < paddingCells / 2 {
            let cell = getCell(indexPath: indexPath)
            cell.setup(with: "", isCurrent: false) {}
            return cell
        } else if indexPath.row - paddingCells / 2 < items.count {
            let cell = getCell(indexPath: indexPath)
            let item = items[indexPath.row - paddingCells / 2]
            cell.setup(with: item, isCurrent: item == current) {
                self.scrollToCell(at: indexPath)
            }
            return cell
        } else {
            let cell = getCell(indexPath: indexPath)
            cell.setup(with: "", isCurrent: false) {}
            return cell
        }
    }
    
    // MARK: Scroll selection
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath {
            scrollToCell(at: centerCellIndexPath)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath {
            scrollToCell(at: centerCellIndexPath)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.callback(with: current)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let centerCellIndexPath: IndexPath  = collectionView.centerCellIndexPath {
            if let current = self.currentCenterCellIndexPath, current != centerCellIndexPath {
                selection.selectionChanged()
            }
            self.currentCenterCellIndexPath = centerCellIndexPath
            highlightCell(at: centerCellIndexPath)
        }
    }
    
    func scrollToCell(at: IndexPath) {
        if at.row < paddingCells - 1 {
            let indexPath: IndexPath = [0, (paddingCells/2)]
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else if at.row > (items.count - 1) + (paddingCells/2) {
            let indexPath: IndexPath = [0, paddingCells/2 + (items.count - 1)]
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            self.collectionView.scrollToItem(at: at, at: .centeredHorizontally, animated: true)
        }
    }
    
    public func select(item: String) {
        guard let indexPathRow = items.firstIndex(of: item)  else { return }
        let indexPath: IndexPath = [0,(indexPathRow + paddingCells / 2)]
        scrollToCell(at: indexPath)
    }
    
    func highlightCell(at: IndexPath) {
        selected.append(at)
        let cellIndex = at.row - paddingCells / 2
        if cellIndex >= 0 && items.count > cellIndex {
            self.current = items[cellIndex]
            self.callback(with: self.current)
        }
        
        let visibleRows = collectionView.indexPathsForVisibleItems
        for item in visibleRows {
            if let cell = collectionView.cellForItem(at: item) as? HorizontalPickerCollectionViewCell {
                cell.deselect()
            }
        }
        if visibleRows.contains(at) {
            if let  cell = collectionView.cellForItem(at: at) as? HorizontalPickerCollectionViewCell {
                cell.select()
            }
        }
    }
}
