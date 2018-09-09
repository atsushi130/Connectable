<p align="center">
    <h1 align="center">Connectable</h1>
</p1>

<p align="center"><i>Connectable protocol for readable ViewModel</i></p>

<p align="center">
    <a href="https://github.com/atsushi130/Connectable.git"><img src="https://img.shields.io/badge/Swift-Connectable-3B5998.svg"></a> 
    <img src="https://img.shields.io/badge/Swift-4-ffac45.svg">
    <img src="https://img.shields.io/badge/License-MIT-d94c32.svg">
</p>

## Installation
**Install via [Carthage](https://github.com/Carthage/Carthage)**
```
github "atsushi130/Connectable"
```

## Usage
Please your ViewModel conforms to Connectable and implement computed properties on each name space.
```swift
final class GithubViewModel: Connectable {

    fileprivate let searchText = Variable<String>("")
    fileprivate let searched   = PublishSubject<[GithubRepository]>()
    private let disposeBag = DisposeBag()

    init() {
        self.searchText.asObservable()
            .flatMapLatest { GithubApi.shared.searched(by: $0) }
            .bind(to: self.searched)
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Input
extension InputSpace where Definer == GithubViewModel {
    var searchText: Binder<String?> {
        return Binder(self.difiner) { element, value in
            guard let searchText = value else { return }
            element.searchedText.value = searchText
        }
    }
}

// MARK: - Output
extension OutputSpace where Definer == GithubViewModel {
    var searched: Observable<[GithubRepository]> {
        return self.difiner.searched.asObservable()
    }
}
```

Bind and subscribe.
```swift
final class GithubViewController: UIViewController {

    @IBOutpet private weak var textField: UITextField!

    private let viewModel  = GithubViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // self.viewModel.in.*
        self.textField.rx.text.asObservable()
            .bind(to: self.viewModel.in.searchText)
            .disposed(by: self.disposeBag)

        // self.viewModel.out.*
        self.viewModel.out.searched.subscribe(onNext: { repositories in
            print(repositories)
        }).disposed(by: self.disposeBag)
    }
}
```

## Requirements
- Swift 4 or later

## License
Connectable is available under the MIT license. See the [LICENSE file](https://github.com/atsushi130/Connectable/blob/master/license).
