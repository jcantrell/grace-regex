class pattern (intext) {

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
        var outlist := list [ ]
        print "after opstack loop"
        while { outqueue.isEmpty.not } do {
            outlist.add( outqueue.pop )
        }
        outlist
    }

    def nullNFAState = object {
        def value is public = "nullDFAState"
        method ==(other) {
            value == other.value
        }
        method asDebugString { "{value}" }
        method step(character) {
            list [ ]
        }
        method num { -1 }
    }

    method NFAState( value_in, out1_in, out2_in, num_in ) {
        object {
            var value is public := value_in
            var out1 is public := out1_in
            var out2 is public := out2_in
            var num is public := num_in
        
            method patch( stateIn ) {
                if ( nullNFAState == out1 ) then {
                    out1 := stateIn
                }
                if ( (nullNFAState == out2) && (value == "split")) then {
                    out2 := stateIn
                }
            }
        
            method isLeaf {
                (nullNFAState == out1) || (nullNFAState == out2)
            }
            method debugOutlist {
                list [ out1, out2 ]
            }
        
            method asDebugString {
                "{value}, {num}"
            }
        
            method isMatch {
                value == "match"
            }
        
            method step(character) {
                var returnList := list [ ]
                if (value == "match") then { 
                    returnList := list [ ] 
                } elseif {value == "split"} then {
                    returnList := out1.step(character) ++ out2.step(character)
                } elseif{value == character} then {
                    returnList := addState( out1 )
                } else {
                    returnList := list [ ]
                }
                returnList
            }
        
            method addState(state) {
                var returnList := list [ ]
                if (state.value == "split") then {
                    returnList := addState(state.out1) ++ addState(state.out2)
                } elseif {state.value == "match"} then {
                    returnList := list [ state ]
                } else {
                    returnList := list [ state ]
                }
                returnList
            }
        }
    }

    method Fragment( start_in, leaves_in ) {
        object {
            var start is public := start_in
            var leaves is public := leaves_in
        
            method patch( stateIn ) {
                var workingList := list [ ]
                while { leaves.isEmpty.not } do {
                    var item := leaves.removeLast
                    item.patch( stateIn )
                    if (item.isLeaf) then { workingList.add(item) }
                }
                leaves := workingList
            }
            method combin( otherFrag ) {
                leaves := otherFrag.leaves
            }
        }
    }

    method post2nfa( postfix ) {
        var fragstack := stack( list[] )
        var stateNum := 1
        postfix.do { i →
            if { i == "." } then {
                var e2 := fragstack.pop
                var e1 := fragstack.pop
                e1.patch( e2.start )
                fragstack.push( Fragment( e1.start, e2.leaves ) )
            } elseif {i == "|"} then {
                var e2 := fragstack.pop
                var e1 := fragstack.pop
                var s := NFAState( "split", e1.start, e2.start, stateNum )
                stateNum := stateNum + 1
                fragstack.push( Fragment( s, e1.leaves ++ e2.leaves ) )
            } elseif {i == "?"} then {
                var e := fragstack.pop
                var s := NFAState( "split", e.start, nullNFAState, stateNum )
                stateNum := stateNum + 1
                fragstack.push( Fragment( s, e.leaves ++ list[ s ] ) )
            } elseif {i == "*"} then {
                var e := fragstack.pop
                var s := NFAState( "split", e.start, nullNFAState, stateNum )
                stateNum := stateNum + 1
                e.patch(s)
                fragstack.push( Fragment( s, list [ s ] ) )
                //fragstack.push( Fragment( s, e.leaves ) )
            } elseif {i == "+"} then {
                var e := fragstack.pop
                var s := NFAState( "split", e.start, nullNFAState, stateNum )
                stateNum := stateNum + 1
                e.patch(s)
                fragstack.push( Fragment(e.start, list[ s ] ) )
            } else {
                var s := NFAState( i, nullNFAState, nullNFAState, stateNum )
                stateNum := stateNum + 1
                fragstack.push( Fragment(s, list[ s ] ) )
            }
        }
        var e := fragstack.pop
        var s := NFAState( "match", nullNFAState, nullNFAState, stateNum )
        e.patch( s )
        e.start
    }

    method DFAState( NFAstates_in ) {
        object {
            var NFAstates := list [ ]
            NFAstates_in.do { n →
                NFAstates := NFAstates ++ n.addState(n)
            }
            
            method isMatch {
                var flag := false
                NFAstates.do { x → flag := flag || x.isMatch }
                flag
            }
        
            method step(character) {
                var newList := list [ ]
                NFAstates.do { s →
                    newList := newList ++ s.step(character)
                }
                DFAState(newList)
            }
        
            method asDebugString {
                var retStr := "beginDFAasDebugString "
                NFAstates.do { x →
                    retStr := retStr ++ "{x.asDebugString}"
                }
                retStr ++ " endDFAasDebugString"
            }
        
            method debugWalk {
                print "DEBUG: DFA walk"
                var workingList := NFAstates_in.copy
                var visited := list [ ]
                var added := true
                while { workingList.isEmpty.not} do {
                    print "DEBUG: begin loop"
                    workingList.do { x → print "starting list: {x.num}" }
                    added := false
                    if ( workingList.isEmpty.not) then {
                        var item := workingList.removeLast
                        //print "checking: {item.num}, {item.value}, connected to {item.out1.asDebugString} and {item.out2.asDebugString}"
                        var vis := false
                        visited.do { v → vis := vis || (v.num == item.num) }
                        print "was visited: {vis}"
                        if (!vis && !(nullNFAState == item)) then {
                            visited.add( item )
                        
                            if ( !(nullNFAState == item.out1) ) then {
                                vis := false
                                visited.do { v → vis := vis || (v.num == item.out2.num) }
                                workingList.add( item.out1 )
                            }
                        
                            if ( !(nullNFAState == item.out2) ) then {
                                vis := false
                                visited.do { v → vis := vis || (v.num == item.out2.num) }
                                workingList.add( item.out2 )
                            }
                        
                            workingList.do { x → print "adding to list: {x.num}" }
                            added := true
                        }
                    }
                } 
            
                visited.do { v →
                    print "I am {v.num}, {v.value}, connected to {v.out1.asDebugString} and {v.out2.asDebugString}"
                }
            }
        }
    }
    
    method matches( text ) {
        var currentState := DFAState( list [ nfa ] )
        text.do { c → currentState := currentState.step(c) }
        currentState.isMatch
    }
    
    var postfix := infix2postfix(intext)
    var nfa := post2nfa(postfix)
}

//def patt="ab|cd*"
//def patt2="a(bb)+a"
//
//var postfix := infix2postfix(patt)
//print "DEBUG: postfix: {postfix.asString}"
//print "DEBUG: building NFA"
//var nfa := post2nfa(postfix)
//print "DEBUG: building DFA"
//
//var currentState := DFAState( list[ nfa ] )
//print "DEBUG: walking DFA"
//
//currentState.debugWalk
//print "DEBUG: end walk"
//var text1 := "c"
//
//currentState := currentState.step("c")
//currentState := currentState.step("d")
//currentState := currentState.step("d")
//
//if { currentState.isMatch } then {
//    print "match!"
//} else {
//    print "not match!"
//}

