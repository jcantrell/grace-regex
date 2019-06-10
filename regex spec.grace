dialect "minispec"
import "scratch" as regex

describe "Basic operators: concatanation, |, *, and ?, escaped characters '\*', '\+', etc\n" with {
    specify "empty pattern doesn't match a non-empty text" by {
        expect (regex.pattern "".matches "a") toBe false
    }
    specify "empty pattern does match an empty text" by {
        expect (regex.pattern "".matches "") toBe true
    }
    specify "single character match" by {
        expect (regex.pattern "a".matches "a") toBe true
    }
    specify "non-empty pattern does not match empty text" by {
        expect (regex.pattern "a".matches "") toBe false
    }
    specify "concatenation works" by {
        expect (regex.pattern "ab".matches "ab") toBe true
    }
    specify "alternation matches left" by {
        expect (regex.pattern "a|b".matches "a") toBe true
    }
    specify "alternation matches right" by {
        expect (regex.pattern "a|b".matches "b") toBe true
    }
    specify "repetition matches 0 instances" by {
        expect (regex.pattern "a*".matches "") toBe true
    }
    specify "repetition mathces 1 instance" by {
        expect (regex.pattern "a*".matches "a") toBe true
    }
    specify "repetition matches multiple instances" by {
        expect (regex.pattern "a*".matches "aa") toBe true
    }
    specify "escape: \\| matches |" by {
        expect (regex.pattern "\\|".matches "|") toBe true
    }
    specify "escape: \* matches *" by {
        expect (regex.pattern "\\*".matches "*") toBe true
    }
    specify "escape: \a matches a" by {
        expect (regex.pattern "\a".matches "a") toBe true
    }
    specify "optional: a? mathces a" by {
        expect (regex.pattern "a?".matches "a") toBe true
    }
    specify "optional: a? matches empty string" by {
        expect (regex.pattern "a?".matches "") toBe true
    }
}

describe "Character classes, + operator, bounded repetition\n" with {
//retest( '[wxy]', 'w' , 'T');
//retest( '[wxy]', 'x', 'T' );
//retest( '[wxy]', 'y' , 'T');
//retest( '[wxy]', 'z', 'F');
//retest( '\[wxy\]', '[wxy]', 'T' );
//retest( '[^wxy]', 'a', 'T' );
//retest( '[^wxy]', 'w', 'F' );
//retest( '[^wxy]', 'x', 'F' );
//retest( '[^wxy]', 'y', 'F' );
//retest( '[]]', ']' , 'T');
//retest( '[]]]', ']]', 'T' );
//retest( '[][]', '[' , 'T');
//retest( '[][]', ']', 'T' );
//retest( '[[]]', '[]' , 'T');
//retest( ']', ']' , 'T');
//retest( 'a+', '' , 'F');
    specify "+ doesn't match zero instances" by {
        expect (regex.pattern "a+".matches "") toBe false
    }
//retest( 'a+', 'a', 'T' );
    specify "+ does match one instances" by {
        expect (regex.pattern "a+".matches "a") toBe true
    }
//retest( 'a+', 'aa' ,'T');
    specify "+ does match multiple instances" by {
        expect (regex.pattern "a+".matches "aa") toBe true
    }
    specify "+ does not match other characters" by {
        expect (regex.pattern "a+".matches "b") toBe false
    }
//retest( '\+', '+' ,'T');
    specify "\\+ matches a literal '+'" by {
        expect (regex.pattern "\\+".matches "+") toBe true
    }
//retest( '^a{0,0}$', '','T' );
//retest( '^a{0,0}$', 'a','F' );
//retest( 'a{0,1}', '','T' );
//retest( 'a{0,1}', 'a','T' );
//retest( '^a{0,1}$', 'b','F' );
//retest( 'a{2,4}', '','F' );
//retest( 'a{2,4}', 'a','F' );
//retest( 'a{2,4}', 'aa','T' );
//retest( 'a{2,4}', 'aaa','T' );
//retest( 'a{2,4}', 'aaaa','T' );
//retest( 'a{2,4}', 'aaaab','T' );
//retest( '^[0-2]$', '0', 'T' );
//retest( '^[0-2]$', '1', 'T' );
//retest( '^[0-2]$', '2', 'T' );
//retest( '^[0-2]$', '3', 'F' );
//retest( '^.$', '`', 'T' );
//retest( '^\s$', ' ', 'T' );
//retest( '^\s$', 'q', 'F' );
}

describe "pathological patterns\n" with {
//    specify "a?^n . a^n = a^n" by {
//        expect (regex.pattern "a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?aaaaaaaaaaaaaaaaaaaaaaaaa"
//            .matches "aaaaaaaaaaaaaaaaaaaaaaaaa") toBe true
//    }
    specify "a?^n . a^n = a^n" by {
        var t := 8
        var p := "a?"*t
        var s := "a"*t
        expect (regex.pattern (p++s).matches(s)) toBe true
    }
}
