class ForkeMail < Formula
  desc "Send email, manage Forke Mail and connect AI agents from your terminal"
  homepage "https://www.forke.space/docs/forke-mail"
  license :cannot_represent

  on_macos do
    on_intel do
      url "https://github.com/forke-org/forke-mail/releases/download/v1.1.0/forke-mail_1.1.0_macOS_amd64.zip"
      sha256 "2939e580724763f0b8c18a30b7887b891c99b6457e55c0438319e1047efb9587"
    end
    on_arm do
      url "https://github.com/forke-org/forke-mail/releases/download/v1.1.0/forke-mail_1.1.0_macOS_arm64.zip"
      sha256 "4780cfffa4ad7e18931d98a089def0703224a4e279c76d689f4e8bf02047f874"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/forke-org/forke-mail/releases/download/v1.1.0/forke-mail_1.1.0_linux_amd64.tar.gz"
      sha256 "08fb340b2dbf4c808b7757c37d89f78c763e58b14a612a402154fdd1c4bba515"
    end
    on_arm do
      url "https://github.com/forke-org/forke-mail/releases/download/v1.1.0/forke-mail_1.1.0_linux_arm64.tar.gz"
      sha256 "3f630e1908d148a5f56513ebe60374f9186f3caca017a85366c93478093d32f1"
    end
  end

  def install
    bin.install "forke-mail"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forke-mail --version")
  end
end
