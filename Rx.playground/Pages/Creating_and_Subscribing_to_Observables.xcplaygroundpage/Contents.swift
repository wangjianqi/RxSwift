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
 # Creating and Subscribing to `Observable`s
 There are several ways to create and subscribe to `Observable` sequences.
 ## never
 Creates a sequence that never terminates and never emits any events. [More info](http://reactivex.io/documentation/operators/empty-never-throw.html)
 */
example("never") {
    //创建一个永不终止且永不发出任何事件的序列
    let disposeBag = DisposeBag()
    //never
    let neverSequence = Observable<String>.never()
    
    let neverSequenceSubscription = neverSequence
        .subscribe { _ in
            print("This will never be printed")
    }
    
    neverSequenceSubscription.disposed(by: disposeBag)
}
/*:
 ----
 ## empty
 Creates an empty `Observable` sequence that only emits a Completed event. [More info](http://reactivex.io/documentation/operators/empty-never-throw.html)
 */
example("empty") {
    //创建一个空的可观察序列，该序列只发出一个已完成的事件
    let disposeBag = DisposeBag()
    
    Observable<Int>.empty()
        .subscribe { event in
            print(event)
        }
        .disposed(by: disposeBag)
}
/*:
 > This example also introduces chaining together creating and subscribing to an `Observable` sequence.
 ----
 ## just
 Creates an `Observable` sequence with a single element. [More info](http://reactivex.io/documentation/operators/just.html)
 */
example("just") {
    //用单个元素创建一个可观察的序列
    let disposeBag = DisposeBag()
    // just:单次
    Observable.just("🔴")
        .subscribe { event in
            print(event)
        }
        .disposed(by: disposeBag)
}
/*:
 ----
 ## of
 Creates an `Observable` sequence with a fixed number of elements.
 */
example("of") {
    let disposeBag = DisposeBag()
    //固定数量元素
    Observable.of("🐶", "🐱", "🐭", "🐹")
        .subscribe(onNext: { element in
            print(element)
        })
        .disposed(by: disposeBag)
}
/*:
 > This example also introduces using the `subscribe(onNext:)` convenience method. Unlike `subscribe(_:)`, which subscribes an _event_ handler for all event types (Next, Error, and Completed), `subscribe(onNext:)` subscribes an _element_ handler that will ignore Error and Completed events and only produce Next event elements. There are also `subscribe(onError:)` and `subscribe(onCompleted:)` convenience methods, should you only want to subscribe to those event types. And there is a `subscribe(onNext:onError:onCompleted:onDisposed:)` method, which allows you to react to one or more event types and when the subscription is terminated for any reason, or disposed, in a single call:
 ```
 someObservable.subscribe(
     onNext: { print("Element:", $0) },
     onError: { print("Error:", $0) },
     onCompleted: { print("Completed") },
     onDisposed: { print("Disposed") }
 )
```
 ----
 ## from
 Creates an `Observable` sequence from a `Sequence`, such as an `Array`, `Dictionary`, or `Set`.
 */
example("from") {
    let disposeBag = DisposeBag()
    // 从集合
    Observable.from(["🐶", "🐱", "🐭", "🐹"])
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 > This example also demonstrates using the default argument name `$0` instead of explicitly naming the argument.
----
 ## create
 Creates a custom `Observable` sequence. [More info](http://reactivex.io/documentation/operators/create.html)
*/
example("create") {
    let disposeBag = DisposeBag()
    //自定义可观察序列
    let myJust = { (element: String) -> Observable<String> in
        //create
        return Observable.create { observer in
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        }
    }
        
    myJust("🔴")
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
/*:
 ----
 ## range
 Creates an `Observable` sequence that emits a range of sequential integers and then terminates. [More info](http://reactivex.io/documentation/operators/range.html)
 */
example("range") {
    let disposeBag = DisposeBag()
    // 范围
    Observable.range(start: 1, count: 10)
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
/*:
 ----
 ## repeatElement
 Creates an `Observable` sequence that emits the given element indefinitely. [More info](http://reactivex.io/documentation/operators/repeat.html)
 */
example("repeatElement") {
    //创建一个可观察的序列，该序列无限地发出给定的元素
    let disposeBag = DisposeBag()
    //指定重复次数
    Observable.repeatElement("🔴")
        .take(3)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 > This example also introduces using the `take` operator to return a specified number of elements from the start of a sequence.
 ----
 ## generate
 Creates an `Observable` sequence that generates values for as long as the provided condition evaluates to `true`.
 */
example("generate") {
    //创建一个可观察的序列，只要提供的条件计算为true，该序列就生成值
    let disposeBag = DisposeBag()
    //生成：初始值，条件 迭代
    Observable.generate(
            initialState: 0,
            condition: { $0 < 3 },
            iterate: { $0 + 1 }
        )
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## deferred
 Creates a new `Observable` sequence for each subscriber. [More info](http://reactivex.io/documentation/operators/defer.html)
 */
example("deferred") {
    //为每个订阅服务器创建一个新的可观察序列
    //deferred：延期
    let disposeBag = DisposeBag()
    var count = 1
    
    let deferredSequence = Observable<String>.deferred {
        print("Creating \(count)")
        count += 1
        
        return Observable.create { observer in
            print("Emitting...")
            observer.onNext("🐶")
            observer.onNext("🐱")
            observer.onNext("🐵")
            return Disposables.create()
        }
    }
    
    deferredSequence
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    
    deferredSequence
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
/*:
 ----
 ## error
 Creates an `Observable` sequence that emits no items and immediately terminates with an error.
 */
example("error") {
    //创建一个可观察的序列，该序列不发出任何项，并立即终止。
    //错误：error
    let disposeBag = DisposeBag()
        
    Observable<Int>.error(TestError.test)
        .subscribe { print($0) }
        .disposed(by: disposeBag)
}
/*:
 ----
 ## doOn
 Invokes a side-effect action for each emitted event and returns (passes through) the original event. [More info](http://reactivex.io/documentation/operators/do.html)
 */
example("doOn") {
    //为每个发出的事件调用一个副作用操作并返回(通过)原始事件
    let disposeBag = DisposeBag()
    
    Observable.of("🍎", "🍐", "🍊", "🍋")
        .do(onNext: { print("Intercepted:", $0) }, afterNext: { print("Intercepted after:", $0) }, onError: { print("Intercepted error:", $0) }, afterError: { print("Intercepted after error:", $0) }, onCompleted: { print("Completed")  }, afterCompleted: { print("After completed")  })
        //订阅
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}
//: > There are also `doOnNext(_:)`, `doOnError(_:)`, and `doOnCompleted(_:)` convenience methods to intercept those specific events, and `doOn(onNext:onError:onCompleted:)` to intercept one or more events in a single call.

//: [Next](@next) - [Table of Contents](Table_of_Contents)
