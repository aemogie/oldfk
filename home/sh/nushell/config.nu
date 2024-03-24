# Convert structured data to a Nix expression.
def "to nix" []: any -> string {
  to json
  | nix eval --expr $"builtins.fromJSON \'\'($in)\'\'"
  | @nixfmt@
};
# Open a file. Show structured data, if possible. Else fallback to `bat`
def o [filename: path] {
  try { open $filename } catch { open --raw $filename }
  | if ($in | describe) == "string" {
    highlight ($filename | path parse).extension -t ansi | @pager@ -F
  } else { $in }
}
# If multiple shells are open, exit current one. If this is the last one, exit completely.
def --env q [] {
  if (shells | length) == 1 { exit } else { dexit }
}

def --env md [name: directory] {
  mkdir $name
  cd $name
}

def --wrapped r [
  program: string,
  ...args: string,
  --no-expand (-n), # Relative paths don't work with the `exec` dispatcher. Enable this flag to disable path expansion.
] {
  let p = (which -a $program)
  if (not ($p | is-empty)) and ("external" in $p.type) {
    let program = ($p | where type == external | first).path;
    if ($no_expand) {
      hyprctl dispatch exec $"($program) ($args | str join ' ')" | ignore
    } else {
      let args = ($args | each {
        if ($in | path exists) {
          $in | path expand
        } else { $in }
      })
      hyprctl dispatch exec $"($program) ($args | str join ' ')" | ignore
    }
  } else {
    error make {
      msg: "program not found",
      label: {
        text: $"could not found program `($program)`!",
        span: (metadata $program).span
      }
    }
  }
}

def e [cwd: path = .] {
  cd ($cwd | path expand)
  if ZELLIJ in $env {
    @z_editor_tab@
  } else {
    @z_editor_new@
  }
}
