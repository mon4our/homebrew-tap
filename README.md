# mon4our/homebrew-tap

Homebrew tap for my own tools.

```sh
brew tap mon4our/tap
brew trust mon4our/tap        # Homebrew 6 requires third-party taps to be trusted
```

## Formulae

- **[headphone-disconnect](https://github.com/mon4our/headphone-disconnect)** — disconnects your
  Bluetooth headphones when the Mac sleeps and reconnects them when it wakes, so multipoint
  headphones stay usable on your phone.

  ```sh
  brew install headphone-disconnect
  brew services start headphone-disconnect
  ```
