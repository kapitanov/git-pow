# git-pow: proof-of-work for git commits

A simple just-for-fun experiment that adds proof-of-work to git commits
by modifying a nonce file in the repository until the commit hash starts with three leading zeros.

## Installation

Run the following command:

```bash
make install
```

After installation, the `git-pow-postcommit.sh` script will be set up as a `post-commit` hook in this git repository.

## Usage

Just make commits as usual.
After each commit, the hook will automatically modify the `.nonce` file
until the commit hash starts with three leading zeros.

You may review the results by checking the commit history:

```bash
$ git log --oneline
000a55afa (HEAD -> master) Update content 9
000ce2032 Update content 8
000760ca6 Update content 7
000e8964a Update content 6
000d7c2e3 Update content 5
000296466 Update content 4
0003ffbce Update content 3
0005b9578 Update content 2
0008ee836 Update content 1
000f16161 Initial commit
```

As you can see, all commit hashes start with three leading zeros - `000xxxxxx`.

## License

MIT License. See [the LICENSE file](LICENSE) for details.
