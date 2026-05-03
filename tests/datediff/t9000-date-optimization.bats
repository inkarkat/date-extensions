#!/usr/bin/env bats

load fixture

@test "date is not invoked when the dates are epoch seconds already" {
    date() { exit 42; }; export -f date
    run -0 datediff @1776672060
    assert_output 'in 60 seconds = 1 minute'

    run -0 datediff @$NOW @1776672060
    assert_output '60 seconds = 1 minute'
}
