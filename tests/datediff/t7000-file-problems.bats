#!/usr/bin/env bats

load fixture

@test "non-existing single FILE" {
    LC_MESSAGES=C run -5 datediff --file doesNotExist
    assert_output 'cat: doesNotExist: No such file or directory'
}

@test "compare diff with non-existing single FILE" {
    LC_MESSAGES=C run -5 datediff --file doesNotExist -lt 1h
    assert_output 'cat: doesNotExist: No such file or directory'
}

@test "non-existing second FILE" {
    LC_MESSAGES=C run -5 --separate-stderr datediff --file "${BATS_TEST_DIRNAME}/dates.txt" --file doesNotExist
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
EOF
    output="$stderr" assert_output 'cat: doesNotExist: No such file or directory'
}

@test "compare diff with non-existing second FILE" {
    LC_MESSAGES=C run -5 datediff --file "${BATS_TEST_DIRNAME}/dates.txt" --file doesNotExist -lt 1h
    assert_output 'cat: doesNotExist: No such file or directory'
}

@test "empty input exits with 99" {
    run -99 datediff --file /dev/null
    assert_output ''
}

@test "compare timespan with empty input exits with 99" {
    run -99 datediff --file /dev/null --within day
    assert_output ''
}

@test "invalid date in FILE exits with 4" {
    run -4 datediff --file - <<'EOF'
2026-04-20 09:59:59
notADate
2026-04-21 10:10:10
EOF
}

@test "compare diff with invalid date in FILE exits with 4" {
    run -4 datediff --file - -lt 1h <<-EOF
2026-04-20 09:59:59
notA dateHere
2026-04-20 10:10:10
EOF

    run -4 datediff --file - -lt 1h <<-EOF
2026-04-20 09:59:59
notA dateHere
2026-04-20 11:00:00
EOF
}

@test "empty line in FILE is ignored" {
    run -0 datediff --file - <<'EOF'

2026-04-20 09:59:59


2026-04-21 10:10:10
EOF
    assert_output - <<'EOF'

1 second ago


in 1450 minutes = 24.2 hours = 1 day = 0.1 weeks
EOF
}

@test "compare diff with empty line in FILE is ignored" {
    run -0 datediff --file - -lt 1h <<-EOF
2026-04-20 09:59:59

2026-04-20 10:10:10
EOF
    assert_output ''

    run -1 datediff --file - -lt 1h <<-EOF
2026-04-20 09:59:59

2026-04-20 11:00:00
EOF
    assert_output ''
}

@test "empty date in FILE is ignored" {
    run -0 datediff --file - <<'EOF'
	no date here
2026-04-20 09:59:59
	neither here
	empty as well
2026-04-21 10:10:10
EOF
    assert_output - <<'EOF'
	no date here
1 second ago
	neither here
	empty as well
in 1450 minutes = 24.2 hours = 1 day = 0.1 weeks
EOF
}

@test "compare diff with empty date in FILE is ignored" {
    run -0 datediff --file - -lt 1h <<'EOF'
	no date here
2026-04-20 09:59:59
	neither here
	empty as well
2026-04-20 10:10:10
EOF
    assert_output ''

    run -1 datediff --file - -lt 1h <<'EOF'
	no date here
2026-04-20 09:59:59
	neither here
	empty as well
2026-04-20 11:00:00
EOF
    assert_output ''
}
