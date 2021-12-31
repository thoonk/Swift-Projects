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
let leftSubject = PublishSubject<Int>()
let rightSubject = PublishSubject<String>()

Observable.combineLatest(leftSubject, rightSubject) {
    "\($0)+\($1)"
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: bag)

leftSubject.onNext(1)
rightSubject.onNext("A")
leftSubject.onNext(2)
rightSubject.onNext("B")
rightSubject.onNext("C")
rightSubject.onNext("D")
leftSubject.onNext(3)
leftSubject.onNext(4)

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

print("------withLatestFrom------")
let button1 = PublishSubject<Void>()
let textField1 = PublishSubject<String>()

button1.withLatestFrom(textField1)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

textField1.onNext("H")
textField1.onNext("Her")
textField1.onNext("Here")
button1.onNext(())
button1.onNext(())

print("------sample------")
let button2 = PublishSubject<Void>()
let textField2 = PublishSubject<String>()

textField2.sample(button2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

textField2.onNext("I")
textField2.onNext("I am")
button2.onNext(())
button2.onNext(())

print("------amb------")
let firstSubject = PublishSubject<Int>()
let secondSubject = PublishSubject<Int>()

firstSubject.amb(secondSubject)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

firstSubject.onNext(1)
secondSubject.onNext(20)
firstSubject.onNext(2)
secondSubject.onNext(40)
firstSubject.onNext(3)
secondSubject.onNext(60)

print("------switchLatest------")
let one = PublishSubject<String>()
let two = PublishSubject<String>()
let source = PublishSubject<Observable<String>>()

source
    .switchLatest()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

source.onNext(one)
one.onNext("This is one.")
one.onNext("is This one?")
source.onNext(two)
two.onNext("This is two.")
two.onNext("is This two?")
source.onNext(one)
one.onNext("This is one.")

print("------reduce------")
Observable.of(1, 2, 3, 4, 5)
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------scan------")
let nums = Observable.of(1, 2, 3, 4, 5)
let scan = nums.scan(0, accumulator: +)

Observable.zip(nums, scan) {
     "nums: \($0), scan: \($1)"
}
.subscribe(onNext: {
    print($0)
})
.disposed(by: bag)
