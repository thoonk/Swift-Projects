import RxSwift

let bag = DisposeBag() 

print("------startWith------")
Observable.of(2, 3)
    .startWith(1)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------concat------")
let firstObservables = Observable.of(1, 1, 1)
let secondObservables = Observable.of(2, 2)

firstObservables
    .concat(secondObservables)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------concatMap------")
let sequences = ["Number": Observable.of("1", "2", "3"),
                 "Alphabet": Observable.of("A", "B", "C")]

Observable.of("Number", "Alphabet")
    .concatMap({
        sequences[$0] ?? .empty()
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------merge------")
let odds = Observable.of(1, 3, 5, 7)
let evens = Observable.of(2, 4, 6)
let c = Observable.of("c", "c")

Observable.merge(odds, evens)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------combineLatest------")
let left = PublishSubject<Int>()
let right = PublishSubject<String>()

Observable.combineLatest(left, right) {
    "\($0)+\($1)"
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: bag)

left.onNext(1)
right.onNext("A")
left.onNext(2)
right.onNext("B")
right.onNext("C")
right.onNext("D")
left.onNext(3)
left.onNext(4)

print("------zip------")
let left = Observable.of(1, 2, 3, 4)
let right = Observable.of("A", "B", "C", "D")

Observable.zip(left, right) {
    "\($0)+\($1)"
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: bag)
