- very easy to get up and running, syntax and semantics pretty familiar
- prefer ruby style over python style but no biggie -- mixing function vs method style interesting, bit odd, seems like more typing than should be necessary
- discard is nice
- string ranges nice
- have to declare proc before used a bit annoying
- object hierarchy/inheritance still a bit confusing
- hashes - pretty good, no nils
- string is non-nullable - is there consistency here with what is nullable and what isn't?
- Case and underscore insensitive!! not really a fan... but maybe could get used to it and it would be great?
- clear distinction between value and ref types

## notes

- typeclasses vs case variant type - https://www.reddit.com/r/nim/comments/icbgcu/subjective_nim_criticism/
  - main prob with object variants seems to be type safety, e.g. see http://al6x.com/blog/2020/nim-language - compiler will let you call field that does not exist
  - see https://forum.nim-lang.org/t/6707 for more discussion
