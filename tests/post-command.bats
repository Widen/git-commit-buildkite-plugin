#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

export GIT_STUB_DEBUG=/dev/tty

post_command_hook="$PWD/hooks/post-command"

@test "Commits all changes" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "add -A . : echo add" \
    "diff-index --quiet HEAD : false" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Committing changes"
  assert_output --partial "--- Pushing master to origin"
  unstub git
}

@test "Configures git user.name" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  export BUILDKITE_PLUGIN_GIT_COMMIT_USER_NAME=Robot

  stub git \
    "config user.name \"Robot\" : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "add -A . : echo add" \
    "diff-index --quiet HEAD : false" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Committing changes"
  assert_output --partial "--- Pushing master to origin"
  unstub git
}

@test "Configures git user.email" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  export BUILDKITE_PLUGIN_GIT_COMMIT_USER_EMAIL="bot@example.com"

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email \"bot@example.com\" : echo config.email" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "add -A . : echo add" \
    "diff-index --quiet HEAD : false" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Committing changes"
  assert_output --partial "--- Pushing master to origin"
  unstub git
}

@test "Pushes to a specific remote" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  export BUILDKITE_PLUGIN_GIT_COMMIT_REMOTE=upstream

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "fetch upstream master:master : echo fetch" \
    "checkout master : echo checkout" \
    "add -A . : echo add" \
    "diff-index --quiet HEAD : false" \
    "commit -m \"Build #1\" : echo commit" \
    "push upstream master : echo push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Committing changes"
  assert_output --partial "--- Pushing master to upstream"
  unstub git
}

@test "Pushes to a specific branch" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  export BUILDKITE_PLUGIN_GIT_COMMIT_BRANCH=code-orange

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "fetch origin code-orange:code-orange : echo fetch" \
    "checkout code-orange : echo checkout" \
    "add -A . : echo add" \
    "diff-index --quiet HEAD : false" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin code-orange : echo push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Committing changes"
  assert_output --partial "--- Pushing code-orange to origin"
  unstub git
}

@test "Creates and pushes to a specific branch" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  export BUILDKITE_PLUGIN_GIT_COMMIT_BRANCH=code-orange
  export BUILDKITE_PLUGIN_GIT_COMMIT_CREATE_BRANCH=true

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "checkout -b code-orange : echo checkout" \
    "add -A . : echo add" \
    "diff-index --quiet HEAD : false" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin code-orange : echo push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Committing changes"
  assert_output --partial "--- Pushing code-orange to origin"
  unstub git
}

@test "Allows a custom message" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  export BUILDKITE_PLUGIN_GIT_COMMIT_MESSAGE="Good Morning!"

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "add -A . : echo add" \
    "diff-index --quiet HEAD : false" \
    "commit -m \"Good Morning!\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Committing changes"
  assert_output --partial "--- Pushing master to origin"
  unstub git
}

@test "Creates a tag with commit" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  export BUILDKITE_PLUGIN_GIT_COMMIT_TAG="v1.0.0"
  export BUILDKITE_PLUGIN_GIT_COMMIT_TAG_MESSAGE="Buildkite Test"

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "add -A . : echo add" \
    "diff-index --quiet HEAD : false" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin master : echo push" \
    "tag -f -a \"v1.0.0\" -m \"Buildkite Test\" : echo tag" \
    "push -f origin --tags \"v1.0.0\" : echo tag push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Committing changes"
  assert_output --partial "--- Pushing master to origin"
  assert_output --partial "--- Tagging with v1.0.0"
  assert_output --partial "--- Pushing tag to origin"
  unstub git
}

@test "Creates a tag without commit" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master

  export BUILDKITE_PLUGIN_GIT_COMMIT_TAG="v1.0.0"
  export BUILDKITE_PLUGIN_GIT_COMMIT_TAG_MESSAGE="Buildkite Test"

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "tag -f -a \"v1.0.0\" -m \"Buildkite Test\" : echo tag" \
    "push -f origin --tags \"v1.0.0\" : echo tag push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Tagging with v1.0.0"
  assert_output --partial "--- Pushing tag to origin"
  unstub git
}

@test "Adds a specified pathspec" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="app"

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "add -A app : echo add" \
    "diff-index --quiet HEAD : false" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Committing changes"
  assert_output --partial "--- Pushing master to origin"
  unstub git
}

@test "Skip commit when there are no changes" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="."

  stub git \
    "config user.name Buildkite\ CI : echo config.name" \
    "config user.email sre-team@quantopian.com : echo config.email" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "add -A . : echo add" \
    "diff-index --quiet HEAD : true"

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- No changes to commit"
  unstub git
}

@test "Bails out when the command fails" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master

  export BUILDKITE_COMMAND_EXIT_STATUS=127

  run "$post_command_hook"

  assert_success
  assert_output --partial "--- Skipping git-commit"
}
