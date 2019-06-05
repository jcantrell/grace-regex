def patt="ab|cd*"
def mat1="cd"
def mat2="c"
def mat3="ab"
def mat4="cdd"
def nmt1="e"

def patt2="a(bb)+a"

var operators := list[ ".", "|", "*", "+", "("]
var precedences := list [ 2, 1, 3, 3, 4 ]

method operand(c) {
    operators.contains(c).not && (c ≠ "(") && (c ≠ ")")
}

method prec(op) {
    var out := -1
    if { op=="." } then { out := precedences.at 1 }
    if { op=="|" } then { out := precedences.at 2 }
    if { op=="*" } then { out := precedences.at 3 }
    if { op=="+" } then { out := precedences.at 4 }
    if { op=="(" } then { out := precedences.at 5 }
    out
}

method stack( initlist ) {
    object {
        var ourlist := initlist
    
        method push( in ) {
            ourlist.add(in)
        }
    
        method pop {
            ourlist.removeLast
        }
    
        method peek {
            var item := pop
            push(item)
            item
        }
    
        method isEmpty {
            ourlist.isEmpty
        }
        method asString {
            ourlist.asString
        }
    }
}

method queue( initlist ) {
    object {
        var ourlist := initlist
        
        method push( in ) {
            ourlist.add( in )
        }
        method pop {
            ourlist.removeFirst
        }
        method peek {
            var item := pop
            ourlist.addFirst(item)
            item
        }
        method isEmpty {
            ourlist.isEmpty
        }
        method asString {
            ourlist.asString
        }
    }
}

method infix2postfix(text) {
    var outqueue := queue( list[] )
    object {
        var opstack := stack( list [] )
        var explicit := explicitCatenation(text)
        explicit.do { t → evaluateCharacter(t) }
        while { opstack.isEmpty.not } do {
            outqueue.push( opstack.pop )
        }
    
        method explicitCatenation(infix) {
            if (infix.size < 2) then {
                return infix
            }
            
            var insertCat := false
            var out := list [ ]
            infix.do { i →
                if { insertCat && ( operand(i) || (i=="(") ) } then {
                    out.push(".")
                }
                out.push(i)
                insertCat := ( operand(i) || (i==")") || ((prec(i) > prec(".")) && ((i=="*") || (i=="+")) ) )
            }
            out
        }
        method evaluateCharacter( c ) {
            var stackTop := ""
            if (opstack.isEmpty.not) then { stackTop := opstack.peek }
            
            if { operators.contains(c).not && (c ≠ ")") } then { 
                outqueue.push(c);
            } elseif { (c == ")") && opstack.isEmpty.not && (stackTop == "(") } then {
                opstack.pop
            } elseif { (opstack.isEmpty.not) && (stackTop ≠ "(") && ((c==")") || (prec(stackTop) ≥ prec(c))) } then {
                outqueue.push( opstack.pop )
                evaluateCharacter(c)
            } else {
                opstack.push(c)
            }
        }
    }
    outqueue
}

var myout
myout := infix2postfix(patt)
print "DEBUG: NOW SECOND PATTHERN"
infix2postfix(patt2)
print "DEBUG: END"
print "DEBUG: myout: {myout.asString}"
