# Krishna's Software Tap 🍺

Welcome to the official **Homebrew Tap** for tools and packages maintained by [@kchaitanya863](https://github.com/kchaitanya863).

This repository serves as the central distribution hub for macOS and Linux packages, with cross-platform packaging plans spanning **Homebrew** (macOS/Linux), **APT** (Debian/Ubuntu), and **Chocolatey / Winget** (Windows).

---

## Installation & Usage

Add this tap to your Homebrew installation:

```bash
brew tap kchaitanya863/tap
```

Trust the tap (Homebrew 7.0+):

```bash
brew trust kchaitanya863/tap
```

Install any available package:

```bash
brew install <formula>
```

Or install directly in one step without tapping first:

```bash
brew install kchaitanya863/tap/<formula>
```

---

## Available Formulae

| Formula | Description | Platforms | Install Command |
| :--- | :--- | :--- | :--- |
| **`boxr`** 📦 | Fast, lightweight OCI container engine, image builder, compose orchestrator, and runtime written in Rust. Features native Apple `Virtualization.framework` micro-VMs on macOS and rootless namespaces on Linux with zero Docker dependency. | macOS (Apple Silicon / Intel), Linux (`x86_64`, `aarch64`) | `brew install boxr` |

---

### Formula Spotlight: `boxr` 📦

A high-performance Open Container Initiative (OCI) container runtime written in pure Rust.

#### 1. Install
```bash
brew tap kchaitanya863/tap
brew install boxr
```

#### 2. Verify
```bash
boxr --version
boxr run --rm alpine uname -a
```

#### 3. Run as an Always-On Background Service
To run the Boxr daemon as a background service with automatic restart on boot and login:

```bash
# Start service immediately and register autostart at login:
brew services start boxr

# View service status:
brew services list

# Stop service:
brew services stop boxr
```

#### 4. Enable Docker CLI Drop-in Wrapper
To transparently replace Docker CLI with Boxr:
```bash
boxr alias --install

# Now run standard docker commands directly:
docker run --rm hello-world
docker ps
```

---

## Multi-Platform Ecosystem Roadmap

We are expanding multi-platform package distribution across major ecosystem package managers:

- [x] **Homebrew** (macOS & Linux): Precompiled universal binaries and automated release formulas.
- [ ] **APT / PPA** (Debian, Ubuntu): Native `.deb` packages and repository hosting for `apt-get install boxr`.
- [ ] **Chocolatey / Winget** (Windows): Package manifests for Windows container tooling (`choco install boxr`).
- [ ] **RPM / Copr** (Fedora, RHEL, Rocky Linux): Native `.rpm` packages for Red Hat ecosystems.

---

## Updating & Troubleshooting

### Upgrade Formulae
```bash
brew update
brew upgrade boxr
```

### Inspect Formula
```bash
brew info boxr
```

### Untap
```bash
brew untap kchaitanya863/tap
```

---

## License

All formulae and distribution scripts are licensed under the [Apache-2.0 License](LICENSE).
