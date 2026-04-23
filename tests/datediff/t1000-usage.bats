#!/usr/bin/env bats

load fixture

@test "no arguments prints message and usage instructions" {
    run -2 datediff
    assert_line -n 0 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
    run -2 datediff --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 1 -e '^Usage:'
}

@test "-h prints long usage help" {
    run -0 datediff -h
    assert_line -n 0 -e '^Usage:'
}

@test "no DATE prints usage" {
    run -2 datediff --utc
    assert_line -n 0 -e '^Usage:'
}

@test "three DATEs prints usage" {
    run -2 datediff 2026-04-20 2026-04-21 2026-04-22
    assert_line -n 0 -e '^Usage:'
}
