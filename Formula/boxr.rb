class Boxr < Formula
  desc "Fast, lightweight OCI container engine and runtime written in Rust"
  homepage "https://github.com/kchaitanya863/homebrew-tap"
  license "Apache-2.0"
  head "https://github.com/kchaitanya863/kc-docker.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.15/boxr-macos-arm64.tar.gz"
      sha256 "3dee59c969bf7ae6709fa298327b734c040fb67a693550a26b46d29c659f9873"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.15/boxr-macos-x86_64.tar.gz"
      sha256 "6f64fb378b6dba2048914a17320cf6329e4a5d3a71d3c5a70774fbb80a321e2a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.15/boxr-linux-arm64.tar.gz"
      sha256 "75420b7639c977b3840086e7ddbf10e706c573857fd2ce0f541ffc7390e477df"
    else
      url "https://github.com/kchaitanya863/homebrew-tap/releases/download/v0.1.15/boxr-linux-x86_64.tar.gz"
      sha256 "e32761068126fd7b131a3a287255a1830dbe7fe9c666585b13b9b5492abc34fc"
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
