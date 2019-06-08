dialect "minispec"
import "regex" as regex

describe "Regex engine specification" with {
    specify "empty pattern doesn't match a non-empty text" by {
        expect (regex.pattern "".matches "a") toBe false
    }
    specify "empty pattern does match an empty text" by {
        expect (regex.pattern "".matches "") toBe false
    }
    specify "single character match" by {
        expect (regex.pattern "a".matches "a") toBe true
    }
}
