#!/usr/bin/env bats

load fixture

@test "passed seconds diff" {
    typeset -A data=(
	[0]='just now = 0 seconds'
	[1]='in 1 second'
	[2]='in 2 seconds'
	[60]='in 60 seconds = 1 minute'
	[3600]='in 3600 seconds = 60 minutes = 1 hour'
	[50340]='in 839 minutes = 14 hours = 0.6 days = 0.1 weeks'
	[-36000]='600 minutes = 10 hours = 0.4 days ago'
	[-3600]='3600 seconds = 60 minutes = 1 hour ago'
	[-86400]='1440 minutes = 24 hours = 1 day = 0.1 weeks ago'
	[86400]='in 1440 minutes = 24 hours = 1 day = 0.1 weeks'
	[50400]='in 840 minutes = 14 hours = 0.6 days = 0.1 weeks'
	[95580]='in 1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks'
    )

    for seconds in "${!data[@]}"
    do
	run -0 datediff --seconds "$seconds" || fail "$seconds" \
	    && assert_output "${data["$seconds"]}" \
	    || fail "$seconds"
    done
}

@test "passed days diff" {
    typeset -A data=(
	[0]='today = 0 days'
	[1]='tomorrow = in 1 day'
	[-1]='yesterday = 1 day ago'
	[2]='in 0.3 weeks'
	[-2]='0.3 weeks ago'
	[11]='in 1.6 weeks = 0.4 months'
	[22]='in 3.1 weeks = 0.7 months'
	[42]='in 6 weeks = 1.4 months = 0.1 years'
	[103]='in 14.7 weeks = 3.4 months = 0.3 years'
	[256]='in 36.6 weeks = 8.5 months = 0.7 years'
	[-18081]='2583 weeks = 602.7 months = 49.5 years = 2 generations ago'
    )

    for days in "${!data[@]}"
    do
	run -0 datediff --days "$days" || fail "$days" \
	    && assert_output "${data["$days"]}" \
	    || fail "$days"
    done
}

@test "passed seconds absolute diff" {
    typeset -A data=(
	[0]='0 seconds'
	[-36000]='600 minutes = 10 hours = 0.4 days'
	[3600]='3600 seconds = 60 minutes = 1 hour'
    )

    for seconds in "${!data[@]}"
    do
	run -0 datediff --absolute --seconds "$seconds" || fail "$seconds" \
	    && assert_output "${data["$seconds"]}" \
	    || fail "$seconds"
    done
}

@test "passed days absolute diff" {
    typeset -A data=(
	[0]='0 days'
	[256]='36.6 weeks = 8.5 months = 0.7 years'
	[-18081]='2583 weeks = 602.7 months = 49.5 years = 2 generations'
    )

    for days in "${!data[@]}"
    do
	run -0 datediff --absolute --days "$days" || fail "$days" \
	    && assert_output "${data["$days"]}" \
	    || fail "$days"
    done
}

@test "passed seconds diff --no-direction" {
    typeset -A data=(
	[0]='0 seconds'
	[-36000]='-600 minutes = -10 hours = -0.4 days'
	[3600]='3600 seconds = 60 minutes = 1 hour'
    )

    for seconds in "${!data[@]}"
    do
	run -0 datediff --no-direction --seconds "$seconds" || fail "$seconds" \
	    && assert_output "${data["$seconds"]}" \
	    || fail "$seconds"
    done
}

@test "passed days diff --no-direction" {
    typeset -A data=(
	[0]='0 days'
	[256]='36.6 weeks = 8.5 months = 0.7 years'
	[-18081]='-2583 weeks = -602.7 months = -49.5 years = -2 generations'
    )

    for days in "${!data[@]}"
    do
	run -0 datediff --no-direction --days "$days" || fail "$days" \
	    && assert_output "${data["$days"]}" \
	    || fail "$days"
    done
}
