import RxSwift

let bag = DisposeBag()

print("------ignoreElements------")
Observable.of(1, 2, 3)
    .ignoreElements()
    .subscribe(onNext: {
        print($0)
    }, onCompleted: {
        print("completed")
    })
    .disposed(by: bag)

print("------elementAt------")
let alert = PublishSubject<String>()
alert
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

alert.onNext("🚨")
alert.onNext("🚨")
alert.onNext("🚨")

print("------filter------")
Observable.of(1, 2, 3, 4, 5)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------skip------")
Observable.of(1, 2, 3, 4, 5, 6)
    .skip(3)
    .subscribe(onNext: { num in
        print(num)
    })
    .disposed(by: bag)

print("------skipWhile------")
Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
    .skip(while: { $0 != 5 })
    .subscribe(onNext: { num in
        print(num)
    })
    .disposed(by: bag)

print("------skipUntil------")
let subject = PublishSubject<Int>()
let trigger = PublishSubject<Void>()
subject
    .skip(until: trigger)
    .subscribe(onNext: { print($0) })
    .disposed(by: bag)

subject.onNext(1)
subject.onNext(2)
trigger.onNext(())
subject.onNext(3)

print("------take------")
Observable.of(1,2,3,4,5)
    .take(3)
    .subscribe(onNext: {
        print($0, terminator: " ")
    })
    .disposed(by: bag)

print()
print("------takeWhile------")
Observable.of(1,3,5,7,9)
    .enumerated()
    .take(while: { $0.index < 4 && $0.element % 2 == 1 })
    .subscribe(onNext: {
        print($0.element, terminator: " ")
    })
    .disposed(by: bag)

print()
print("------takeUntil------")
let countDown = 10
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .map { countDown - $0 }
        .take(until: { $0 == 0 }, behavior: .inclusive)
        .subscribe(onNext: {
            print($0)
        }, onCompleted: {
                print("completed")
        })
        .disposed(by: bag)

print("------DistinctUntilChanged------")
Observable.of(1,1,2,2,1,1)
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0, terminator: " ")
        })
        .disposed(by: bag)
