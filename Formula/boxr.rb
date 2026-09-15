class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "Apache-2.0"
  head "https://github.com/kchaitanya863/kc-docker.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.13/boxr-macos-arm64.tar.gz"
      sha256 "107a2ae3da453f11685a4479523c6c1dfcf98ff701ab6ce9bbd64aa98d877589"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.13/boxr-macos-x86_64.tar.gz"
      sha256 "a6ec69c4c762c24fae55473b7aab50de2d1f2d9f5f6f6f5dbb1ed47d9e0d43fe"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.13/boxr-linux-arm64.tar.gz"
      sha256 "a511e96de4e6775dba6c757b57a307d72653305662e34004cce755ba2c147abb"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.13/boxr-linux-x86_64.tar.gz"
      sha256 "a744500937c963364a61bcf21bef1100d929822f06ae1d375a4d77f1e25d2f1f"
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
