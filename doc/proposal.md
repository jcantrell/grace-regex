% CS420
% Term Project Proposal: Regular Expression Library
% Jordan Cantrell

# Phase 1: Regular Expression Operators
Phase 1 of this project will implement a regular expression engine for Grace
which will implement the basic regular expression operators.
That is, alternation '|', which matches one of two given patterns, repetitition
'*', which matches zero or more instances of the preceding pattern, and
concatenation (implicit between adjacent patterns), which matches the first
pattern immediately followed by the second pattern. It will also be necessary
to implement escaping in this phase, so literal operator characters can be
escaped with a character sequence such as `\*`.

From a users point of view, this will be used by sending a
`match(text)` method to a `pattern` object.

# Phase 2: Convenience Notation
This phase of development will see the creation and testing of ease-of-use noations
for regular expressions. These will consist of the following notatinos.
A one-or-more repetition
operator, '+', which will match one or more instances of the preceding
pattern.
Character classes '[abcd...xyz]', which match a single instance of any one of
the characters in between the '[' and ']' brackets.
Negated character classes
'[^abcdef]', which matches any single character **not** listed in between the
'[^' and ']'.
Bounded repetitions which specify the number of times a given
pattern should repeat to be matched. For example, the pattern `a*{4,8}` 
will match the character 'a' four to eight times.
Character ranges [a-z0-9], which act as shorthand for a range of characters.
Writing '0-9' inside a character class denotes the character class 
'[0123456789]' in a more compact form.
Named character classes for commonly used sets of characters, such as '.',
which matches any character, and `\s` which matches any whitespace character.

# Phase 3: Extracting Matches
This phase will see the introduction of extracting matches. After matching
a pattern against some text, the use will be able to get the portions of the
text that matched the pattern. The returned sub-portions will correspond to
parentheses '()' in the pattern; except the first portion in the list will
correspond to the entire pattern.

For example, the pattern "a(b|c)d(ee*)f" will match the text "qrstacdeeef" 
and will give back a list of two
sub-strings, "c", and "eee".

This phase will also see the introduction of 'lazy' matching. Repetition
operators, which operate 'greedily' by default. By appending a '?' after some
repetition operator, we can tell it to match 'lazily' - that is, match as
little as it can, while still allowing the pattern as a whole to successfully
match against the given text. This becomes useful when extracting substring
matches, as you have more fine-grain control over what is actually extracted.

# Phase 4: Backreference Matching
It is often convenient to match a substring multiple times. The classic example
of this is matching an opening and closing html tag. We can accomplish this
by using backreferences, which save matched substrings and number them.
In Perl syntax, will match some html tag `<([a-z0-9]+)>.*?</\1>` and its
contents. The parenthesis are used to extract the name of the tag, and the
`\1` backreference means "match the exact text captured by the first
set of parentheses".

To facilitate ease of use, the implementation of this regex engine
will attempt to mimic perl style regular expression strings. That is,
perl names will be used for named character classes, curly braces will denote 
bounded
repetition, etc.
