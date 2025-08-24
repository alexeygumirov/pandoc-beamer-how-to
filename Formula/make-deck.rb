class MakeDeck < Formula
  desc "Standalone pandoc beamer presentation generator"
  homepage "https://github.com/hubrix/make_deck"
  url "https://github.com/hubrix/make_deck/archive/refs/heads/macos-build-improvements.tar.gz"
  version "1.0.0"
  sha256 "cd3a837b05850cad101c35287f2f6f9348cf8a43f41cb14a696f6a0b81883dee"
  license "MIT"
  head "https://github.com/hubrix/make_deck.git", branch: "macos-build-improvements"

  depends_on "pandoc"
  depends_on "tectonic"
  depends_on "imagemagick"

  # Install font as a cask dependency
  def caveats
    <<~EOS
      For enhanced typography, consider installing Hack Nerd Font:
        brew install --cask font-hack-nerd-font
      
      This font provides better presentation aesthetics but is optional.
    EOS
  end

  def install
    # Generate the standalone make_deck executable
    system "make", "make_deck"
    
    # Install the executable
    bin.install "make_deck"
    
    # Install documentation
    doc.install "README.md"
    doc.install "LICENSE" if File.exist?("LICENSE")
  end

  test do
    # Test help functionality
    assert_match "Usage: make_deck", shell_output("#{bin}/make_deck --help")
    
    # Create a simple test markdown file
    (testpath/"test.md").write <<~EOS
      ---
      title: "Test Presentation"
      author: "Homebrew Test"
      theme: "Frankfurt"
      colortheme: "beaver"
      fonttheme: "professionalfonts"
      fontsize: 11pt
      aspectratio: 169
      date: "Test Date"
      toc: true
      ---
      
      # Test
      
      This is a test slide.
      
      ## Features
      
      - Point one
      - Point two
      
      # Conclusion
      
      It works!
    EOS
    
    # Test PDF generation (tectonic is now guaranteed to be available)
    system bin/"make_deck", testpath/"test.md", testpath/"test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
    assert_operator (testpath/"test.pdf").size, :>, 1000, "Generated PDF should be larger than 1KB"
  end
end