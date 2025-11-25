# crbin

`crbin` (Clearly Random Binary) is a small utility that executes a randomly
chosen executable file from a configurable set of directories. The program
randomly chooses a binary from default or provided directories and
simply invokes theselected binary with any arguments passed to `crbin`.

## Overview

On each invocation, `crbin`:

1. Scans one or more filesystem directories for executable regular files.
2. Chooses one random binary entry.
3. Executes the chosen path.

## Usage

```
crbin [arguments...]
```

## Directory Selection

By default, the following directories are scanned:

```
/bin
/usr/bin
/usr/local/bin
/sbin
/usr/sbin
/usr/local/sbin
```

Scanning is non-recursive unless explicitly enabled.

## Environment Variables

### `BINDIRECTORIES`

Overrides the default directory list.
Value must be a comma-separated list of absolute paths.

Example:

```
export BINDIRECTORIES="/bin,/usr/bin,/home/user/tools"
```

### `RECURSE`

Controls recursive traversal.

```
RECURSE=1       enable recursion
RECURSE=unset   disable recursion (default)
```

Example:

```
export RECURSE=1
```

## Argument Forwarding

All arguments provided to `crbin` are forwarded unchanged to the randomly
chosen executable.

Example:

```
crbin --version
```

The executed binary receives `--version` regardless of whether it supports it.

## Building

A C compiler such as GCC or Clang is required.

```
gcc crbin.c -o crbin
```

## Installation

System-wide installation:

```
sudo install -m 755 crbin /usr/local/bin/crbin
```

User-local installation:

```
install -m 755 crbin "$HOME/.local/bin/crbin"
```

Examples:

```
crbin
crbin --help
crbin -rf /
BINDIRECTORIES="/bin" crbin
RECURSE=1 crbin
```

## Warning

`crbin` intentionally implements no protection against executing programs that
may modify system state, terminate the current session, or affect running
processes. Running `crbin` as `root` or via `sudo` is strongly unrecommended.

## License

`crbin` is licensed under the GNU General Public License v3.0 or (at your
option) any later version. See the source header for complete terms.
