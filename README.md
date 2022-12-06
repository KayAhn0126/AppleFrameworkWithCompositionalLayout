# AppleFrameworkWithCompositionalLayout

## 🍎 작동 화면
- [기존 dataSource와 delegateflowlayout을 사용한 앱](https://github.com/KayAhn0126/AppleFramework)과 동일.

## 🍎 UICollectionViewDiffableDataSource & UICollectionViewCompositionalLayout 코드 분석
```swift
enum Section {
    case main
}

class FrameworkViewController: UIViewController {

    typealias Item = AppleFramework // 1
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! // 2
    
    var frameworkList: [AppleFramework] = AppleFramework.list
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Presentation -> diffable datasource (데이터를 셀로 어떻게 보여줄지만 관리)
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameworkCollectionViewCell", for: indexPath) as? FrameworkCollectionViewCell else {
                return nil
            }
            cell.configure(itemIdentifier)
            return cell
        })
        
        // Data -> snapshot(진짜로 데이터만 관리)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>() // 스냅샷 객체 생성
        // compositionalLayout은 [section [item]] 형식.
        snapshot.appendSections([.main]) 
        snapshot.appendItems(frameworkList, toSection: .main)
        dataSource.apply(snapshot) // dataSource에 적용시켜주면 자연스럽게 바뀐다.
        
        // Layout -> compositional Layout (셀들을 어떻게 보여줄지 관리)
        collectionView.collectionViewLayout = layout()
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1))
        // item의 사이즈의 가로는 group의 0.33배, 세로는 1배.
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
        // group의 사이즈는 가로는 section의 1배, 세로는 0.33배.
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        // .horizontal은 item들을 가로로 넣겠다는 이야기이다.
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
```

## 🍎 typealias로 가독성 높이기
- 1번 주석이 있는 코드를 보면 아래와 같다.
```swift
typealias Item = AppleFramework
```
- 왜 이렇게 만들어 주었을까? 바로 아래의 2번 주석이 있는 코드 dataSource를 생성할 때 ItemIdentifierType 위치에 AppleFramework 타입이 들어가는데, 이때 typealias를 사용해 가독성을 높여준다.  
- typealias를 사용하지 않은 코드와 사용한 코드를 비교해보자.
```swift
var dataSource: UICollectionViewDiffableDataSource<Section, AppleFramework>!
```
```swift
var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
```
- 후술할 내용이지만, Section과 Item 위치에 들어갈 타입은 모두 hashable 해야한다.하지만 AppleFramework 타입은 hashable하지 않아 AppleFramework에 Hashable 프로토콜 채택하면서 해결했다.
    
## 🍎 dataSource 생성하기
- 2번 주석에서 dataSource를 생성할 때 사용한 클래스의 정의부를 보면 아래와 같다
```swift
open class UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> : NSObject, UICollectionViewDataSource where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable
```
- SectionIdentifierType와 ItemIdentifierType 타입은 모두 Hashable 해야 한다는것을 알 수 있다.
- Section은 열거형으로 Hashable하게 만들었고, Item은 AppleFramework 구조체에 Hashable 프로토콜을 채택해 Hashable하게 만들었다.

## 🍎 layout 메서드 살펴보기
- fractionalWidth, fractionalHeight = 현재 자신이 속한 컨테이너의 크기를 기반으로 비율로써 자신의 크기를 정한다.
