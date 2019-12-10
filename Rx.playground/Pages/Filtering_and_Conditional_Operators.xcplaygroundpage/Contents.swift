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
# Filtering and Conditional Operators
Operators that selectively emit elements from a source `Observable` sequence.
## `filter`
Emits only those elements from an `Observable` sequence that meet the specified condition. [More info](http://reactivex.io/documentation/operators/filter.html)
![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/filter.png)
*/
example("filter") {
    //只发出满足指定条件的可观察序列中的那些元素
    let disposeBag = DisposeBag()
    //filter
    Observable.of(
        "🐱", "🐰", "🐶",
        "🐸", "🐱", "🐰",
        "🐹", "🐸", "🐱")
        .filter {
            $0 == "🐱"
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
## `distinctUntilChanged`
 Suppresses sequential duplicate elements emitted by an `Observable` sequence. [More info](http://reactivex.io/documentation/operators/distinct.html)
![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/distinct.png)
*/
example("distinctUntilChanged") {
    let disposeBag = DisposeBag()
    //抑制由可见序列发出的连续重复元素:去除重复元素
    Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `elementAt`
 Emits only the element at the specified index of all elements emitted by an `Observable` sequence. [More info](http://reactivex.io/documentation/operators/elementat.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/elementat.png)
 */
example("elementAt") {
    //只发出一个可观察序列发出的所有元素的指定索引处的元素
    let disposeBag = DisposeBag()
    
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .elementAt(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `single`
 Emits only the first element (or the first element that meets a condition) emitted by an `Observable` sequence. Will throw an error if the `Observable` sequence does not emit exactly one element.
 */
example("single") {
    //只发出由可见序列发出的第一个元素(或满足条件的第一个元素)。如果可观察序列不恰好发出一个元素，将抛出一个错误
    let disposeBag = DisposeBag()
    
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .single()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

example("single with conditions") {
    let disposeBag = DisposeBag()
    
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .single { $0 == "🐸" }
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    //这个包含两个🐰
    Observable.of("🐱", "🐰", "🐶", "🐱", "🐰", "🐶")
        .single { $0 == "🐰" }
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .single { $0 == "🔵" }
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `take`
 Emits only the specified number of elements from the beginning of an `Observable` sequence. [More info](http://reactivex.io/documentation/operators/take.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/take.png)
 */
example("take") {
    //只从一个可观察序列的开始发出指定数目的元素
    let disposeBag = DisposeBag()
    
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .take(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `takeLast`
 Emits only the specified number of elements from the end of an `Observable` sequence. [More info](http://reactivex.io/documentation/operators/takelast.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takelast.png)
 */
example("takeLast") {
    let disposeBag = DisposeBag()
    //后三个
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .takeLast(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `takeWhile`
 Emits elements from the beginning of an `Observable` sequence as long as the specified condition evaluates to `true`. [More info](http://reactivex.io/documentation/operators/takewhile.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takewhile.png)
 */
example("takeWhile") {
    let disposeBag = DisposeBag()
    //takeWhile:设置条件
    Observable.of(1, 2, 3, 4, 5, 6)
        .takeWhile { $0 < 4 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `takeUntil`
 Emits elements from a source `Observable` sequence until a reference `Observable` sequence emits an element. [More info](http://reactivex.io/documentation/operators/takeuntil.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/takeuntil.png)
 */
example("takeUntil") {
    //从源可见序列发出元素，直到参考可见序列发出元素
    let disposeBag = DisposeBag()
    
    let sourceSequence = PublishSubject<String>()
    let referenceSequence = PublishSubject<String>()
    
    sourceSequence
        .takeUntil(referenceSequence)
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
    sourceSequence.onNext("🐱")
    sourceSequence.onNext("🐰")
    sourceSequence.onNext("🐶")
    
    referenceSequence.onNext("🔴")
    
    sourceSequence.onNext("🐸")
    sourceSequence.onNext("🐷")
    sourceSequence.onNext("🐵")
}
/*:
 ----
 ## `skip`
 Suppresses emitting the specified number of elements from the beginning of an `Observable` sequence. [More info](http://reactivex.io/documentation/operators/skip.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/skip.png)
 */
example("skip") {
    let disposeBag = DisposeBag()
    //跳过前n个
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .skip(2)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `skipWhile`
 Suppresses emitting the elements from the beginning of an `Observable` sequence that meet the specified condition. [More info](http://reactivex.io/documentation/operators/skipwhile.html)
 ![](http://reactivex.io/documentation/operators/images/skipWhile.c.png)
 */
example("skipWhile") {
    //禁止从满足指定条件的可观察序列的开头发出元素
    let disposeBag = DisposeBag()
    //条件成立，直接跳过，直到条件不成立
    Observable.of(1, 2, 3, 4, 5, 6)
        .skipWhile { $0 < 4 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `skipWhileWithIndex`
 Suppresses emitting the elements from the beginning of an `Observable` sequence that meet the specified condition, and emits the remaining elements. The closure is also passed each element's index.
 */
example("skipWhileWithIndex") {
    let disposeBag = DisposeBag()
    //禁止从满足指定条件的可观察序列的开头发出元素，并发出其余元素。闭包还传递每个元素的索引。
    Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
        .enumerated()
        .skipWhile { $0.index < 3 }
        .map { $0.element }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `skipUntil`
 Suppresses emitting the elements from a source `Observable` sequence until a reference `Observable` sequence emits an element. [More info](http://reactivex.io/documentation/operators/skipuntil.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/skipuntil.png)
 */
example("skipUntil") {
    //抑制从源可见序列发出元素，直到参考可见序列发出元素
    let disposeBag = DisposeBag()
    
    let sourceSequence = PublishSubject<String>()
    let referenceSequence = PublishSubject<String>()

    sourceSequence
        .skipUntil(referenceSequence)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    sourceSequence.onNext("🐱")
    sourceSequence.onNext("🐰")
    sourceSequence.onNext("🐶")
    
    referenceSequence.onNext("🔴")
    
    sourceSequence.onNext("🐸")
    sourceSequence.onNext("🐷")
    sourceSequence.onNext("🐵")
}

//: [Next](@next) - [Table of Contents](Table_of_Contents)
