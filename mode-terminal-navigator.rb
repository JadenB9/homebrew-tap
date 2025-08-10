class ModeTerminalNavigator < Formula
  desc "Interactive terminal application for navigating and managing development workflows on macOS with integrated AI assistant"
  homepage "https://github.com/JadenB9/mode-terminal-navigator"
  url "https://github.com/JadenB9/mode-terminal-navigator/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "8e5057afe2271be9b6bcce4a49a19715eeef807e1f0022f35ecb339c688d6b9b"
  version "1.0.0"
  license "MIT"

  depends_on "python@3.11"
  depends_on "ollama" => :optional

  def install
    # Install to libexec to avoid conflicts
    libexec.install Dir["*"]
    
    # Install Python dependencies to libexec/lib  
    system Formula["python@3.11"].opt_bin/"pip3", "install", 
           "--target", "#{libexec}/lib",
           "rich", "inquirer", "requests", "psutil"
    
    # Create wrapper script with proper Python path
    (bin/"mode").write <<~EOS
      #!/bin/bash
      export PYTHONPATH="#{libexec}/lib:$PYTHONPATH"
      cd #{libexec}
      exec #{Formula["python@3.11"].opt_bin}/python3 mode.py "$@"
    EOS
    
    # Make wrapper executable
    chmod 0755, bin/"mode"
  end

  def post_install
    puts ""
    puts "🎉 Mode Terminal Navigator installed successfully!"
    puts ""
    puts "📖 Quick Start:"
    puts "   1. Run: mode"
    puts "   2. Press TAB for AI chat (requires Ollama)"
    puts ""
    puts "🤖 For AI features, install Ollama:"
    puts "   brew install ollama"
    puts "   ollama pull dolphin-mistral:7b"
    puts ""
  end

  test do
    # Test that the mode command exists and shows help
    assert_match "Mode Terminal Navigator", shell_output("#{bin}/mode --version")
  end
end