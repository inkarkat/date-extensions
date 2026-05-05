#!/usr/bin/env bats

load fixture

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
at a single point in time = 0 seconds
-1 second
-1440 minutes = -24 hours = -1 day = -0.1 weeks
1440 minutes = 24 hours = 1 day = 0.1 weeks
840 minutes = 14 hours = 0.6 days = 0.1 weeks
1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks = 1d 02:32:48
264 hours = 11 days = 1.6 weeks = 0.4 months = 1w 4d
538.1 hours = 22.4 days = 3.1 weeks = 0.7 months = 3w 1d 10h 5m
998 hours = 41.6 days = 6 weeks = 1.4 months = 0.1 years = 1mo 1w 4d 4h
2462 hours = 102.6 days = 14.7 weeks = 3.4 months = 0.3 years = 3mo 1w 4d 8h
6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years = 8mo 1w 5d 7h
-2583 weeks = -602.6 months = -49.5 years = -2 generations = -1g 19y 6mo 4d 14h 24m
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
in 1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks = 1d 02:32:48
in 264 hours = 11 days = 1.6 weeks = 0.4 months = 1w 4d
in 538.1 hours = 22.4 days = 3.1 weeks = 0.7 months = 3w 1d 10h 5m
in 998 hours = 41.6 days = 6 weeks = 1.4 months = 0.1 years = 1mo 1w 4d 4h
in 2462 hours = 102.6 days = 14.7 weeks = 3.4 months = 0.3 years = 3mo 1w 4d 8h
in 6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years = 8mo 1w 5d 7h
2583 weeks = 602.6 months = 49.5 years = 2 generations = 1g 19y 6mo 4d 14h 24m ago
1 second ago
EOF
}
