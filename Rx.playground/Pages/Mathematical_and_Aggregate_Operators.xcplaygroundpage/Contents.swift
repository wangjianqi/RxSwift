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
 # Mathematical and Aggregate Operators
 Operators that operate on the entire sequence of items emitted by an `Observable`.
 ## `toArray`
 Converts an `Observable` sequence into an array, emits that array as a new single-element `Observable` sequence, and then terminates. [More info](http://reactivex.io/documentation/operators/to.html)
 ![](http://reactivex.io/documentation/operators/images/to.c.png)
 */
example("toArray") {
    let disposeBag = DisposeBag()
    //转Array
    Observable.range(start: 1, count: 10)
        .toArray()
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `reduce`
 Begins with an initial seed value, and then applies an accumulator closure to all elements emitted by an `Observable` sequence, and returns the aggregate result as a single-element `Observable` sequence. [More info](http://reactivex.io/documentation/operators/reduce.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/reduce.png)
 */
example("reduce") {
    //从一个初始种子值开始，然后对一个可观察序列发出的所有元素应用累加器闭包，并以一个单元素可观察序列的形式返回聚合结果
    let disposeBag = DisposeBag()
    
    Observable.of(10, 100, 1000)
        .reduce(1, accumulator: +)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## `concat`
 Joins elements from inner `Observable` sequences of an `Observable` sequence in a sequential manner, waiting for each sequence to terminate successfully before emitting elements from the next sequence. [More info](http://reactivex.io/documentation/operators/concat.html)
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/concat.png)
 */
example("concat") {
    //以顺序方式连接来自一个可观察序列的内部可观察序列的元素，在从下一个序列发出元素之前，等待每个序列成功终止。
    let disposeBag = DisposeBag()
    
    let subject1 = BehaviorSubject(value: "🍎")
    let subject2 = BehaviorSubject(value: "🐶")
    
    let subjectsSubject = BehaviorSubject(value: subject1)
    
    subjectsSubject.asObservable()
        .concat()
        .subscribe { print($0) }
        .disposed(by: disposeBag)
    
    subject1.onNext("🍐")
    subject1.onNext("🍊")
    
    subjectsSubject.onNext(subject2)
    
    subject2.onNext("I would be ignored")
    subject2.onNext("🐱")
    
    subject1.onCompleted()
    
    subject2.onNext("🐭")
}

//: [Next](@next) - [Table of Contents](Table_of_Contents)
