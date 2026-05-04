#!/usr/bin/env bats

load fixture

@test "diff with output in seconds" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2026-04-20 09:59:59]='-1'
	[2026-04-19 10:00:00]='-86400'
	[2026-04-21 10:00:00]='86400'
	[2026-04-21 12:32:48]='95568'
	[2026-05-12 20:05:00]='1937100'
	[2026-06-01]='3592800'
	[2027-01-01]='22086000'
	[1976-10-20]='-1562058000'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output seconds '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in minutes" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2026-04-20 09:59:59]='0'
	[2026-04-19 10:00:00]='-1440'
	[2026-04-21 10:00:00]='1440'
	[2026-04-21 12:32:48]='1593'
	[2026-05-12 20:05:00]='32285'
	[2026-06-01]='59880'
	[2027-01-01]='368100'
	[1976-10-20]='-26034300'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output minutes '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in hours" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2026-04-20 09:59:59]='0'
	[2026-04-19 10:00:00]='-24'
	[2026-04-21 10:00:00]='24'
	[2026-04-21 12:32:48]='26'
	[2026-05-12 20:05:00]='538'
	[2026-06-01]='998'
	[2027-01-01]='6135'
	[1976-10-20]='-433905'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output hours '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in days" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2026-04-20 09:59:59]='0'
	[2026-04-19 10:00:00]='-1'
	[2026-04-21 10:00:00]='1'
	[2026-04-21 12:32:48]='1'
	[2026-05-12 20:05:00]='22'
	[2026-06-01]='42'
	[2027-01-01]='256'
	[1976-10-20]='-18079'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output days '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in weeks" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2026-04-20 09:59:59]='0'
	[2026-04-19 10:00:00]='0'
	[2026-04-21 10:00:00]='0'
	[2026-04-21 12:32:48]='0'
	[2026-05-12 20:05:00]='3'
	[2026-06-01]='6'
	[2027-01-01]='36'
	[1976-10-20]='-2583'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output weeks '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in months" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2026-04-20 09:59:59]='0'
	[2026-04-19 10:00:00]='0'
	[2026-04-21 10:00:00]='0'
	[2026-04-21 12:32:48]='0'
	[2026-05-12 20:05:00]='0'
	[2026-06-01]='1'
	[2027-01-01]='8'
	[1976-10-20]='-602'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output months '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in years" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2026-04-20 09:59:59]='0'
	[2026-04-19 10:00:00]='0'
	[2026-04-21 10:00:00]='0'
	[2026-04-21 12:32:48]='0'
	[2026-05-12 20:05:00]='0'
	[2026-06-01]='0'
	[2027-01-01]='0'
	[1976-10-20]='-49'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output years '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in generations" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2026-04-20 09:59:59]='0'
	[2026-04-19 10:00:00]='0'
	[2026-04-21 10:00:00]='0'
	[2026-04-21 12:32:48]='0'
	[2026-05-12 20:05:00]='0'
	[2026-06-01]='0'
	[2027-01-01]='0'
	[1976-10-20]='-2'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output generations '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in whole units" {
    typeset -A data=(
	[2026-04-20 10:00:00]='at a single point in time'
	[2026-04-20 09:59:59]='-1 second'
	[2026-04-19 10:00:00]='-1440 minutes = -24 hours = -1 day'
	[2026-04-21 10:00:00]='1440 minutes = 24 hours = 1 day'
	[2026-04-21 12:32:48]='1593 minutes = 26.5 hours = 1.1 days'
	[2026-05-12 20:05:00]='538.1 hours = 22.4 days = 3.1 weeks'
	[2026-06-01]='998 hours = 41.6 days = 6 weeks = 1.4 months'
	[2027-01-01]='6135 hours = 255.6 days = 36.6 weeks = 8.5 months'
	[1976-10-20]='-2583 weeks = -602.6 months = -49.5 years = -2 generations'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output whole-units '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in smallest unit" {
    typeset -A data=(
	[2026-04-20 10:00:00]='at a single point in time'
	[2026-04-20 09:59:59]='-1 second'
	[2026-04-19 10:00:00]='-1440 minutes'
	[2026-04-21 10:00:00]='1440 minutes'
	[2026-04-21 12:32:48]='1593 minutes'
	[2026-05-12 20:05:00]='538.1 hours'
	[2026-06-01]='998 hours'
	[2027-01-01]='6135 hours'
	[1976-10-20]='-2583 weeks'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output smallest-unit '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in best unit" {
    typeset -A data=(
	[2026-04-20 10:00:00]='at a single point in time'
	[2026-04-20 09:59:59]='-1 second'
	[2026-04-19 10:00:00]='-1 day'
	[2026-04-21 10:00:00]='1 day'
	[2026-04-21 12:32:48]='1.1 days'
	[2026-05-12 20:05:00]='3.1 weeks'
	[2026-06-01]='1.4 months'
	[2027-01-01]='8.5 months'
	[1976-10-20]='-2 generations'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output best-unit '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in largest unit" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0 seconds'
	[2026-04-20 09:59:59]='-1 second'
	[2026-04-19 10:00:00]='-0.1 weeks'
	[2026-04-21 10:00:00]='0.1 weeks'
	[2026-04-21 12:32:48]='0.1 weeks'
	[2026-05-12 20:05:00]='0.7 months'
	[2026-06-01]='0.1 years'
	[2027-01-01]='0.7 years'
	[1976-10-20]='-2 generations'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output largest-unit '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with default output (all)" {
    typeset -A data=(
	[2026-04-20 10:00:00]='at a single point in time = 0 seconds'
	[2026-04-20 09:59:59]='-1 second'
	[2026-04-19 10:00:00]='-1440 minutes = -24 hours = -1 day = -0.1 weeks'
	[2026-04-21 10:00:00]='1440 minutes = 24 hours = 1 day = 0.1 weeks'
	[2026-04-21 12:32:48]='1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks'
	[2026-05-12 20:05:00]='538.1 hours = 22.4 days = 3.1 weeks = 0.7 months'
	[2026-06-01]='998 hours = 41.6 days = 6 weeks = 1.4 months = 0.1 years'
	[2027-01-01]='6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years'
	[1976-10-20]='-2583 weeks = -602.6 months = -49.5 years = -2 generations'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output all '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output set via DATEDIFF_OUTPUT_FORMAT environment variable" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0'
	[2026-04-20 09:59:59]='0'
	[2026-04-19 10:00:00]='0'
	[2026-04-21 10:00:00]='0'
	[2026-04-21 12:32:48]='0'
	[2026-05-12 20:05:00]='0'
	[2026-06-01]='1'
	[2027-01-01]='8'
	[1976-10-20]='-602'
    )

    for date in "${!data[@]}"
    do
	DATEDIFF_OUTPUT_FORMAT=months run -0 datediff '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output as textform" {
    typeset -A data=(
	[2026-04-20 10:00:00]='[at a single point in time|0 seconds|at a single point in time = 0 seconds]'
	[2026-04-20 09:59:59]='[-1 second]'
	[2026-04-19 10:00:00]='[-1440 minutes|-24 hours|-1 day|-0.1 weeks|-1440 minutes = -24 hours = -1 day = -0.1 weeks]'
	[2026-04-21 10:00:00]='[1440 minutes|24 hours|1 day|0.1 weeks|1440 minutes = 24 hours = 1 day = 0.1 weeks]'
	[2026-04-21 12:32:48]='[1593 minutes|26.5 hours|1.1 days|0.1 weeks|1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks]'
	[2026-05-12 20:05:00]='[538.1 hours|22.4 days|3.1 weeks|0.7 months|538.1 hours = 22.4 days = 3.1 weeks = 0.7 months]'
	[2026-06-01]='[998 hours|41.6 days|6 weeks|1.4 months|0.1 years|998 hours = 41.6 days = 6 weeks = 1.4 months = 0.1 years]'
	[2027-01-01]='[6135 hours|255.6 days|36.6 weeks|8.5 months|0.7 years|6135 hours = 255.6 days = 36.6 weeks = 8.5 months = 0.7 years]'
	[1976-10-20]='[-2583 weeks|-602.6 months|-49.5 years|-2 generations|-2583 weeks = -602.6 months = -49.5 years = -2 generations]'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --output textform '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}
