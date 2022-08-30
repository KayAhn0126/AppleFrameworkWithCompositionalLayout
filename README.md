# 6. AppleFrameworkWithCompositionalLayout
- DiffableDataSource
- Snapshot
- Compositional Layout

## 🍎 작동 화면
- [기존 dataSource와 delegateflowlayout을 사용한 앱](https://github.com/KayAhn0126/AppleFramework)과 동일.

## 🍎 UICollectionViewDiffableDataSource & UICollectionViewCompositionalLayout 코드 분석
```swift

enum Section {
    case main
}

class FrameworkViewController: UIViewController {
    
    // var dataSource: UICollectionViewDiffableDataSource<<#SectionIdentifierType: Hashable#>, <#ItemIdentifierType: Hashable#>> -> 원형
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    // diffable datasource를 사용할 때 section의 타입과 item의 타입을 정의를 해야한다.
    
    typealias Item = AppleFramework
    // item 같은경우에는 AppleFramework타입을 쓰려고 했지만 AppleFramework타입은 hashable하지 않다. -> AppleFramework를 Hashable 프로토콜 채택하면서 해결.
    // 결과 => <Section, AppleFramework>. 하지만 뭔가 이것을 처음보는 사람은 AppleFramework라는것이 무엇인지 모를수가 있다. typealias를 이용해 가독성을 높여보자!
    // typealias Item = AppleFramework
    // 결과 => <Section, Item> -> 아주 깔끔하다.
    
    
    var frameworkList: [AppleFramework] = AppleFramework.list
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Presentation -> diffable datasource (데이터를 셀로 어떻게 보여줄지만 관리)
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameworkCollectionViewCell", for: indexPath) as? FrameworkCollectionViewCell else {
                return nil
            }
            cell.configure(itemIdentifier)
            return cell
        })
        
        // Data -> snapshot(진짜로 데이터만 관리)
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>() // 스냅샷 깡통을 만들어준다.
        // compositionalLayout은 [section [item]] 형식.
        snapshot.appendSections([.main]) 
        snapshot.appendItems(frameworkList, toSection: .main)
        dataSource.apply(snapshot) // dataSource에 적용시켜주면 자연스럽게 바뀐다.
        
        // Layout -> compositional Layout (셀들을 어떻게 보여줄지 관리)
        collectionView.collectionViewLayout = layout()
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        // fractionalWidth, fractionalHeight = 현재 자신이 속한 컨테이너의 크기를 기반으로 비율로써 자신의 크기를 정한다.
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
```


## 🍎 조금 더 공부해야 하는 부분
```swift
public init(collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.CellProvider)
```

.CellProvider은

```swift
public typealias CellProvider = (_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifierType) -> UICollectionViewCell?
```
