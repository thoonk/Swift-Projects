import UIKit
import RxSwift
import RxCocoa
import Foundation
import PlaygroundSupport

let bag = DisposeBag()

print("------replay------")
let greetings = PublishSubject<String>()
let replayGreetings = greetings.replay(2)
replayGreetings.connect()

greetings.onNext("1. hello")
greetings.onNext("2. hi")
greetings.onNext("3. welcome")

replayGreetings
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

// 구독 시점 이후에 발생한 이벤트이기 때문에 버퍼와 상관없이 방출됨
greetings.onNext("4. What's up?")

print("------replayAll------")
let doctorStrange = PublishSubject<String>()
let timeStone = doctorStrange.replayAll()
timeStone.connect()

doctorStrange.onNext("Dormammu")
doctorStrange.onNext("I've come to bargain.")
doctorStrange.onNext("Dormammu")
doctorStrange.onNext("I've come to bargain.")

timeStone
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------buffer------")
// buffer는 array를 방출
//let source = PublishSubject<String>()
//var count = 0
//let timer = DispatchSource.makeTimerSource()
//
//timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
//timer.setEventHandler {
//    count += 1
//    source.onNext("\(count)")
//}
//
//timer.resume()
//
//source
//    .buffer(
//        timeSpan: .seconds(2),
//        count: 2,
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: bag)

print("------window------")
// window는 observable을 방출
//let maxObservableCnt = 3
//let makeTime = RxTimeInterval.seconds(2)
//
//let window = PublishSubject<String>()
//
//var windowCnt = 0
//let windowTimerSource = DispatchSource.makeTimerSource()
//windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimerSource.setEventHandler {
//    windowCnt += 1
//    window.onNext("\(windowCnt)")
//}
//windowTimerSource.resume()
//
//window
//    .window(
//        timeSpan: makeTime,
//        count: maxObservableCnt,
//        scheduler: MainScheduler.instance
//    )
//    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
//        windowObservable.enumerated()
//    }
//    .subscribe(onNext: {
//        print("\($0.index)번째 Observable 요소 \($0.element)")
//    })
//    .disposed(by: bag)

print("------delaySubscription------")
// 구독 시점을 뒤로 미룸
//let delaySource = PublishSubject<String>()
//
//var delayCnt = 0
//let delayTimerSource = DispatchSource.makeTimerSource()
//delayTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//delayTimerSource.setEventHandler {
//    delayCnt += 1
//    delaySource.onNext("\(delayCnt)")
//}
//delayTimerSource.resume()
//
//delaySource
//    .delaySubscription(.seconds(5), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: bag)

print("------delay------")
// 시퀀스 자체를 뒤로 미룸
//let delaySubject = PublishSubject<Int>()
//
//var delayCnt = 0
//let delayTimerSource = DispatchSource.makeTimerSource()
//delayTimerSource.schedule(deadline: .now(), repeating: .seconds(1))
//delayTimerSource.setEventHandler {
//    delayCnt += 1
//    delaySubject.onNext(delayCnt)
//}
//delayTimerSource.resume()
//
//delaySubject
//    .delay(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: bag)

print("------interval------")
//Observable<Int>
//    .interval(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: bag)

print("------timer------")
//Observable<Int>
//    .timer(
//        .seconds(5),
//        period: .seconds(2),
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: bag)

print("------timeout------")
// 설정된 시간을 초과하면 에러 방출
let button = UIButton(type: .system)
button.setTitle("눌러주세요", for: .normal)
button.sizeToFit()

PlaygroundPage.current.liveView = button

button.rx.tap
    .do(onNext: {
        print("tapped")
    })
    .timeout(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)
