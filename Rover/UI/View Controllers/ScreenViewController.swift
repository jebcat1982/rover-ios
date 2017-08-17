//
//  ScreenViewController.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class ScreenViewController: UICollectionViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return screenViewModel.preferredStatusBarStyle
    }
    
    var screenViewModel: ScreenViewModel
    
    var delegate: ScreenViewControllerDelegate?
    
    init(screenViewModel: ScreenViewModel) {
        self.screenViewModel = screenViewModel
        
        let layout = ScreenViewLayout(screenViewModel: screenViewModel)
        super.init(collectionViewLayout: layout)
        
        configureTitle()
        configureNavigationItem()
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerReusableViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: Register reusable views

extension ScreenViewController {
    
    func registerReusableViews() {
        register(BarcodeBlockView.self)
        register(BlockView.self)
        register(ButtonBlockView.self)
        register(ImageBlockView.self)
        register(RectangleBlockView.self)
        register(RowView.self)
        register(TextBlockView.self)
        register(WebViewBlockView.self)
    }
    
    func register<T>(_ blockType: T.Type) where T: BlockView {
        collectionView?.register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T>(_ viewType: T.Type) where T: UICollectionReusableView {
        collectionView?.register(T.self, forSupplementaryViewOfKind: T.defaultReuseIdentifier, withReuseIdentifier: T.defaultReuseIdentifier)
    }
}

// MARK: Configuration

extension ScreenViewController {
    
    func configureNavigationItem() {
        navigationItem.setHidesBackButton(screenViewModel.hidesBackButton, animated: true)
        
        if screenViewModel.hasCloseButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        }
    }
    
    @objc func close() {
        delegate?.close()
    }
    
    func configureNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        navigationBar.barTintColor = screenViewModel.navigationBarBackgroundColor
        navigationBar.tintColor = screenViewModel.navigationBarItemColor
        navigationBar.titleTextAttributes = screenViewModel.applyNavigationBarTitleColor(toTitleTextAttributes: navigationBar.titleTextAttributes)
    }
    
    func configureTitle() {
        title = screenViewModel.title
    }
    
    func configureView() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        collectionView.backgroundColor = screenViewModel.backgroundColor
    }
}

// MARK: UICollectionViewDelegate

extension ScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

// MARK: UICollectionViewDataSource

extension ScreenViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenViewModel.numberOfItems(inSection: section)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return screenViewModel.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let blockViewModel = screenViewModel.blockViewModel(at: indexPath) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: BlockView.defaultReuseIdentifier, for: indexPath)
        }
        
        let view = collectionView.dequeueReusableCell(withReuseIdentifier: blockViewModel.cellReuseIdentifer, for: indexPath)
        
        guard let blockView = view as? BlockView else {
            return view
        }
        
        guard let layout = collectionViewLayout as? ScreenViewLayout, let attributes = layout.layoutAttributesForItem(at: indexPath) else {
            return view
        }
        
        blockView.configure(with: blockViewModel, inFrame: attributes.frame)
        blockView.delegate = self
        return blockView
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: RowView.defaultReuseIdentifier, withReuseIdentifier: RowView.defaultReuseIdentifier, for: indexPath)
        
        guard let rowView = view as? RowView, let rowViewModel = screenViewModel.rowViewModel(at: indexPath) else {
            return view
        }
        
        guard let layout = collectionViewLayout as? ScreenViewLayout, let attributes = layout.layoutAttributesForSupplementaryView(ofKind: RowView.defaultReuseIdentifier, at: indexPath) else {
            return view
        }
        
        rowView.configure(with: rowViewModel, inFrame: attributes.frame)
        return rowView
    }
}

// MARK: BlockViewDelegate

extension ScreenViewController: BlockViewDelegate {
    
    func blockViewDidTap(_ blockView: BlockView) {
        guard let indexPath = collectionView?.indexPath(for: blockView) else {
            return
        }
        
        guard let blockViewModel = screenViewModel.blockViewModel(at: indexPath) else {
            return
        }
        
        guard let action = blockViewModel.action else {
            return
        }
        
        switch action {
        case let .goToScreen(experienceID, screenID):
            delegate?.goToScreen(withExperienceID: experienceID, screenID: screenID)
        case let .openURL(url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
