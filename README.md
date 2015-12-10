# Minor emacs mode for GHC development

## Usage

Set the customise variables `M-x customize-group ghc-dev` to your
development preferences and optionally add a `.dir-locals.el` file to
the GHC source tree:

```
((nil . ((ghc-dev-mode . t))))
```

or maybe enable only for haskell files:

```
((haskell-mode . ((ghc-dev-mode . t))))
```

## Features

- Compilation in Emacs with source spans support,
- running `arc lint` in Emacs
