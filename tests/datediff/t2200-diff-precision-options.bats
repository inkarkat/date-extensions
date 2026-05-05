#!/usr/bin/env bats

load fixture

readonly DATE='2026-05-12 20:05:00'

@test "precision output understands --prefer-clock" {
    run -0 datediff --output precise "$DATE"
    assert_output 'in 3w 1d 10h 5m'

    run -0 datediff --output precise --prefer-clock "$DATE"
    assert_output 'in 3w 1d 10:05:00'
}

@test "precision output understands --long-units" {
    run -0 datediff --output precise "$DATE"
    assert_output 'in 3w 1d 10h 5m'

    run -0 datediff --output precise --long-units "$DATE"
    assert_output 'in 3 weeks 1 day 10 hours 5 minutes'
}

@test "precision output understands --precision" {
    typeset -A precision=(
	[4]='in 3w 1d 10h 5m'
	[3]='in 3w 1d 10h'
	[2]='in 3w 1d'
	[1]='in 3w'
	[w]='in 3w'
	[.1w]='in 3.2w'
	[d]='in 22d'
	[s]='in 1937100s'
    )

    for value in "${!precision[@]}"
    do
	run -0 datediff --output precise --precision "$value" "$DATE" \
	    && assert_output "${precision["$value"]}" \
	    || fail "$value"
    done
}

@test "precision output understands --precision-width" {
    typeset -A precisionWidth=(
	[12]='in 3w 1d 10h 5m'
	[10]='in 3w 1d 10h'
	[8]='in 3w 1d'
	[4]='in 3w'
    )

    for value in "${!precisionWidth[@]}"
    do
	run -0 datediff --output precise --precision-width "$value" "$DATE" \
	    && assert_output "${precisionWidth["$value"]}" \
	    || fail "$value"
    done
}

@test "precision output understands --width" {
    typeset -A width=(
	[2]='in 3w 1d 10h 5m'
	[12]='in 3w 1d 10h 5m'
	[20]='in         3w 1d 10h 5m'
    )

    for value in "${!width[@]}"
    do
	run -0 datediff --output precise --width "$value" "$DATE" \
	    && assert_output "${width["$value"]}" \
	    || fail "$value"
    done
}
