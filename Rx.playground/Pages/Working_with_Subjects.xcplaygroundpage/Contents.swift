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
 # Working with Subjects
 A Subject is a sort of bridge or proxy that is available in some implementations of Rx that acts as both an observer and `Observable`. Because it is an observer, it can subscribe to one or more `Observable`s, and because it is an `Observable`, it can pass through the items it observes by reemitting them, and it can also emit new items. [More info](http://reactivex.io/documentation/subject.html)
*/
extension ObservableType {
    
    /**
     Add observer with `id` and print each emitted event.
     - parameter id: an identifier for the subscription.
     */
    func addObserver(_ id: String) -> Disposable {
        return subscribe { print("Subscription:", id, "Event:", $0) }
    }
    
}

func writeSequenceToConsole<Source: ObservableType>(name: String, sequence: Source) -> Disposable {
    return sequence.subscribe { event in
        print("Subscription: \(name), event: \(event)")
    }
}
/*:
 ## PublishSubject
 Broadcasts new events to all observers as of their time of the subscription.
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/publishsubject.png "PublishSubject")
 */
example("PublishSubject") {
    //Publish：发布。在订阅时向所有观察员广播新事件
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    //观察
    subject.addObserver("1").disposed(by: disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.addObserver("2").disposed(by: disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
}
/*:
 > This example also introduces using the `onNext(_:)` convenience method, equivalent to `on(.next(_:)`, which causes a new Next event to be emitted to subscribers with the provided `element`. There are also `onError(_:)` and `onCompleted()` convenience methods, equivalent to `on(.error(_:))` and `on(.completed)`, respectively.
 ----
 ## ReplaySubject
 Broadcasts new events to all subscribers, and the specified `bufferSize` number of previous events to new subscribers.
 ![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/replaysubject.png)
*/
example("ReplaySubject") {
    //将新事件广播给所有订阅者，并将先前事件的指定缓冲大小号广播给新订阅者。
    //bufferSize:缓存一个给"2"
    let disposeBag = DisposeBag()
    let subject = ReplaySubject<String>.create(bufferSize: 1)
    
    subject.addObserver("1").disposed(by: disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    
    subject.addObserver("2").disposed(by: disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
}
/*:
 ----
## BehaviorSubject
Broadcasts new events to all subscribers, and the most recent (or initial) value to new subscribers.
![](https://raw.githubusercontent.com/kzaher/rxswiftcontent/master/MarbleDiagrams/png/behaviorsubject.png)
*/
example("BehaviorSubject") {
    //向所有订阅者广播新事件，并向新订阅者广播最近的(或初始的)值。
    //Behavior:行为
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject(value: "🔴")
    
    subject.addObserver("1").disposed(by: disposeBag)
    subject.onNext("🐶")
    subject.onNext("🐱")
    //2最近的是🐱
    subject.addObserver("2").disposed(by: disposeBag)
    subject.onNext("🅰️")
    subject.onNext("🅱️")
    //"3"最近的是"B"
    subject.addObserver("3").disposed(by: disposeBag)
    subject.onNext("🍐")
    subject.onNext("🍊")
}
/*:
 > Notice what's missing in these previous examples? A Completed event. `PublishSubject`, `ReplaySubject`, and `BehaviorSubject` do not automatically emit Completed events when they are about to be disposed of.
*/

//: [Next](@next) - [Table of Contents](Table_of_Contents)
