{
  flake-edit,
  gh,
  git,
  writeShellApplication,
}:
writeShellApplication {
  name = "gh-flake-update";
  runtimeInputs = [
    flake-edit
    git
    gh
  ];
  text = ''
    branch="flake-update-$(date '+%F')"
    title="Flake update $(date)"
    git checkout -b "$branch"

    (
      echo "$title"
      echo -ne "\n\n\n"
      echo '```shell'
      echo '> $ nix flake update'
      nix flake update 2>&1
      echo '> $ flake-edit follow'
      flake-edit follow 2>&1
      echo '```'
      echo -ne "\n\n\n"
    ) | tee /tmp/commit-message.md

    changes="$(git status -s | grep -o 'M ' | wc -l)"

    if test "$changes" -eq 0; then
      echo "No changes"
      exit 0
    fi

    git status -s | grep 'M ' | cut -d 'M' -f 2 | xargs git add
    git commit -F /tmp/commit-message.md --no-signoff --no-verify --no-edit --cleanup=verbatim
    git push origin "$branch:$branch" --force
    gh pr create --label automated --reviewer quasi-coherent --assignee --quasi-coherent --body-file /tmp/commit-message.md --title "$title" --head "$branch" | tee /tmp/pr-url
  '';
}
