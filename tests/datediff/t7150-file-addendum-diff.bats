#!/usr/bin/env bats

load fixture

@test "single time and addendum read from stdin against passed time" {
    run -0 datediff --file - '10:00' <<< $'10:00:02\taddendum'
    assert_output $'2 seconds\taddendum'
}

@test "single date and addendum read from stdin against now" {
    run -0 datediff --file - <<< $'2026-04-20 09:59:59\twith\taddendum'
    assert_output $'1 second ago\twith\taddendum'
}

@test "single date and addendum read from stdin against now with suffix" {
    run -0 datediff --suffix ' SUFFIX' --file - <<< $'2026-04-20 09:59:59\twith\taddendum'
    assert_output $'1 second ago SUFFIX\twith\taddendum'
}

@test "dates and addenda read from file against passed date" {
    run -0 datediff --file "${BATS_TEST_DIRNAME}/dates-addenda.tsv" '2026-04-20 10:00'
    assert_output - <<'EOF'
at a single point in time = 0 seconds	the time is now
-1 second	just before the time
-1440 minutes = -24 hours = -1 day = -0.1 weeks	the day before
1440 minutes = 24 hours = 1 day = 0.1 weeks	the day after
840 minutes = 14 hours = 0.6 days = 0.1 weeks	  midnight
1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks = 1d 02:32:48	a random time
264 hours = 11 days = 1.6 weeks = 0.4 months = 1w 4d	next month
538.1 hours = 22.4 days = 3.1 weeks = 0.7 months = 3w 1d 10h 5m
	
	from here, without times
998 hours = 41.6 days = 6 weeks = 1.4 months = 0.1 years = 1mo 1w 4d 4h	next next month, without time
2462 hours = 102.6 days = 14.7 weeks = 3.4 months = 0.3 years = 3mo 1w 4d 8h	
6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years = 8mo 1w 5d 7h	next year

-2583 weeks = -602.6 months = -49.5 years = -2 generations = -1g 19y 6mo 4d 14h 24m	a long long time ago
EOF
}
