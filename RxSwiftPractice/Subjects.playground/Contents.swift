import RxSwift

let bag = DisposeBag()

print("------PublishSubject------")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("first")

let subscriber1 = publishSubject
    .subscribe(onNext: {
        print($0)
    })

publishSubject.onNext("second")
publishSubject.onNext("third")

subscriber1.dispose()

let subscriber2 = publishSubject
    .subscribe(onNext: {
        print($0)
    })

publishSubject.onNext("fourth")
publishSubject.onCompleted()

publishSubject.onNext("fifth")
subscriber2.dispose()

let subscriber3 = publishSubject
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

publishSubject.onNext("sixth")

print("------PublishSubject------")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "init")

behaviorSubject.onNext("first")

behaviorSubject.subscribe {
    print("first subscribe:", $0.element ?? $0)
}
.disposed(by: bag)

//behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("second subscribe:", $0.element ?? $0)
}
.disposed(by: bag)

let value = try? behaviorSubject.value()
print(value)

print("------ReplaySubject------")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("first")
replaySubject.onNext("second")
replaySubject.onNext("third")

replaySubject.subscribe {
    print("first subscribe:", $0.element ?? $0)
}
.disposed(by: bag)

replaySubject.subscribe {
    print("second subscribe:", $0.element ?? $0)
}
.disposed(by: bag)

replaySubject.onNext("fourth")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("third subscribe:", $0.element ?? $0)
}
.disposed(by: bag)
