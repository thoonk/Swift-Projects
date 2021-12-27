import RxSwift

let bag = DisposeBag()

print("------toArray------")
Observable.of(1,2,3,4)
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: bag)

print("------map------")
Observable.range(start: 1, count: 3)
    .map { $0 * $0 }
    .subscribe(onNext: {
        print($0, terminator: " ")
    })
    .disposed(by: bag)

print()
print("------enumerated------")
Observable.of(1,2,3,4,5)
    .enumerated()
    .map { index, value in
        if index > 2 {
            return 2 * value
        } else {
            return value
        }
    }
    .subscribe(onNext: {
        print($0, terminator: " ")
    })
    .disposed(by: bag)

print()
print("------flatMap------")
let sequenceInt = Observable.range(start: 1, count: 3)
let sequenceAlpha = Observable.of("A", "B", "C")

sequenceInt
    .flatMap { (n: Int) -> Observable<String> in
        return sequenceAlpha.map { "\(n): \($0)"}
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------flatMapFirst------")
sequenceInt
    .flatMapFirst{ (n: Int) -> Observable<String> in
        return sequenceAlpha.map { "\(n): \($0)" }
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

print("------flatMapLatest------")
sequenceInt
    .flatMapLatest { (n: Int) -> Observable<String> in
        return sequenceAlpha.map { "\(n): \($0)" }
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

