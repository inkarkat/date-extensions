#!/usr/bin/env bats

load fixture

@test "compare diff between now and date against timespan output on success with --always-output" {
    while IFS=$'\t' read -r datetime cmpOp timespan expectedOutput
    do
	run -0 datediff --always-output --output best-unit $cmpOp "$timespan" "$datetime" \
	    && assert_output "$expectedOutput" \
	    || fail "$cmpOp $timespan ${datetime@Q} ${NOW_DATE@Q}"
    done <<-EOF
$NOW_DATE	-eq	0	just now
$NOW_DATE	-le	0	just now
$NOW_DATE	-ge	0	just now
2026-04-20 09:59:59	-eq	-1s	1 second ago
2026-04-20 10:00:01	-eq	1s	in 1 second
2026-04-20 11:30:00	-eq	5400	in 1.5 hours
2026-04-20 11:30:00	-gt	1h	in 1.5 hours
2026-04-20 11:30:00	--newer	2h	in 1.5 hours
2026-04-20 11:30:00	--newer	1h	in 1.5 hours
2026-04-21 10:00:00	-eq	86400	in 1 day
2026-04-21 10:00:00	-eq	24h	in 1 day
2026-04-21 10:00:00	-eq	1d	in 1 day
2026-04-21 10:00:00	-gt	23h	in 1 day
2026-04-21 12:32:48	-gt	1d	in 1.1 days
2026-05-12 20:05:00	-gt	3w	in 3.1 weeks
2026-06-01	-lt	2mo	in 1.4 months
EOF
}

@test "compare diff between now and date against timespan outputs best-unit difference on failure with --always-output" {
    while IFS=$'\t' read -r datetime cmpOp timespan expectedOutput
    do
	run -1 datediff --always-output --output best-unit $cmpOp "$timespan" "$datetime" \
	    && assert_output "$expectedOutput" \
	    || fail "$cmpOp $timespan ${datetime@Q} ${NOW_DATE@Q}"
    done <<-EOF
$NOW_DATE	-ne	0	just now
$NOW_DATE	-gt	0	just now
$NOW_DATE	-lt	0	just now
2026-04-20 09:59:59	-eq	0s	1 second ago
2026-04-20 09:59:59	-eq	1s	1 second ago
2026-04-20 10:00:01	-eq	-1s	in 1 second
2026-04-20 10:00:01	-eq	0s	in 1 second
2026-04-20 11:30:00	--older	1h	in 1.5 hours
2026-04-20 11:30:00	--older	2h	in 1.5 hours
2026-04-21 10:00:00	-gt	24h	in 1 day
2026-05-12 20:05:00	-gt	4w	in 3.1 weeks
2026-05-12 20:05:00	-gt	1mo	in 3.1 weeks
2027-01-01	-lt	2mo	in 8.5 months
1976-10-20	-eq	2g	2 generations ago
1976-10-20	-ge	2g	2 generations ago
EOF
}
