#!/usr/bin/env bats

load fixture

@test "diff with unit output formats is not affected by short units" {
    typeset -A data=(
	[seconds]='-1562058000'
	[minutes]='-26034300'
	[hours]='-433905'
	[days]='-18079'
	[weeks]='-2583'
	[months]='-602'
	[years]='-49'
	[generations]='-2'
    )

    for outputFormat in "${!data[@]}"
    do
	run -0 datediff --short-units --output "$outputFormat" '1976-10-20' \
	    && assert_output "${data["$outputFormat"]}" \
	    || fail "$ --output outputFormat"
    done
}

@test "diff with output in whole units" {
    typeset -A data=(
	[2026-04-20 10:00:00]='at a single point in time'
	[2026-04-20 09:59:59]='-1s'
	[2026-04-19 10:00:00]='-1440m = -24h = -1d'
	[2026-04-21 10:00:00]='1440m = 24h = 1d'
	[2026-04-21 12:32:48]='1593m = 26.5h = 1.1d'
	[2026-05-12 20:05:00]='538.1h = 22.4d = 3.1w'
	[2026-06-01]='998h = 41.6d = 6w = 1.4mo'
	[2027-01-01]='6135h = 255.6d = 36.6w = 8.5mo'
	[1976-10-20]='-2583w = -602.6mo = -49.5y = -2g'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --short-units --output whole-units '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in smallest unit" {
    typeset -A data=(
	[2026-04-20 10:00:00]='at a single point in time'
	[2026-04-20 09:59:59]='-1s'
	[2026-04-19 10:00:00]='-1440m'
	[2026-04-21 10:00:00]='1440m'
	[2026-04-21 12:32:48]='1593m'
	[2026-05-12 20:05:00]='538.1h'
	[2026-06-01]='998h'
	[2027-01-01]='6135h'
	[1976-10-20]='-2583w'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --short-units --output smallest-unit '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in best unit" {
    typeset -A data=(
	[2026-04-20 10:00:00]='at a single point in time'
	[2026-04-20 09:59:59]='-1s'
	[2026-04-19 10:00:00]='-1d'
	[2026-04-21 10:00:00]='1d'
	[2026-04-21 12:32:48]='1.1d'
	[2026-05-12 20:05:00]='3.1w'
	[2026-06-01]='1.4mo'
	[2027-01-01]='8.5mo'
	[1976-10-20]='-2g'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --short-units --output best-unit '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output in largest unit" {
    typeset -A data=(
	[2026-04-20 10:00:00]='0s'
	[2026-04-20 09:59:59]='-1s'
	[2026-04-19 10:00:00]='-0.1w'
	[2026-04-21 10:00:00]='0.1w'
	[2026-04-21 12:32:48]='0.1w'
	[2026-05-12 20:05:00]='0.7mo'
	[2026-06-01]='0.1y'
	[2027-01-01]='0.7y'
	[1976-10-20]='-2g'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --short-units --output largest-unit '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with default output (all)" {
    typeset -A data=(
	[2026-04-20 10:00:00]='at a single point in time = 0s'
	[2026-04-20 09:59:59]='-1s'
	[2026-04-19 10:00:00]='-1440m = -24h = -1d = -0.1w'
	[2026-04-21 10:00:00]='1440m = 24h = 1d = 0.1w'
	[2026-04-21 12:32:48]='1593m = 26.5h = 1.1d = 0.1w = 1d 02:32:48'
	[2026-05-12 20:05:00]='538.1h = 22.4d = 3.1w = 0.7mo = 3w 1d 10h 5m'
	[2026-06-01]='998h = 41.6d = 6w = 1.4mo = 0.1y = 1mo 1w 4d 4h'
	[2027-01-01]='6135h = 255.6d = 36.6w = 8.5mo = 0.7y = 8mo 1w 5d 7h'
	[1976-10-20]='-2583w = -602.6mo = -49.5y = -2g = -1g 19y 6mo 4d 14h 24m'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --short-units --output all '2026-04-20 10:00' "$date" \
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
	DATEDIFF_OUTPUT_FORMAT=months run -0 datediff --short-units '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}

@test "diff with output as textform" {
    typeset -A data=(
	[2026-04-20 10:00:00]='[at a single point in time|0s|at a single point in time = 0s]'
	[2026-04-20 09:59:59]='[-1s]'
	[2026-04-19 10:00:00]='[-1440m|-24h|-1d|-0.1w|-1440m = -24h = -1d = -0.1w]'
	[2026-04-21 10:00:00]='[1440m|24h|1d|0.1w|1440m = 24h = 1d = 0.1w]'
	[2026-04-21 12:32:48]='[1593m|26.5h|1.1d|0.1w|1d 02:32:48|1593m = 26.5h = 1.1d = 0.1w]'
	[2026-05-12 20:05:00]='[538.1h|22.4d|3.1w|0.7mo|3w 1d 10h 5m|538.1h = 22.4d = 3.1w = 0.7mo]'
	[2026-06-01]='[998h|41.6d|6w|1.4mo|0.1y|1mo 1w 4d 4h|998h = 41.6d = 6w = 1.4mo = 0.1y]'
	[2027-01-01]='[6135h|255.6d|36.6w|8.5mo|0.7y|8mo 1w 5d 7h|6135h = 255.6d = 36.6w = 8.5mo = 0.7y]'
	[1976-10-20]='[-2583w|-602.6mo|-49.5y|-2g|-1g 19y 6mo 4d 14h 24m|-2583w = -602.6mo = -49.5y = -2g]'
    )

    for date in "${!data[@]}"
    do
	run -0 datediff --short-units --output textform '2026-04-20 10:00' "$date" \
	    && assert_output "${data["$date"]}" \
	    || fail "$date"
    done
}
