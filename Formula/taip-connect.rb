# Homebrew formula for the slim public `taip-connect` — wires the hosted taip brain + context +
# taip-tools MCP servers into Claude Code.  Install:  brew install taip-ai/taip/taip-connect
class TaipConnect < Formula
  desc "Wire the hosted taip brain + context + taip-tools MCP servers into Claude Code"
  homepage "https://github.com/taip-ai/taip-agent"
  url "https://registry.npmjs.org/taip-connect/-/taip-connect-0.5.0.tgz"
  sha256 "46b71b39ae8819e4c76cdc3480491fa80490397850776337c34d7dd960c5b275"
  license "UNLICENSED"

  depends_on "node" # Node >= 20 auto-installed as a dependency (SR-3)

  def install
    # Install the slim, bundled package (no runtime deps) into libexec.
    system "npm", "install", *std_npm_args

    # SR-5: bake the STABLE node opt path so `brew upgrade node` never breaks MCP connections.
    (bin/"taip-connect").write <<~SH
      #!/bin/bash
      export TAIP_NODE_BIN="#{Formula["node"].opt_bin}/node"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/lib/node_modules/taip-connect/bin/connect.js" "$@"
    SH
  end

  test do
    assert_match "taip-connect", shell_output("#{bin}/taip-connect --help")
  end
end
