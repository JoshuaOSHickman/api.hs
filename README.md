api.hs
======

Simple JSON API Helpers


## Why...?

Because I don't want to build just the same old things, and deep-diving on how haskell templates HTML is mostly irrelevant for people (like myself) who are going to use Angular.js/similar. 

So I figured I'd get to know some of these frameworks better, and see if there's one where I can write some super elegant wrapper code to make JSON apis stupidly simple. 

## Here's the issue

ApiFunction is a type that can handle json to produce JSON in a nice, type-safe way. 

If I make the input and output types part of the spec, then I can't do a map of general input/outputs, I don't think. 

If I use existentials, the compiler barfs because it can't deduce (a ~ a2), basically it doesn't know what I'm talking about why am I being so vague about types. 

Maybe there's some more trickery I can do. Existentials _don't_ seem to be the way to do this. But making things more explicit, and throwing in the existentials only when I want the map, should be good. 
