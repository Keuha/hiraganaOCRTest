
# HiraganaOCRTest
had fun with mlmodel, drawable uiimageview and hiragana

This test is higly inspired by an article from [Melody Yang](https://medium.freecodecamp.org/@melodyfs) However the drawable implementation for writing the Hiragana was not the best Idea.
Using only Bezier path for your drawable area will result in severe lack of performance if user start drawing something else and will result, in the end, into a crash of your app. note quite what you'd like I guess. 
Plus, to avoid caputring a `UIView`, to transform it in a `UIImageView`, I'm using a `UIImageview` from the begining.
`DrawableCanvas`  can be used by whoever need a drawable suface, it just needs you to implement `DrawabaleCanvasDelegate`

## Result 

Not quite what expected, model is probably not train enough or i'm doing mistakes with image tranformation to bytes. most of the time, regading less the hiragana you just draw け will be recognized. 

readdme made using [stackedit](https://stackedit.io/app)
