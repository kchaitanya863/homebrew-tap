# Homebrew Tap for Boxr

Official Homebrew tap for [Boxr](https://github.com/kchaitanya863/kc-docker) and developer tools maintained by [@kchaitanya863](https://github.com/kchaitanya863).

## Installation

Add this tap:

```bash
brew tap kchaitanya863/tap
```

Install Boxr:

```bash
brew install boxr
```

Or install directly in one command:

```bash
brew install kchaitanya863/tap/boxr
```

## Available Packages

| Formula | Description | Platforms |
| :--- | :--- | :--- |
| [`boxr`](Formula/boxr.rb) | Fast, lightweight OCI container engine and runtime in Rust | macOS (Apple Silicon / Intel), Linux (`x86_64`, `aarch64`) |

## Usage

### Managing the Background Daemon

Boxr includes Homebrew service integration for running the daemon as a background service:

```bash
# Start and register the daemon on login
brew services start boxr

# View service status
brew services list

# Stop the daemon
brew services stop boxr
```

### Upgrading

```bash
brew update
brew upgrade boxr
```

### Docker Alias (Optional)

To route `docker` CLI commands to `boxr`:

```bash
boxr alias --install
```

Or add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
alias docker="boxr"
```

## Other Platforms

For precompiled `.deb` (Debian/Ubuntu), `.rpm` (Fedora/RHEL), or Windows binaries, refer to the [GitHub Releases](https://github.com/kchaitanya863/homebrew-tap/releases) page or the source repository at [kchaitanya863/kc-docker](https://github.com/kchaitanya863/kc-docker).

## License

This tap and its formulae are licensed under the [Apache-2.0 License](LICENSE).
