When comparing a file's signatures to those of other files, take:

N = total number of unique n-grams in the file

Take each N-Gram, and match against all other unique n-grams - the n-grams in its own file

P = percentage match => number-of-shared-n-grams / N

Calculate P for every file in the set of complaints in the set of suspended accounts

```bash
# How to get the set of complaints used in suspensions:
$ cat total.complaints | fgrep -v -f outstanding.complaints > suspended.complaints
```

Note: This was inspired by: http://taint.org/2007/03/05/134447a.html
