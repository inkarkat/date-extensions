#!/usr/bin/env bats

load fixture

@test "diff between two times" {
    typeset -A data=(
	[10:00:00]='0 seconds'
	[10:00:01]='1 second'
	[10:00:02]='2 seconds'
	[10:01]='60 seconds = 1 minute'
	[11:00]='3600 seconds = 60 minutes = 1 hour'
	[23:59]='839 minutes = 14 hours = 0.6 days = 0.1 weeks'
	[00:00]='600 minutes = 10 hours = 0.4 days'
	[09:00]='3600 seconds = 60 minutes = 1 hour'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff 10:00 "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}


typeset -rA DATE_DATA=(
    [2026-04-20 10:00:00]='0 seconds'
    [2026-04-20 09:59:59]='1 second'
    [2026-04-19 10:00:00]='1440 minutes = 24 hours = 1 day = 0.1 weeks'
    [2026-04-21 10:00:00]='1440 minutes = 24 hours = 1 day = 0.1 weeks'
    [2026-04-21 00:00:00]='840 minutes = 14 hours = 0.6 days = 0.1 weeks'
    [2026-04-21 12:32:48]='1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks'
    [2026-05-01 10:00:00]='264 hours = 11 days = 1.6 weeks = 0.4 months'
    [2026-05-12 20:05:00]='538.1 hours = 22.4 days = 3.1 weeks = 0.7 months'
    [2026-06-01]='998 hours = 41.6 days = 6 weeks = 1.4 months = 0.1 years'
    [2026-08-01]='2462 hours = 102.6 days = 14.7 weeks = 3.4 months = 0.3 years'
    [2027-01-01]='6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years'
    [1976-10-20]='2583 weeks = 602.6 months = 49.5 years = 2 generations'
)

@test "diff between two dates" {
    for date in "${!DATE_DATA[@]}"
    do
	run -0 datediff '2026-04-20 10:00' "$date"
	assert_output "${DATE_DATA["$date"]}" || fail "$date"
    done
}

@test "diff between now and date" {
    for date in "${!DATE_DATA[@]}"
    do
	NOW=1776672000 run -0 datediff "$date"
	assert_output "${DATE_DATA["$date"]}" || fail "$date"
    done
}
