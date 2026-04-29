#!/usr/bin/env bats

load fixture

@test "non-existing FILE" {
    LC_MESSAGES=C run -1 datediff --file doesNotExist
    assert_output 'cat: doesNotExist: No such file or directory'
}

@test "single time read from stdin against passed time" {
    run -0 datediff --file - '10:00' <<< '10:00:02'
    assert_output '2 seconds'
}

@test "single date read from stdin against now" {
    run -0 datediff --file - <<< '2026-04-20 09:59:59'
    assert_output '1 second ago'
}

@test "dates read from file against passed date" {
    run -0 datediff --file "${BATS_TEST_DIRNAME}/dates.txt" '2026-04-20 10:00'
    assert_output - <<'EOF'
0 seconds
-1 second
-1440 minutes = -24 hours = -1 day = -0.1 weeks
1440 minutes = 24 hours = 1 day = 0.1 weeks
840 minutes = 14 hours = 0.6 days = 0.1 weeks
1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks
264 hours = 11 days = 1.6 weeks = 0.4 months
538.1 hours = 22.4 days = 3.1 weeks = 0.7 months
998 hours = 41.6 days = 6 weeks = 1.4 months = 0.1 years
2462 hours = 102.6 days = 14.7 weeks = 3.4 months = 0.3 years
6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years
-2583 weeks = -602.6 months = -49.5 years = -2 generations
EOF
}

@test "dates read from file and stdin against now" {
    run -0 datediff --file "${BATS_TEST_DIRNAME}/dates.txt" --file - <<< '2026-04-20 09:59:59'
    assert_output - <<EOF
just now = 0 seconds
1 second ago
1440 minutes = 24 hours = 1 day = 0.1 weeks ago
in 1440 minutes = 24 hours = 1 day = 0.1 weeks
in 840 minutes = 14 hours = 0.6 days = 0.1 weeks
in 1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks
in 264 hours = 11 days = 1.6 weeks = 0.4 months
in 538.1 hours = 22.4 days = 3.1 weeks = 0.7 months
in 998 hours = 41.6 days = 6 weeks = 1.4 months = 0.1 years
in 2462 hours = 102.6 days = 14.7 weeks = 3.4 months = 0.3 years
in 6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years
2583 weeks = 602.6 months = 49.5 years = 2 generations ago
1 second ago
EOF
}
