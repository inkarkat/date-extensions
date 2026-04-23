#!/usr/bin/env bats

load fixture

@test "compare diff between now and date against age" {
    while IFS=$'\t' read -r datetime cmpOp age expectedStatus
    do
	run datediff $cmpOp "$age" "$datetime" \
	    && assert_equal $status $expectedStatus \
	    && assert_output '' \
	    || fail "$datetime - $NOW_DATE $cmpOp $age"
    done <<-EOF
$NOW_DATE	-eq	0	0
$NOW_DATE	-ne	0	1
$NOW_DATE	-gt	0	1
$NOW_DATE	-lt	0	1
$NOW_DATE	-le	0	0
$NOW_DATE	-ge	0	0
2026-04-20 09:59:59	-eq	0s	1
2026-04-20 09:59:59	-eq	-1s	0
2026-04-20 09:59:59	-eq	1s	1
2026-04-20 10:00:01	-eq	-1s	1
2026-04-20 10:00:01	-eq	0s	1
2026-04-20 10:00:01	-eq	1s	0
2026-04-20 11:30:00	-eq	5400	0
2026-04-20 11:30:00	-gt	1h	0
2026-04-20 11:30:00	--newer	1h	1
2026-04-20 11:30:00	--newer	2h	0
2026-04-20 11:30:00	--older	2h	1
2026-04-20 11:30:00	--older	1h	0
2026-04-21 10:00:00	-eq	86400	0
2026-04-21 10:00:00	-eq	24h	0
2026-04-21 10:00:00	-eq	1d	0
2026-04-21 10:00:00	-gt	23h	0
2026-04-21 10:00:00	-gt	24h	1
2026-04-21 12:32:48	-gt	1d	0
2026-05-12 20:05:00	-gt	3w	0
2026-05-12 20:05:00	-gt	4w	1
2026-05-12 20:05:00	-gt	1mo	1
2026-06-01	-lt	2mo	0
2027-01-01	-lt	2mo	1
1976-10-20	-eq	2g	1
1976-10-20	-ge	2g	1
EOF
}

@test "compare diff between two dates against age" {
    while IFS=$'\t' read -r datetime1 datetime2 cmpOp age expectedStatus
    do
	run datediff $cmpOp "$age" "$datetime1" "$datetime2" \
	    && assert_equal $status $expectedStatus \
	    && assert_output '' \
	    || fail "$datetime1 - $datetime2 $cmpOp $age"
    done <<-EOF
$NOW_DATE	$NOW_DATE	-eq	0	0
$NOW_DATE	$NOW_DATE	-ne	0	1
$NOW_DATE	$NOW_DATE	-gt	0	1
$NOW_DATE	$NOW_DATE	-lt	0	1
$NOW_DATE	$NOW_DATE	-le	0	0
$NOW_DATE	$NOW_DATE	-ge	0	0
$NOW_DATE	2026-04-20 09:59:59	-eq	0s	1
$NOW_DATE	2026-04-20 09:59:59	-eq	-1s	0
$NOW_DATE	2026-04-20 09:59:59	-eq	1s	1
$NOW_DATE	2026-04-20 10:00:01	-eq	-1s	1
$NOW_DATE	2026-04-20 10:00:01	-eq	0s	1
$NOW_DATE	2026-04-20 10:00:01	-eq	1s	0
$NOW_DATE	2026-04-20 11:30:00	-eq	5400	0
$NOW_DATE	2026-04-20 11:30:00	-gt	1h	0
$NOW_DATE	2026-04-20 11:30:00	--newer	1h	1
$NOW_DATE	2026-04-20 11:30:00	--newer	2h	0
$NOW_DATE	2026-04-20 11:30:00	--older	2h	1
$NOW_DATE	2026-04-20 11:30:00	--older	1h	0
$NOW_DATE	2026-04-21 10:00:00	-eq	86400	0
$NOW_DATE	2026-04-21 10:00:00	-eq	24h	0
$NOW_DATE	2026-04-21 10:00:00	-eq	1d	0
$NOW_DATE	2026-04-21 10:00:00	-gt	23h	0
$NOW_DATE	2026-04-21 10:00:00	-gt	24h	1
$NOW_DATE	2026-04-21 12:32:48	-gt	1d	0
$NOW_DATE	2026-05-12 20:05:00	-gt	3w	0
$NOW_DATE	2026-05-12 20:05:00	-gt	4w	1
$NOW_DATE	2026-05-12 20:05:00	-gt	1mo	1
$NOW_DATE	2026-06-01	-lt	2mo	0
$NOW_DATE	2027-01-01	-lt	2mo	1
$NOW_DATE	1976-10-20	-eq	2g	1
$NOW_DATE	1976-10-20	-ge	2g	1
EOF
}

