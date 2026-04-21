#!/usr/bin/env bats

load fixture

nowRun()
{
    NOW=1776672000 run "$@"
}


@test "diff between now and date uses in ... / ... ago / just now" {
    typeset -A data=(
	[2026-04-20 10:00:00]='just now = 0 seconds'
	[2026-04-20 09:59:59]='1 second ago'
	[2026-04-19 10:00:00]='1440 minutes = 24 hours = 1 day = 0.1 weeks ago'
	[2026-04-21 10:00:00]='in 1440 minutes = 24 hours = 1 day = 0.1 weeks'
	[2026-04-21 00:00:00]='in 840 minutes = 14 hours = 0.6 days = 0.1 weeks'
	[2026-04-21 12:32:48]='in 1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks'
	[2026-05-01 10:00:00]='in 264 hours = 11 days = 1.6 weeks = 0.4 months'
	[2026-05-12 20:05:00]='in 538.1 hours = 22.4 days = 3.1 weeks = 0.7 months'
	[2026-06-01]='in 998 hours = 41.6 days = 6 weeks = 1.4 months = 0.1 years'
	[2026-08-01]='in 2462 hours = 102.6 days = 14.7 weeks = 3.4 months = 0.3 years'
	[2027-01-01]='in 6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years'
	[1976-10-20]='2583 weeks = 602.6 months = 49.5 years = 2 generations ago'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "absolute diff between now and date works like absolute diff between two dates" {
    typeset -A data=(
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

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --absolute "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in seconds" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2027-01-01]='22086000'
	[1976-10-20]='-1562058000'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output seconds "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in minutes" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2027-01-01]='368100'
	[1976-10-20]='-26034300'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output minutes "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in hours" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2027-01-01]='6135'
	[1976-10-20]='-433905'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output hours "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in days" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2027-01-01]='256'
	[1976-10-20]='-18079'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output days "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in weeks" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2027-01-01]='36'
	[1976-10-20]='-2583'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output weeks "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in months" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2027-01-01]='8'
	[1976-10-20]='-602'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output months "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in years" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2027-01-01]='0'
	[1976-10-20]='-49'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output years "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in generations" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2027-01-01]='0'
	[1976-10-20]='-2'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output generations "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in whole units" {
    typeset -A data=(
	[2026-04-20 10:00:00]='just now'
	[2027-01-01]='in 6135 hours = 255.6 days = 36.6 weeks = 8.5 months'
	[1976-10-20]='2583 weeks = 602.6 months = 49.5 years = 2 generations ago'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output whole-units "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in smallest unit" {
    typeset -A data=(
	[2026-04-20 10:00:00]='just now'
	[2027-01-01]='in 6135 hours'
	[1976-10-20]='2583 weeks ago'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output smallest-unit "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in best unit" {
    typeset -A data=(
	[2026-04-20 10:00:00]='just now'
	[2027-01-01]='in 8.5 months'
	[1976-10-20]='2 generations ago'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output best-unit "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output in largest unit" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0 seconds'
	[2027-01-01]='in 0.7 years'
	[1976-10-20]='2 generations ago'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output largest-unit "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}

@test "diff to now with output as textform" {
    typeset -A data=(
	[2026-04-20 10:00:00]='[just now|0 seconds|just now = 0 seconds]'
	[2027-01-01]='[in 6135 hours|in 255.6 days|in 36.6 weeks|in 8.5 months|in 0.7 years|in 6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years]'
	[1976-10-20]='[2583 weeks ago|602.6 months ago|49.5 years ago|2 generations ago|2583 weeks = 602.6 months = 49.5 years = 2 generations ago]'
    )

    for date in "${!data[@]}"
    do
	nowRun -0 datediff --output textform "$date"
	assert_output "${data["$date"]}" || fail "$date"
    done
}
