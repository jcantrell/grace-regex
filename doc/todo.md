# Phase 0
- [x] Set up and run a test test for pattern, to test that tests test :)

# Phase 1 - Concatenation, alternation, and repetition. Escape characters.
- [x] Empty pattern matches nothing
- [x] Empty pattern matches empty text
- [x] Arbitrary pattern matches self (`a` matches `a`)
- [x] Arbitrary pattern does not match empty text
- [x] concatenation operator (implicit)
- [x] `|` alternation operator matches left option
- [x] `|` alternation operator matches right option
- [x] `*` repetition operator matches 0 instances
- [x] `*` repetition operator matches 1 instances
- [x] `*` repetition operator matches multiple instances
- [x] `\|` matches a literal `|` character
- [x] `\*` matches a literal `*` character
- [x] Lone `*` throws error

# Phase 2 - Character classes, one-or-more, bounded repetition. Named classes.
- [ ] Character classes (ex: `[wxy]` matches one of `w`, `x`, or `y`)
- [ ] Character classes (ex: `[wxy]` doesn't match a char not in the class)
- [ ] `\[wxy\]` literally matches `[wxy]`
- [ ] `[]` throws error
- [ ] Inverted character class (ex: `[^wxy]` matches a single char not `w`, `x`, 
      or `y`
- [ ] Inverted character class (ex: `[^wxy]` doesn't match `w`, `x`, or `y`
- [ ] `[]]` matches `]`
- [ ] `[]]]` matches `]]`
- [ ] `[][]` matches `[` or `]`
- [ ] `[[]]` matches `[]` (character class containing `[` followed by `]`
- [ ] `[` throws an error
- [ ] `]` matches `]`
- [x] `+` one-or-more repetition operator does not match 0 instances
- [x] `+` one-or-more repetition operator does matches 1 instances
- [x] `+` one-or-more repetition operator does matches multiple instances
- [x] `\+` matches literal `+` character
- [ ] `a{0,0}` bounded repetition (one or two instances)
- [ ] `a{0,1}` bounded repetition (one or two instances)
- [ ] `a{2,4}` bounded repetition (two through four instances)
- [ ] Character ranges `[a-z]` or `[0-9]`
- [ ] Named character classes (`.` and `\s`)

# Phase 3 - Pattern match extraction and lazy matching
- [ ] `a(b)c(d)e` matched with `abcde` gives `$0=abcde`, `$1=b`, `$2=d`
- [ ]  `a(b|c)d(ee*)e*f` matched against `qrstacdeeeef` will give `$1=c`
        and `$2=eeee`
- [ ]  `a(b|c)d(ee*)?e*f` matched against `qrstacdeeeef` will give `$1=c`
        and `$2=e`

# Phase 4 - Backreference matching
- [ ] `<([a-zo-0]+)>.*?</\1>` should match tags like `<html>stuff</html>`
      and `<body>morestuff</body>`
