#!/usr/bin/env bats

load fixture

@test "single date and time and addendum read from stdin against now with custom field separators" {
    for fs in  $'\t' X '--' ' >> '   ' / ' \\ ' against '
    do
	run -0 datediff --file - --field-separator "$fs" <<< "2026-04-20 10:00:02${fs}addendum" \
	    && assert_output "in 2 seconds${fs}addendum" \
	    || fail "${fs@Q}"
    done
}

@test "single time and addendum read from stdin against now with custom field separators" {
    for fs in  '-' ' ' '::'
    do
	run -0 datediff --file - --field-separator "$fs" '10:00' <<< "10:00:02${fs}addendum" \
	    && assert_output "2 seconds${fs}addendum" \
	    || fail "${fs@Q}"
    done
}
