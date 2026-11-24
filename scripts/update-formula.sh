#!/bin/bash
# Writes Formula/forke-mail.rb for the latest forke-mail CLI release.
# Usage: scripts/update-formula.sh [tag]   (defaults to the latest release)
set -euo pipefail

repo="forke-org/forke-mail"

get() {
  if [[ -n "${GITHUB_TOKEN:-}" ]]
  then
    curl -fsSL -H "Authorization: Bearer ${GITHUB_TOKEN}" "$1"
  else
    curl -fsSL "$1"
  fi
}

tag="${1:-}"
if [[ -z "${tag}" ]]
then
  latest="$(get "https://api.github.com/repos/${repo}/releases/latest")"
  tag="$(sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' <<<"${latest}" | head -1)"
fi
if [[ -z "${tag}" ]]
then
  echo "could not find the latest release" >&2
  exit 1
fi
version="${tag#v}"
base="https://github.com/${repo}/releases/download/${tag}"
sums="$(get "${base}/forke-mail_${version}_checksums.txt")"

sha() {
  awk -v f="$1" '$2 == f { print $1 }' <<<"${sums}"
}

mac_intel="$(sha "forke-mail_${version}_macOS_amd64.zip")"
mac_arm="$(sha "forke-mail_${version}_macOS_arm64.zip")"
linux_intel="$(sha "forke-mail_${version}_linux_amd64.tar.gz")"
linux_arm="$(sha "forke-mail_${version}_linux_arm64.tar.gz")"
for s in "${mac_intel}" "${mac_arm}" "${linux_intel}" "${linux_arm}"
do
  if [[ -z "${s}" ]]
  then
    echo "missing archives in ${tag}" >&2
    exit 1
  fi
done

cat >Formula/forke-mail.rb <<RUBY
class ForkeMail < Formula
  desc "Send email, manage Forke Mail and connect AI agents from your terminal"
  homepage "https://www.forke.space/docs/forke-mail"
  license :cannot_represent

  on_macos do
    on_intel do
      url "${base}/forke-mail_${version}_macOS_amd64.zip"
      sha256 "${mac_intel}"
    end
    on_arm do
      url "${base}/forke-mail_${version}_macOS_arm64.zip"
      sha256 "${mac_arm}"
    end
  end

  on_linux do
    on_intel do
      url "${base}/forke-mail_${version}_linux_amd64.tar.gz"
      sha256 "${linux_intel}"
    end
    on_arm do
      url "${base}/forke-mail_${version}_linux_arm64.tar.gz"
      sha256 "${linux_arm}"
    end
  end

  def install
    bin.install "forke-mail"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forke-mail --version")
  end
end
RUBY

echo "Formula/forke-mail.rb -> ${version}"
