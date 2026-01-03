# Git Configuration Guide

This guide will help you understand and customize your `.gitconfig` file, enabling you to enhance your Git experience with custom settings, aliases, and color configurations. Below is an explanation of the key sections and configuration options commonly found in the `.gitconfig` file.

For the full file see [configs/.gitconfig](./configs/.gitconfig).

## Table of Contents

- [[user]](#user)
- [[color]](#color)
- [[alias]](#alias)
- [[push]](#push)
- [[core]](#core)
- [[interactive]](#interactive)
- [[merge]](#merge)
- [[pull]](#pull)
- [[init]](#init)
- [[delta]](#delta)

      
![divider](./docs/images/divider-space-op.png)   
   

## [user]

Git requires you to set a user name and email address, which will be associated with your commits. These details are crucial because they help identify who made each change. You can set these globally (for all repositories) or locally (for a specific repository).

### Set User Name and Email Globally
To set your user name and email for all Git repositories on your machine, use the following commands:

```bash
git config --global user.name "Your Name"
git config --global user.email "youremail@example.com"
```

This will configure Git to use the provided name and email address for all repositories you work with.

      
![divider](./docs/images/divider-space-op.png)   
   

## [color]
The `[color]` section allows you to customize the colors used by Git for various output, making it easier to read and navigate the status and logs.

### Explanation:
- `ui = true`: Enables color output in Git's user interface (e.g., `git status`, `git log`).
- `status = true`: Colors the output of the `git status` command.
- `added = green`: The color to use when indicating added files (green).
- `changed = yellow`: The color to use for modified files (yellow).
- `untracked = cyan`: The color for untracked files (cyan).

### Example:

```
[color]
    ui = true
    status = true
    [color "status"]
        added = green
        changed = yellow
        untracked = cyan
```

With this configuration, your `git status` output will use green for added files, yellow for modified files, and cyan for untracked files.

      
![divider](./docs/images/divider-space-op.png)   
   

## [alias]
Aliases allow you to create shortcuts for long Git commands. This section enables you to define custom commands that are easier to remember and faster to type.

### Explanation:
- `lg = log --graph ...`: Creates a custom `git lg` command that shows a graphical representation of your Git log, making it easy to visualize commits, branches, and merges.
- `hist = log --graph ...`: Similar to `lg`, but this includes the full history and all branches.
- `sl = !GIT_CURRENT_BRANCH=$(git name-rev --name-only HEAD) && git shortlog origin/master..$GIT_CURRENT_BRANCH`: Lists commits that have not been pushed to the master branch.
- `st = status`: A simple alias for `git status`.
- `a = add -A`: A shortcut for `git add .` to stage all changes.
- `cm = commit -am`: A shortcut for `git commit -am` to add and commit in a single command.
- `unpushed = !GIT_CURRENT_BRANCH=$(git name-rev --name-only HEAD) && git log origin/$GIT_CURRENT_BRANCH..$GIT_CURRENT_BRANCH --one\
line`: Shows commits that have not been pushed to the remote repository.
- `ls = for-each-ref ...`: Displays the last 10 branches, showing the relative time since they were committed.

### Example:

```
[alias]
    lg = log --graph --pretty=format:'%Cred%h%Creset %C(yellow)%ad%Creset %C(white)%s%Creset %C(bold yellow)%d%Creset %C(bold blue)<%an>%Creset' --date=short
    hist = log --graph --full-history --all --pretty=format:'%Cred%h%Creset %C(yellow)%ad%Creset %C(white)%s%Creset %C(bold yellow)%d%Creset %C(bold blue)<%an>%Creset' --date=short
    sl = !GIT_CURRENT_BRANCH=$(git name-rev --name-only HEAD) && git shortlog origin/master..$GIT_CURRENT_BRANCH
    st = status
    a = add -A
    cm = commit -am 
    unpushed = !GIT_CURRENT_BRANCH=$(git name-rev --name-only HEAD) && git log origin/$GIT_CURRENT_BRANCH..$GIT_CURRENT_BRANCH --one\
line
    ls = for-each-ref --sort=-committerdate refs/heads/ --count=10 --format='%(color:yellow)%(committerdate:relative)%(color:reset) %09 %(color:reset)%(if)%(HEAD)%(then)%(color:green)%(end) %(HEAD) %(refname:short)'
```

With these aliases in place, you can use commands like `git lg` for a quick graphical log and `git sl` to list commits that have not been pushed to `master`.

      
![divider](./docs/images/divider-space-op.png)   
   

## [push]
This section contains settings related to pushing changes to remotes.

### Explanation:
- `default = simple`: Configures Git to use the "simple" push behavior, meaning that it will only push the current branch to the remote branch of the same name.

### Example:

```
[push]
    default = simple
```

This ensures that only the current branch is pushed to the remote repository.

      
![divider](./docs/images/divider-space-op.png)   
   

## [core]
The `[core]` section controls various core Git settings.

### Explanation:
- `excludesFile = ~/.gitignore_global`: Specifies the location of a global `.gitignore` file, allowing you to ignore files across all repositories.
- `pager = delta`: Configures Git to use the `delta` tool for paginating output, which provides a rich diff display.

### Example:

```
[core]
    excludesFile = ~/.gitignore_global
    pager = delta
```

This configuration makes use of a global `.gitignore` file and ensures that the `delta` tool is used for better paginated output in commands like `git diff`.

      
![divider](./docs/images/divider-space-op.png)   
   

## [interactive]
This section contains settings related to Git's interactive features.

### Explanation:
- `diffFilter = delta --color-only`: Configures Git to use the `delta` tool for displaying diffs during interactive operations, adding syntax highlighting and color.

### Example:

```
[interactive]
    diffFilter = delta --color-only
```

This ensures that diffs shown during interactive operations are enhanced with color via `delta`.

      
![divider](./docs/images/divider-space-op.png)   
   

## [merge]
The `[merge]` section defines merge tool settings.

### Explanation:
- `tool = opendiff`: Specifies the merge tool to use (in this case, `opendiff`, which is macOS's file comparison tool).
- `conflictstyle = diff3`: Configures Git to use a "diff3" style for showing merge conflicts, which includes the common ancestor's version, the current branch, and the other branch.

### Example:

```
[merge]
    tool = opendiff
    conflictstyle = diff3
```

This setup uses `opendiff` for merging and displays conflicts in a more understandable format.

### diff3

The `conflictstyle` setting in Git defines how merge conflicts are displayed. By setting `conflictstyle = diff3`, Git shows more context when there is a conflict during a merge.

Default diffs are show in the following format:

```
<<<<<<< HEAD
Changes from the current branch
=======
Changes from the branch being merged
>>>>>>> other-branch
```


With `diff3`, the conflict is displayed with the following format:

```
<<<<<<< HEAD
Changes from the current branch
||||||| merged common ancestors
Original code before any changes
=======
Changes from the branch being merged
>>>>>>> other-branch
```

#### Why Use `diff3`?

- **Context Awareness**: Shows the common ancestor's version of the code, making it easier to understand the conflict in context.
- **Easier Conflict Resolution**: More context makes it easier to resolve the conflict because you can see how both branches have diverged from the common ancestor.
- **Helps with Complex Merges**: Especially useful for resolving conflicts in large or complex merges, as it provides clarity on what has changed and what the original code was.


Using `diff3` improves conflict resolution by giving you the context of both branches and the common ancestor, making it easier to resolve merge conflicts effectively.


      
![divider](./docs/images/divider-space-op.png)   
   

## [pull]
This section controls how Git handles `git pull` operations.

### Explanation:
- `rebase = false`: Ensures that `git pull` performs a merge instead of a rebase, preserving the commit history.

### Example:

```
[pull]
    rebase = false
```

This setting prevents `git pull` from rebasing, which can be helpful in preserving the history of merges.

      
![divider](./docs/images/divider-space-op.png)   
   

## [init]
This section defines default settings for new Git repositories.

### Explanation:
- `defaultBranch = main`: Sets the default branch name to `main` when initializing a new repository.

### Example:

```
[init]
    defaultBranch = main
```

This configuration ensures that any new repository you create will use `main` as the default branch, rather than the default `master`.

      
![divider](./docs/images/divider-space-op.png)   
   

## [delta]
The `[delta]` section configures the `delta` diff viewer, which is used to enhance the diff output in Git.

### Explanation:
- `navigate = true`: Enables navigation in diffs (e.g., jumping to specific lines).
- `line-numbers = true`: Displays line numbers in the diff output.
- `hyperlinks = true`: Adds clickable links for references in the diff.
- `true-color = always`: Forces true color support in diffs.
- `syntax-theme = Dracula`: Sets the syntax theme for diffs to `Dracula`.
- `tabs = 2`: Sets the number of spaces to use for tab characters in diffs.

### Example:

```
[delta]
    navigate = true
    line-numbers = true
    hyperlinks = true
    true-color = always
    syntax-theme = Dracula
    tabs = 2
```

This configuration enhances your Git diff output with features like line numbers, syntax highlighting (with the `Dracula` theme), and clickable hyperlinks.

