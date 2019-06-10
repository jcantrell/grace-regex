class pattern(pattern) {
    def nullNFAState = object {
        def value is public = "nullDFAState"
        method ==(other) {
            value == other.value
        }
        method ≠(other) {
            value ≠ other.value
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

    def RegexParser = object {
        var tokenList := list [ ]
        var infix := pattern
        
        def grammar = object {
            method Frag_special {
                def specials = list [ "[", "]", "(", ")" ]
                var frag := Frag_gobbleOneOf(specials)
                if (nullNFAFragment ≠ frag) then {return frag}
                frag := Frag_operator
                if (nullNFAFragment ≠ frag) then {return frag}
                return nullNFAFragment
            }
            method Frag_meta {
                var frag := Frag_operator
                if (nullNFAFragment ≠ frag) then {return frag}
                if (gobble("\t")) then {
                    return NFAFragment( NFAState("\t", nullNFAState, nullNFAState, 0) )
                }
                if (gobble("\n")) then {
                    return NFAFragment( NFAState("\n", nullNFAState, nullNFAState, 0) )
                }
                frag := Frag_special
                if (nullNFAFragment ≠ frag) then {return frag}
                return nullNFAFragment
            }
            method Frag_symbol {
                def symbolChars = list [
                    "!","\"","#","$","%","&","'",",","-",".",
                    "/",":",";","<","=",">","@","^","_","`",
                    "{","}","~"
                ]
                return Frag_gobbleOneOf(symbolChars)
            }
            method Frag_digit {
                def digitChars = list [
                    "0","1","2","3","4","5","6","7","8","9"
                ]
                return Frag_gobbleOneOf(digitChars)
            }
            method Frag_upper {
                def capitalChars = list [
                    "A","B","C","D","E","F","G","H","I","J","K","L","M","N",
                    "O","P","Q","R","S","T","U","V","W","X","Y","Z"
                ]
                return Frag_gobbleOneOf(capitalChars)
            }
            method Frag_lower {
                def lowerCase = list [
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n",
                    "o","p","q","r","s","t","u","v","w","x","y","z"
                ]
                return Frag_gobbleOneOf(lowerCase)
            }
            method Frag_operator {
                def ops = list [ "*", "+", "?", "|" ]
                return Frag_gobbleOneOf(ops)
            }
            method Frag_nonMeta {
                var frag := Frag_digit
                if (nullNFAFragment ≠ frag) then {return frag}
                frag := Frag_upper
                if (nullNFAFragment ≠ frag) then {return frag}
                frag := Frag_lower
                if (nullNFAFragment ≠ frag) then {return frag}
                frag := Frag_symbol
                if (nullNFAFragment ≠ frag) then {return frag}
                return nullNFAFragment
            }
            method Frag_character {
                var frag := Frag_nonMeta
                if (nullNFAFragment ≠ frag) then {return frag}
                if (gobble("\\")) then {
                    frag := Frag_meta
                    if (nullNFAFragment ≠ frag) then {
                        return frag
                    }
                }
                return nullNFAFragment
            }
            method Frag_elementary {
                var frag := Frag_group
                if (nullNFAFragment ≠ frag) then {return frag}
                frag := Frag_character
                if (nullNFAFragment ≠ frag) then {return frag}
                return nullNFAFragment
            }
            method Frag_basic {
                var frag := Frag_elementary
                if (nullNFAFragment ≠ frag) then {
                    if (gobble("+")) then {
                        var s := NFAState("split", frag.start, nullNFAState,0)
                        frag.patch(s)
                        return NFAFragment(frag.start) with (list[s])
                    } elseif {gobble("*")} then {
                        var s := NFAState("split", frag.start, nullNFAState,1)
                        frag.patch(s)
                        return NFAFragment(s) with (list[s])
                    } elseif {gobble("?")} then {
                        var s := NFAState("split", frag.start, nullNFAState,2)
                        return NFAFragment(s) with (frag.leaves++list[s])
                    }
                    return frag
                }
                return nullNFAFragment
            }
            method Frag_concatenation {
                var frag := Frag_basic
                if (nullNFAFragment ≠ frag) then {
                    var frag2 := Frag_concatenation
                    if (nullNFAFragment ≠ frag2) then {
                        frag.patch(frag2.start)
                        return NFAFragment(frag.start) with (frag2.leaves)
                    }
                    return frag
                }
                return nullNFAFragment
            }
            method Frag_alternation {
                var frag := Frag_concatenation
                if (nullNFAFragment ≠ frag) then {
                    if (gobble("|")) then {
                        var frag2 := Frag_alternation
                        var s := NFAState( "split", frag.start, frag2.start, 0)
                        return NFAFragment(s) with (frag.leaves ++ frag2.leaves)
                    }
                    return frag
                }
                return nullNFAFragment
            }
            method Frag_group {
                if (gobble("(")) then {
                    var frag := Frag_alternation
                    if (nullNFAFragment ≠ frag) then {
                        if (gobble(")")) then {
                            return frag
                        }
                    }
                }
                return nullNFAFragment
            }
    
            method Frag_gobbleOneOf(setIn) {
                var gobbled := false
                var frag := nullNFAFragment
                while {!gobbled && setIn.isEmpty.not} do {
                    var currentChar := setIn.removeFirst
                    if (gobble(currentChar)) then {
                        gobbled := true
                        frag := NFAFragment( NFAState( currentChar, nullNFAState, nullNFAState, 0))
                    }
                }
                return frag
            }
            method gobble(charin) {
                if (infix.startsWith(charin)) then {
                    infix := infix.substringFrom 2
                    return true
                }
                return false
            }
        
        }
    
        method asString {
            tokenList.asString
        }
            
        method parsedResult {
            var mynfa := grammar.Frag_alternation
            var s := NFAState( "match", nullNFAState, nullNFAState, 3 )
            if (nullNFAFragment ≠ mynfa) then {
                mynfa.patch(s)
            } else {
                mynfa := NFAFragment( s )
            }
            mynfa.start
        }
        
        def nullNFAFragment = object {
            var start is public := nullNFAState
            method ==(other) {
                nullNFAState == other.start
            }
            method ≠(other) {
                nullNFAState ≠ other.start
            }
        }
        method NFAFragment( start_in) with ( leaves_in ) is confidential {
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
                method asDebugString {
                    "Frag: start: {start.asDebugString}, leaves: {leaves}"
                }
            }
        }
        
        method NFAFragment( start_in ) is confidential {
            NFAFragment( start_in ) with ( list[start_in] )
        }
    }

    class DFAState( NFAstates_in ) {
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

    method matches( text ) {
        var nfa := RegexParser.parsedResult
        var currentState := DFAState( list [ nfa ] )
        text.do { c → currentState := currentState.step(c) }
        currentState.isMatch
    }

    method asDebugString { RegexParser.asString }
}
