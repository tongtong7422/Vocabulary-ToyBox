var a:String = "a"
var b:Character = "b"
var i:String.Index = a.startIndex

var list:[String] = []
list.append(a)
a.insert(b, atIndex: i)

a
list
