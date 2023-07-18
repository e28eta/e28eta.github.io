---
layout: single
title: '_port_caching_policy:12: bad math expression: operator expected'
tags: [zsh, bug, zsh4humans, macports]
published: true
---

Today, I was doing a [MacPorts](https://www.macports.org) self update, and wanted to see what was outdated. However, I got an interesting error when hitting tab to show auto-completion options:

```console
> port list <tab>
    _port_caching_policy:12: bad math expression: operator expected at `16777234\ni...'
```

Today, there's a single hit on google for "_port_caching_policy", and it's [the function on
github](https://github.com/zsh-users/zsh-completions/blob/master/src/_port). Which, fair. It's not especially interesting, just a very basic comparison between file modification times to see if the cache should be updated or not.

```zsh
stat -f%m . > /dev/null 2>&1
if [ "$?" = 0 ]; then
  stat_cmd=(stat -f%Z)
else
  stat_cmd=(stat --format=%Z)
fi

_port_caching_policy() {
  local reg_time comp_time check_file
  case "${1##*/}" in
    PORT_INSTALLED_PACKAGES)
      check_file=$port_prefix/var/macports/registry/registry.db
      ;;
    PORT_AVAILABLE_PACKAGES)
      check_file=${$(port dir MacPorts)%/*/*}/PortIndex
      ;;
  esac
  reg_time=$($stat_cmd $check_file)
  comp_time=$($stat_cmd $1)
  return $(( reg_time < comp_time ))
}
```

# ⌨️ ZSH completions

I was pretty impressed to find [docs on debugging completions](https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org#testing--debugging), and at various points used all three shortcuts( `alt-2 ctrl-x h`, `ctrl-x h`, and `ctrl-x ?`).

It was quickly evident that `stat` was returning the full details, but the code was expecting a single number from each execution:

```
stat '--format=%Z' /opt/local/var/macports/sources/rsync.macports.org/release/tarballs/ports/PortIndex
reg_time=$'device  16777234\ninode   19150376\nmode    33188\nnlink   1\nuid     0\ngid     0\nrdev    0\nsize    21393774\natime   1689623078\nmtime   1689614240\nctime   1689623082\nblksize 4096\nblocks  41792\nlink    '

stat '--format=%Z' /Users/daniel/.cache/zsh4humans/v4/cache/zcompcache-5.9/PORT_AVAILABLE_PACKAGES
comp_time=$'device  16777234\ninode   16062342\nmode    33188\nnlink   1\nuid     501\ngid     20\nrdev    0\nsize    590845\natime   1689287896\nmtime   1689273088\nctime   1689273088\nblksize 4096\nblocks  1160\nlink    '

_port_caching_policy:12: bad math expression: operator expected at `16777234\ni...'
```

# 📝 stat vs stat vs zsh/stat

Ok, so the behavior of `stat` has changed. Maybe old code that needs to be updated for Ventura? Except that the code already handles the BSD-flavored [stat](https://ss64.com/osx/stat.html), as well as the [coreutils version](https://man7.org/linux/man-pages/man1/stat.1.html).

And the `stat` command in my terminal doesn't behave like either of those, because ... it's the [zsh/stat](https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002fstat-Module) builtin module, with output like this:

```
device  16777234
inode   1129680
mode    16877
nlink   7
uid     501
gid     20
rdev    0
size    224
atime   1689639115
mtime   1689639115
ctime   1689639115
blksize 4096
blocks  0
link
```

Prominent in the documentation:

> The same command is provided with two names; as the name stat is often used by an external command it is recommended that only the zstat form of the command is used. This can be arranged by loading the module with the command ‘zmodload -F zsh/stat b:zstat’.

# 🕰️ `zstat +mtime`

I was partway through a PR to add a _third_ case, preferring to use `zstat` if it's loaded. It makes sense to me that using the shell builtin _would_ be preferable, but I don't know how common it is to have it loaded. So I don't think it can completely replace the if / else that determines `stat_cmd`. And any theoretical performance win from an in-process syscall (vs executing the separate binary) is going to be invisible against cost of reading the (currently) 580 KB cache file.

```zsh
if (( $+builtins[zstat] )); then
  stat_cmd=(zstat +mtime)
else
  # existing bsd vs coreutils switch
fi
```

I'd written and tested a change, and was working on the rationale for the commit message.

# 🔎 Who loaded `zsh/stat` so that it shadows `stat`?

I was fairly late to switch to zsh, and when I finally did, [zsh4humans v4](https://github.com/romkatv/zsh4humans/tree/v4) had a compelling sales pitch:

> A turnkey configuration for Z shell that aims to work really well out of the box. It combines the best Zsh plugins into a coherent whole that feels like a finished product rather than a DIY starter kit.
> If you want a great shell that just works, this project is for you.

I wasn't interested in the SSH-based features, and turned them off. I made some basic changes to the config, and it's been working great for me. So much so, that I never switched to the v5 branch, and was disappointed to read the author has moved onto other things. I certainly understand though, since it looked like many "Issues" raised ended up with him effectively volunteering his time to help folks debug their shell configurations.

So when I tracked down the `zmodload zsh/stat` in [main.sh](https://github.com/romkatv/zsh4humans/blob/caf55d974e4cbae2ccb1e09ba832664426bef524/main.zsh#L39) and then found it was [fixed in v5](https://github.com/romkatv/zsh4humans/issues/173) almost two years ago, it felt like this whole journey was self-imposed.

There were many spots where `zsh/stat` _was_ loaded as recommended, so that it only adds the `zstat` builtin. If `zsh` has a debugging feature for showing where a module is loaded, I never found it. Instead it was looking through the various config files, and using a multi-file grep, which was hindered by the fact this specific `zmodload` command used globbing features to load several modules at once, and it wasn't a direct textual match for `zsh/stat`.

Anyway, if your code is calling `stat` with `-f` or `--format`, and you're unexpectedly getting all the fields, you might be inadvertently using `zstat`.

I guess it's _possible_ that someone, someday, will also have `zsh/stat` fully loaded, and the completion script will break on the same line. If so, maybe it's worth [filing an issue](https://github.com/zsh-users/zsh-completions/issues)? Until then, it feels like a misconfiguration of _my_ environment, and not worth handling in this obscure location.
