// 再利用可能なひとまとまりの処理。今定義している変数を、後で使えるのがイイ
// スコープ内の変数や定数を保持したひとまとまりの処理
// 戻り値の型と文は in キーワードで区切る
// 外部引数名 ☓
// デフォルト引数 ☓

let double = { (x: Int) -> Int in
    // クロージャの実行時に実行される文
    x * 2
}
double(2)

// 実行方法は、クロージャが代入されている変数名の松尾に()をつける
// JS で言う　無形関数

let lengthOfString = { (string: String) -> Int in
    return string.count
}

lengthOfString("abcd")

// 簡略引数
let isEqual: (Int, Int) -> Bool = {
    return $0 == $1
}

isEqual(1, 1)

// Swift では () と Void型は同じだが
// () -> Void と記述する

// クロージャによる変数と定数のキャプチャ
//let counter: () -> Int
//do {
//    var count = 0
//    counter = {
//        count += 1
//        return count
//    }
//}
//
//counter()
//counter()

// 非同期に実行されるクロージャ escaping属性
// クロージャ実行時にローカルスコープ外の変数や定数を利用できることをキャプチャと言う
// クロージャが関数のスコープ外で保持される可能性がある場合、@escaping属性をつける

var queue = [() -> Void]()

func enqueue(operation: @escaping () -> Void) {
    queue.append(operation)
}

enqueue {
    print("aaaa")
}
queue
queue.forEach { $0()}

// autoclosure属性
// 引数をクロージャで包むことで遅延評価を実現
// 結果として、関数外からは簡単に利用でき、関数内では遅延評価を行える

func or(_ lhs: Bool, _ rhs: @autoclosure () -> Bool) -> Bool {
    if lhs {
        print("true")
        return true
    } else {
        let rhs = rhs()
        print(rhs)
        return rhs
    }
}

func lhs() -> Bool {
    print("lhs")
    return true
}

func rhs() -> Bool {
    print("rhs")
    return false
}

or(lhs(), rhs())
