dialect "minispec"
import "regex" as regex

describe "Regex engine specification" with {
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
}
