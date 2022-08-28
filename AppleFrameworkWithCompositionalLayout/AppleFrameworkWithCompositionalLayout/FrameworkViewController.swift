//
//  ViewController.swift
//  AppleFrameworkWithCompositionalLayout
//
//  Created by Kay on 2022/08/27.
//

import UIKit

enum Section {
    case main
}

class FrameworkViewController: UIViewController {
    var frameworkList: [AppleFramework] = AppleFramework.list
    
    typealias Item = AppleFramework
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Data -> snapshot(진짜로 데이터만 관리)
        // Presentation -> diffable datasource (데이터를 셀로 어떻게 보여줄지만 관리)
        // Layout -> compositional Layout (셀들을 어떻게 보여줄지 관리)
        
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameworkCollectionViewCell", for: indexPath) as? FrameworkCollectionViewCell else {
                return nil
            }
            cell.configure(itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(frameworkList, toSection: .main)
        dataSource.apply(snapshot)
        collectionView.collectionViewLayout = layout()
        
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

