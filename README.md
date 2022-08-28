# 6. AppleFrameworkWithCompositionalLayout

## 🍎 UICollectionViewDiffableDataSource & UICollectionViewCompositionalLayout
```swift
class FrameworkViewController: UIViewController {
    var frameworkList: [AppleFramework] = AppleFramework.list
    
    typealias Item = AppleFramework
    // var dataSource: UICollectionViewDiffableDataSource<<#SectionIdentifierType: Hashable#>, <#ItemIdentifierType: Hashable#>> -> 원형
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    // diffable datasource를 사용할 때 section의 타입과 item의 타입을 정의를 해야한다.
    // section 같은경우에는..
    enum Section {
        case main
    }
    // item 같은경우에는 AppleFramework타입을 쓰려고 했지만 AppleFramework타입은 hashable하지 않다. -> Hashable 프로토콜 채택
    // 결과 => <Section, AppleFramework>. 하지만 뭔가 이것을 처음보는 사람은 AppleFramework라는것이 무엇인지 모를수가 있다. typealias를 이용해 가독성을 높여보자!
    // typealias Item = AppleFramework
    // 결과 => <Section, Item> -> 아주 깔끔하다.
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
```

- 아직 snapshot과 layout부분은 확실하게 알지 못함. 여러가지 사용후 다시 README.md 업데이트 하기.



