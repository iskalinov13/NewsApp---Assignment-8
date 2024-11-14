//
//  ViewController.swift
//  NewsApp
//
//  Created by FIskalinov on 14.11.2024.
//

import UIKit
import SnapKit

class NewsController: UIViewController {
    private let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let itemsPerRow: CGFloat = 1
    private let viewModel: NewsViewModel
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()
    
    // MARK: Init
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycly
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        fetchData()
        bindViewModel()

    }
}

//MARK: View Layout & Binding
private extension NewsController {
    func layoutUI() {
        title = "News+"
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(collectionView)
        setUpCollectionView()
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NewCell.self, forCellWithReuseIdentifier: "newCell")
    }
    
    func fetchData() {
        viewModel.getTopHeadLines()
    }
    
    func bindViewModel() {
        viewModel.didLoadNews = { [weak self] news in
            self?.collectionView.reloadData()
        }
    }
}

//MARK: CollectionView Data Source
extension NewsController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as! NewCell
        cell.configure(data: viewModel.news[indexPath.item])
        return cell
        
    }
}

//MARK: FlowLayout Delegate
extension NewsController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


//MARK: CollectionView Delegate
extension NewsController: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = NewDetailViewController()
//        let new = viewModel.news[indexPath.item]
//        vc.webUrl = new.url
//        navigationController?.pushViewController(vc, animated: true)
//    }
}
