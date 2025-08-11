class ModeTerminal < Formula
  desc "Interactive terminal navigator v1.0 with Claude Code-style AI chat interface for macOS development workflows"
  homepage "https://github.com/JadenB9/mode-terminal"
  url "https://github.com/JadenB9/mode-terminal/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f42041780a4b79da60d55c09db572d4a5f18d860b4d38572b41b37a25835497b"
  version "1.0.0"
  license "MIT"

  depends_on "python@3.11"
  depends_on "ollama" => :optional

  def install
    # Install to libexec to avoid conflicts
    libexec.install Dir["*"]
    
    # Create wrapper script that uses user's pip packages
    (bin/"mode").write <<~EOS
      #!/bin/bash
      cd #{libexec}
      
      # Check if dependencies are installed, if not, install them
      if ! python3 -c "import rich, inquirer, requests, psutil" 2>/dev/null; then
        echo "Installing Python dependencies..."
        pip3 install --user rich inquirer requests psutil
      fi
      
      exec python3 mode.py "$@"
    EOS
    
    # Make wrapper executable
    chmod 0755, bin/"mode"
  end

  def post_install
    puts ""
    puts "> Mode Terminal installed successfully!"
    puts ""
    puts "> Quick Start:"
    puts "   1. Run: mode"
    puts "   2. Press TAB for AI chat (requires Ollama)"
    puts ""
    puts "> For AI features, install Ollama:"
    puts "   brew install ollama"
    puts "   ollama pull dolphin-mistral:7b"
    puts ""
  end

  test do
    # Test that the mode command exists and shows help
    assert_match "Mode Terminal", shell_output("#{bin}/mode --version")
  end
end