#!/usr/bin/env bats

load fixture

@test "combining --seconds with -eq prints error" {
    run -2 datediff -eq 0 --seconds 1
    assert_line -n 0 'ERROR: Cannot combine -s|--seconds|-d|--days with --newer|--older|-lt|-le|-eq|-ne|-ge|-gt|-w|--within|-W|--outside.'
    assert_line -n 1 -e '^Usage:'
}

@test "DATE after --seconds prints error" {
    run -2 datediff --seconds 1 2026-04-20
    assert_line -n 0 -e '^Usage:'
}

@test "DATE after --days prints error" {
    run -2 datediff --days 1 2026-04-20
    assert_line -n 0 -e '^Usage:'
}

@test "invalid DATE prints date error and exits with 4" {
    LC_ALL=C run -4 datediff notADate
    assert_output "date: invalid date 'notADate'"
}

@test "invalid second DATE prints date error and exits with 4" {
    LC_ALL=C run -4 datediff 2026-04-20 notADate
    assert_output "date: invalid date 'notADate'"
}

@test "invalid output format prints error" {
    run -2 datediff --output notAnOutputFormat 2026-04-20
    assert_output 'ERROR: Invalid output format: notAnOutputFormat'
}

@test "both --seconds and --days prints error" {
    run -2 datediff --seconds 1 --days 1 2026-04-20
    assert_line -n 0 'ERROR: Cannot combine -s|--seconds with -d|--days.'
    assert_line -n 1 -e '^Usage:'
}

@test "both --file and --seconds prints error" {
    run -2 datediff --seconds 1 --file - 2026-04-20
    assert_line -n 0 'ERROR: Cannot combine -s|--seconds|-d|--days with -f|--file.'
    assert_line -n 1 -e '^Usage:'
}

@test "both --seconds and --newer prints error" {
    run -2 datediff --seconds 1 --newer 1 2026-04-20
    assert_line -n 0 'ERROR: Cannot combine -s|--seconds|-d|--days with --newer|--older|-lt|-le|-eq|-ne|-ge|-gt|-w|--within|-W|--outside.'
    assert_line -n 1 -e '^Usage:'
}

@test "invalid -lt parameter prints error" {
    for value in '12xy' 'generational'
    do
	run -2 datediff -lt "$value" 2026-04-20 \
	    && assert_line -n 0 "ERROR: Illegal TIMESPAN: $value" \
	    && assert_line -n 1 -e '^Usage:' \
	    || fail "$value"
    done
}

@test "invalid --newer parameter prints error" {
    for value in '12xy' 'generational'
    do
	run -2 datediff --newer "$value" 2026-04-20 \
	    && assert_line -n 0 "ERROR: Illegal TIMESPAN or TIMESLOT: $value" \
	    && assert_line -n 1 -e '^Usage:' \
	    || fail "$value"
    done
}

@test "invalid TIMESLOT prints error" {
    run -2 datediff --within eon 2026-04-20
    assert_line -n 0 'ERROR: Invalid TIMESLOT: "eon".'
    assert_line -n 1 -e '^Usage:'
}

@test "combining --absolute with --newer and --older prints error" {
    for cmpOp in --newer --older
    do
	run -2 datediff --absolute $cmpOp 1s 2026-04-20 \
	    && assert_line -n 0 'ERROR: Cannot combine -a|--absolute with --newer|--older; use -lt|-le|-eq|-ne|-ge|-gt / -w|--within|-W|--outside instead.' \
	    && assert_line -n 1 -e '^Usage:' \
	    || fail "$cmpOp -1s"
    done
}

@test "both --always-output and --success-output prints error" {
    run -2 datediff --always-output --success-output 2026-04-20
    assert_line -n 0 'ERROR: Cannot combine -A|--always-output with -S|--success-output.'
    assert_line -n 1 -e '^Usage:'
}

@test "filter without comparison parameter prints error and exits with 2" {
    run -2 datediff --filter '10:00'
    assert_line -n 0 'ERROR: Comparison option required: --newer|--older [-]TIMESPAN|TIMESLOT | -lt|-le|-eq|-ne|-ge|-gt [-]TIMESPAN | -w|--within|-W|--outside TIMESLOT [-a|--absolute]'
    assert_line -n 1 -e '^Usage:'
}

@test "test something" {
    run -2 datediff -lt 2026-05-30 '10:00' 2026-04-20
    assert_line -n 0 'ERROR: Only one DATE|TIME can be compared against another DATE|TIME. Date differences can only be compared against TIMESPAN or TIMESLOT.'
    assert_line -n 1 -e '^Usage:'
}