@test "compare absolute diff between two dates against age" {
    while IFS=$'\t' read -r datetime1 datetime2 cmpOp age expectedStatus
    do
	run datediff --absolute $cmpOp "$age" "$datetime1" "$datetime2" \
	    && assert_equal $status $expectedStatus \
	    && assert_output '' \
	    || fail "$datetime1 - $datetime2 $cmpOp $age"
    done <<-EOF
$NOW_DATE	2026-04-20 09:59:59	-eq	0s	1
$NOW_DATE	2026-04-20 09:59:59	-eq	-1s	1
$NOW_DATE	2026-04-20 09:59:59	-eq	1s	0
$NOW_DATE	2026-04-20 10:00:01	-eq	-1s	1
$NOW_DATE	2026-04-20 10:00:01	-eq	0s	1
$NOW_DATE	2026-04-20 10:00:01	-eq	1s	0
$NOW_DATE	2026-04-20 11:30:00	-eq	5400	0
$NOW_DATE	2026-04-20 11:30:00	-gt	1h	0
2026-04-20 11:30:00	$NOW_DATE	-gt	1h	0
$NOW_DATE	2026-04-20 11:30:00	--newer	1h	1
2026-04-20 11:30:00	$NOW_DATE	--newer	1h	1
$NOW_DATE	2026-04-20 11:30:00	--newer	2h	0
2026-04-20 11:30:00	$NOW_DATE	--newer	2h	0
$NOW_DATE	2026-04-20 11:30:00	--older	2h	1
2026-04-20 11:30:00	$NOW_DATE	--older	2h	1
$NOW_DATE	2026-04-20 11:30:00	--older	1h	0
2026-04-20 11:30:00	$NOW_DATE	--older	1h	0
$NOW_DATE	2026-04-21 10:00:00	-eq	86400	0
2026-04-21 10:00:00	$NOW_DATE	-eq	86400	0
$NOW_DATE	2026-04-21 10:00:00	-eq	24h	0
2026-04-21 10:00:00	$NOW_DATE	-eq	24h	0
$NOW_DATE	2026-04-21 10:00:00	-eq	1d	0
2026-04-21 10:00:00	$NOW_DATE	-eq	1d	0
$NOW_DATE	2026-04-21 10:00:00	-gt	23h	0
2026-04-21 10:00:00	$NOW_DATE	-gt	23h	0
$NOW_DATE	2026-04-21 10:00:00	-gt	24h	1
2026-04-21 10:00:00	$NOW_DATE	-gt	24h	1
$NOW_DATE	2026-04-21 12:32:48	-gt	1d	0
2026-04-21 12:32:48	$NOW_DATE	-gt	1d	0
$NOW_DATE	2026-05-12 20:05:00	-gt	3w	0
2026-05-12 20:05:00	$NOW_DATE	-gt	3w	0
$NOW_DATE	2026-05-12 20:05:00	-gt	4w	1
2026-05-12 20:05:00	$NOW_DATE	-gt	4w	1
$NOW_DATE	2026-05-12 20:05:00	-gt	1mo	1
2026-05-12 20:05:00	$NOW_DATE	-gt	1mo	1
$NOW_DATE	2026-06-01	-lt	2mo	0
2026-06-01	$NOW_DATE	-lt	2mo	0
$NOW_DATE	2027-01-01	-lt	2mo	1
2027-01-01	$NOW_DATE	-lt	2mo	1
$NOW_DATE	1976-10-20	-eq	2g	1
1976-10-20	$NOW_DATE	-eq	2g	1
$NOW_DATE	1976-10-20	-ge	2g	1
1976-10-20	$NOW_DATE	-ge	2g	1
EOF
}
