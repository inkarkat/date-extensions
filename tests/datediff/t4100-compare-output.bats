#!/usr/bin/env bats

load fixture

@test "compare diff between now and date against age does not do output on success" {
    while IFS=$'\t' read -r datetime cmpOp age expectedStatus
    do
	run -0 datediff --output best-unit $cmpOp "$age" "$datetime" \
	    && assert_output '' \
	    || fail "$cmpOp $age ${datetime@Q} ${NOW_DATE@Q}"
    done <<-EOF
$NOW_DATE	-eq	0
$NOW_DATE	-le	0
$NOW_DATE	-ge	0
2026-04-20 09:59:59	-eq	-1s
2026-04-20 10:00:01	-eq	1s
2026-04-20 11:30:00	-eq	5400
2026-04-20 11:30:00	-gt	1h
2026-04-20 11:30:00	--newer	2h
2026-04-20 11:30:00	--newer	1h
2026-04-21 10:00:00	-eq	86400
2026-04-21 10:00:00	-eq	24h
2026-04-21 10:00:00	-eq	1d
2026-04-21 10:00:00	-gt	23h
2026-04-21 12:32:48	-gt	1d
2026-05-12 20:05:00	-gt	3w
2026-06-01	-lt	2mo
EOF
}

@test "compare diff between now and date against age outputs best-unit difference on failure" {
    while IFS=$'\t' read -r datetime cmpOp age expectedOutput
    do
	run -1 datediff --output best-unit $cmpOp "$age" "$datetime" \
	    && assert_output "$expectedOutput" \
	    || fail "$cmpOp $age ${datetime@Q} ${NOW_DATE@Q}"
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

@test "compare diff between two dates against age outputs whole-units difference on failure" {
    while IFS=$'\t' read -r datetime1 datetime2 cmpOp age expectedOutput
    do
	run -1 datediff --output whole-units $cmpOp "$age" "$datetime1" "$datetime2" \
	    && assert_output "$expectedOutput" \
	    || fail "$cmpOp $age ${datetime1@Q} ${datetime2@Q}"
    done <<-EOF
$NOW_DATE	$NOW_DATE	-ne	0	just now
$NOW_DATE	$NOW_DATE	-gt	0	just now
$NOW_DATE	$NOW_DATE	-lt	0	just now
$NOW_DATE	2026-04-20 09:59:59	-eq	0s	1 second ago
$NOW_DATE	2026-04-20 09:59:59	-eq	1s	1 second ago
$NOW_DATE	2026-04-20 10:00:01	-eq	-1s	in 1 second
$NOW_DATE	2026-04-20 10:00:01	-eq	0s	in 1 second
$NOW_DATE	2026-04-20 11:30:00	--older	1h	in 5400 seconds = 90 minutes = 1.5 hours
$NOW_DATE	2026-04-20 11:30:00	--older	2h	in 5400 seconds = 90 minutes = 1.5 hours
$NOW_DATE	2026-04-21 10:00:00	-gt	24h	in 1440 minutes = 24 hours = 1 day
$NOW_DATE	2026-05-12 20:05:00	-gt	4w	in 538.1 hours = 22.4 days = 3.1 weeks
$NOW_DATE	2026-05-12 20:05:00	-gt	1mo	in 538.1 hours = 22.4 days = 3.1 weeks
$NOW_DATE	2027-01-01	-lt	2mo	in 6135 hours = 255.6 days = 36.6 weeks = 8.5 months
$NOW_DATE	1976-10-20	-eq	2g	2583 weeks = 602.6 months = 49.5 years = 2 generations ago
$NOW_DATE	1976-10-20	-ge	2g	2583 weeks = 602.6 months = 49.5 years = 2 generations ago
EOF
}
