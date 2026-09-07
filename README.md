# mon4our/homebrew-tap

Homebrew tap for my own tools.

```sh
brew tap mon4our/tap
brew trust mon4our/tap        # Homebrew 6 requires third-party taps to be trusted
```

## Formulae

- **[handover](https://github.com/mon4our/handover)** — disconnects your Bluetooth headphones
  when the Mac sleeps and reconnects them when it wakes, so multipoint headphones stay usable on
  your phone. (Formerly `headphone-disconnect`, which still resolves as an alias.)

  ```sh
  brew install handover
  brew services start handover
  ```
