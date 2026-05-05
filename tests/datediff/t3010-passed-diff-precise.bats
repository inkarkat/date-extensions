#!/usr/bin/env bats

load fixture

@test "passed seconds diff with precise output" {
    typeset -A data=(
	[0]='0s'
	[1]='in 1s'
	[2]='in 2s'
	[60]='in 1m'
	[3600]='in 1h'
	[50340]='in 13h 59m'
	[-36000]='10h ago'
	[-3600]='1h ago'
	[-86400]='1d ago'
	[86400]='in 1d'
	[50400]='in 14h'
	[95580]='in 1d 2h 33m'
    )

    for seconds in "${!data[@]}"
    do
	run -0 datediff --output precise --seconds "$seconds" \
	    && assert_output "${data["$seconds"]}" \
	    || fail "$seconds"
    done
}

@test "passed days diff with precise output" {
    typeset -A data=(
	[0]='0d'
	[1]='in 1d'
	[-1]='1d ago'
	[2]='in 2d'
	[-2]='2d ago'
	[11]='in 1w 4d'
	[22]='in 3w 1d'
	[42]='in 1mo 1w 4d 14h'
	[103]='in 3mo 1w 4d 18h'
	[256]='in 8mo 1w 5d 16h'
	[-18081]='1g 19y 6mo 6d 5h 24m ago'
    )

    for days in "${!data[@]}"
    do
	run -0 datediff --output precise --days "$days" \
	    && assert_output "${data["$days"]}" \
	    || fail "$days"
    done
}
