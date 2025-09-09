最初の認証はGitHub CLI`gh auth login`で行います。

https://docs.github.com/ja/github-cli/github-cli/quickstart

インストール詳細は以下

https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian


```
$ gh auth login
? Where do you use GitHub? GitHub.com
? What is your preferred protocol for Git operations on this host? SSH
? Upload your SSH public key to your GitHub account? /home/quarkgabber/.ssh/id_rsa.pub
? Title for your SSH key: WSL2
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: xxxx-xxxx
Press Enter to open https://github.com/login/device in your browser...
✓ Authentication complete.
- gh config set -h github.com git_protocol ssh
✓ Configured git protocol
! Authentication credentials saved in plain text
✓ SSH key already existed on your GitHub account: /home/quarkgabber/.ssh/id_rsa.pub
✓ Logged in as nijigen-plot
```
