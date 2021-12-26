
import RxSwift

print("------just------")
Observable.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("------of1------")
Observable.of(1,2,3,4,5)
    .subscribe(onNext: {
        print($0)
    })

print("------of2------")
Observable.of([1,2,3,4,5])
    .subscribe(onNext: {
        print($0)
    })

print("------from------")
Observable.from([1,2,3,4,5])
    .subscribe(onNext: {
        print($0)
    })

print("------subscribe------")
Observable.of(1,2,3)
    .subscribe {
        print($0)
    }

print("------subscribe------")
Observable.of(1,2,3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

print("------subscribe------")
Observable.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    })

print("------empty------")
Observable<Void>.empty()
    .subscribe {
        print($0)
    }

print("------never------")
Observable<Void>.never()
    .debug("never")
    .subscribe {
        print($0)
    }

print("------range------")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2*\($0)=\(2*$0)")
    })

print("------dispose------")
Observable.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    })
    .dispose()

print("------disposeBag------")
let bag = DisposeBag()
Observable.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------create1------")
Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: bag)

print("------create2------")
enum MyError: Error {
    case anError
}

Observable.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe {
    print($0)
} onError: {
    print($0.localizedDescription)
} onCompleted: {
    print("completed")
} onDisposed: {
    print("disposed")
}
.disposed(by: bag)

print("------deferred1------")
Observable.deferred {
    Observable.of(1,2,3)
}
.subscribe {
    print($0)
}
.disposed(by: bag)

print("------deferred2------")
var isFlipOver = false

let factory: Observable<String> = Observable.deferred {
    isFlipOver = !isFlipOver
    
    if isFlipOver {
        return Observable.of("👍")
    } else {
        return Observable.of("👎")
    }
}

for _ in 0...3 {
    factory.subscribe(onNext: {
        print($0)
    })
        .disposed(by: bag)
}
