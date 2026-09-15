class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "Apache-2.0"
  head "https://github.com/kchaitanya863/kc-docker.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.19/boxr-macos-arm64.tar.gz"
      sha256 "7df23be5d167ca1d8c43e8a81441ae576363d6f220ff0455a0a59809d5b2e062"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.19/boxr-macos-x86_64.tar.gz"
      sha256 "23a5ee52b27bd74e6982649ad6041f870f7f35d87cbf5c5f985d4e951e972f1d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.19/boxr-linux-arm64.tar.gz"
      sha256 "a7fbef768edc07ac123bcef773125d7acfc417b2838b0ef43383bf2c59494599"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.19/boxr-linux-x86_64.tar.gz"
      sha256 "3007907a99bb572700cd3848aa5a1679b92e075faf59ae53c267319aa15440fa"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "bin/boxr"
    end

    # Shell completions
    bash_completion.install "completions/boxr.bash" => "boxr" if File.exist?("completions/boxr.bash")
    zsh_completion.install "completions/_boxr" => "_boxr" if File.exist?("completions/_boxr")
    fish_completion.install "completions/boxr.fish" => "boxr.fish" if File.exist?("completions/boxr.fish")
  end

  service do
    run [opt_bin/"boxr", "daemon"]
    keep_alive true
    log_path var/"log/boxr.log"
    error_log_path var/"log/boxr.log"
    working_dir var
  end

  def caveats
    <<~EOS
      To enable the docker drop-in alias wrapper:
        boxr alias --install
      or add to your shell profile:
        export PATH="$HOME/.boxr/bin:$PATH"
    EOS
  end

  test do
    assert_match "boxr", shell_output("#{bin}/boxr --version")
    assert_match "Containers:", shell_output("#{bin}/boxr info")
  end
end
