import RxSwift
import Foundation

let bag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("------Single1------")
Single<String>.just("🙄")
    .subscribe (
        onSuccess: {
            print($0)
        }, onFailure: {
            print("error: \($0.localizedDescription)")
        }, onDisposed: {
            print("disposed")
        })
    .disposed(by: bag)

print("------Single2------")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.single)
    return Disposables.create()
}
    .asSingle()
    .subscribe (
        onSuccess: {
            print($0)
        }, onFailure: {
            print("error: \($0.localizedDescription)")
        }, onDisposed: {
            print("disposed")
        })
    .disposed(by: bag)

struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name": "tae"}
"""

let json2 = """
    {"myname": "hoon"}
"""

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {
                  observer(.failure(JSONError.decodingError))
                  return Disposables.create()
              }
        
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let err):
            print(err)
        }
    }
    .disposed(by: bag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let err):
            print(err)
        }
    }
    .disposed(by: bag)

print("------Maybe1------")
Maybe<String>.just("😬")
    .subscribe (
        onSuccess: {
            print($0)
        }, onError: {
            print("error: \($0.localizedDescription)")
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
    .disposed(by: bag)

print("------Maybe2------")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe (
    onSuccess: {
        print($0)
    }, onError: {
        print("error: \($0.localizedDescription)")
    }, onCompleted: {
        print("completed")
    }, onDisposed: {
        print("disposed")
    })
.disposed(by: bag)

print("------Completable1------")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe {
    print("completed")
} onError: {
    print("error: \($0.localizedDescription)")
} onDisposed: {
    print("disposed")
}

print("------Completable2------")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe {
    print("completed")
} onError: {
    print("error: \($0.localizedDescription)")
} onDisposed: {
    print("disposed")
}
