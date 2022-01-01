import RxSwift
import Foundation

let bag = DisposeBag()

print("------toArray------")
Observable.of(1,2,3,4)
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: bag)

print("------map1------")
Observable.range(start: 1, count: 3)
    .map { $0 * $0 }
    .subscribe(onNext: {
        print($0, terminator: " ")
    })
    .disposed(by: bag)

print()
print("------map2------")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
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

print("------materialize------")
/*
 Observable을 Observable의 이벤트로 변환을 해야할 때 사용함
 외부적으로 Observable이 종료되는 것을 방지하기 위해
*/
enum Foul: Error {
    case falseStart
}

struct Runner {
    var score: BehaviorSubject<Int>
}

let Loki = Runner(score: BehaviorSubject<Int>(value: 0))
let Thor = Runner(score: BehaviorSubject<Int>(value: 1))

let m100 = BehaviorSubject<Runner>(value: Loki)

m100
    .flatMapLatest {
        $0.score.materialize()
    }
    .filter {
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

Loki.score.onNext(1)
Loki.score.onError(Foul.falseStart)
Loki.score.onNext(2)

m100.onNext(Thor)

print("------전화번호 11자리 받기 예제------")
let input = PublishSubject<Int?>()
let list: [Int] = [1]

input
    .flatMap {
        $0 == nil
            ? Observable.empty()
            : Observable.just($0)
    }
    .map { $0! }
    .skip(while: { $0 != 0 })
    .take(11)
    .toArray()
    .asObservable()
    .map {
        $0.map { "\($0)" }
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3)
        numberList.insert("-", at: 8)
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: bag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(1)

