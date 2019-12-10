/*:
 > # IMPORTANT: To use **Rx.playground**:
 1. Open **Rx.xcworkspace**.
 1. Build the **RxExample-macOS** scheme (**Product** → **Build**).
 1. Open **Rx** playground in the **Project navigator** (under RxExample project).
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 ----
 [Previous](@previous) - [Table of Contents](Table_of_Contents)
 */
import RxSwift
/*:
# Transforming Operators
Operators that transform Next event elements emitted by an `Observable` sequence.
## `map`
 Applies a transforming closure to elements emitted by an `Observable` sequence, and returns a new `Observable` sequence of the transformed elements. [More info](http://reactivex.io/documentation/operators/map.html)
![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/map.png)
*/
example("map") {
    //将一个转换闭包应用于由一个可观察序列发出的元素，并返回被转换元素的一个新的可观察序列
    let disposeBag = DisposeBag()
    Observable.of(1, 2, 3)
        .map { $0 * $0 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `flatMap` and `flatMapLatest`
 Transforms the elements emitted by an `Observable` sequence into `Observable` sequences, and merges the emissions from both `Observable` sequences into a single `Observable` sequence. This is also useful when, for example, when you have an `Observable` sequence that itself emits `Observable` sequences, and you want to be able to react to new emissions from either `Observable` sequence. The difference between `flatMap` and `flatMapLatest` is, `flatMapLatest` will only emit elements from the most recent inner `Observable` sequence. [More info](http://reactivex.io/documentation/operators/flatmap.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/flatmap.png)
 */
example("flatMap and flatMapLatest") {
    /*
将一个可观察序列发出的元素转换为可观察序列，并将两个可观察序列发出的元素合并为一个可观察序列。这在某些情况下也很有用，例如，当你有一个可观察到的序列它本身会发出可观察到的序列，而你想要能够对任何一个可观察到的序列的新发射做出反应。flatMapLatest和flatMapLatest的区别是，flatMapLatest只发射来自最近的内部可观测序列的元素
     */
    let disposeBag = DisposeBag()
    
    struct Player {
        init(score: Int) {
            self.score = BehaviorSubject(value: score)
        }

        let score: BehaviorSubject<Int>
    }
    
    let 👦🏻 = Player(score: 80)
    let 👧🏼 = Player(score: 90)
    
    let player = BehaviorSubject(value: 👦🏻)
    //flatMap
    player.asObservable()
        .flatMap { $0.score.asObservable() } // Change flatMap to flatMapLatest and observe change in printed output
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    👦🏻.score.onNext(85)
    
    player.onNext(👧🏼)
    
    👦🏻.score.onNext(95) // Will be printed when using flatMap, but will not be printed when using flatMapLatest
    
    👧🏼.score.onNext(100)
}
/*:
 > In this example, using `flatMap` may have unintended consequences. After assigning 👧🏼 to `player.value`, `👧🏼.score` will begin to emit elements, but the previous inner `Observable` sequence (`👦🏻.score`) will also still emit elements. By changing `flatMap` to `flatMapLatest`, only the most recent inner `Observable` sequence (`👧🏼.score`) will emit elements, i.e., setting `👦🏻.score.value` to `95` has no effect.
 #
 > `flatMapLatest` is actually a combination of the `map` and `switchLatest` operators.
 */
/*:
 ----
 ## `scan`
 Begins with an initial seed value, and then applies an accumulator closure to each element emitted by an `Observable` sequence, and returns each intermediate result as a single-element `Observable` sequence. [More info](http://reactivex.io/documentation/operators/scan.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/scan.png)
 */
example("scan") {
    //从一个初始种子值开始，然后对一个可观察序列发出的每个元素应用累加器闭包，并将每个中间结果作为一个单元素可观察序列返回
    let disposeBag = DisposeBag()
    //scan(1): 加一
    Observable.of(10, 100, 1000)
        .scan(1) { aggregateValue, newValue in
            aggregateValue + newValue
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

//: [Next](@next) - [Table of Contents](Table_of_Contents)
