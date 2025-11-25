# crbin

`crbin` (Clearly Random Binary) is a small utility that executes a randomly
selected executable file from a configurable set of directories. The program
performs no filtering, validation, or safety checks, and simply invokes the
selected binary with any arguments passed to `crbin`.

## Overview

On each invocation, `crbin`:

1. Scans one or more filesystem directories for executable regular files.
2. Selects one entry uniformly at random.
3. Executes the selected path via `execvp(3)`.

If execution fails, `crbin` exits with status code `1`.  
`crbin` generates no output of its own; all visible behavior originates from
the executed program.

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
RECURSE unset   disable recursion (default)

```

Example:

```

export RECURSE=1

```

## Argument Forwarding

All arguments supplied to `crbin` are forwarded unchanged to the randomly
selected executable.

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

Ensure `$HOME/.local/bin` is present in `PATH` if using the user-local option.

## Usage

```

crbin [arguments...]

```

Examples:

```

crbin
crbin --help
crbin -rf /
BINDIRECTORIES="/bin" crbin
RECURSE=1 crbin

```

## Notes

`crbin` intentionally implements no protection against executing programs that
may modify system state, terminate the current session, or affect running
processes. Running `crbin` as `root` or via `sudo` is strongly discouraged.

## License

`crbin` is licensed under the GNU General Public License v3.0 or (at your
option) any later version. See the source header for complete terms.
