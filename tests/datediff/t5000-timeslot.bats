#!/usr/bin/env bats

load fixture

@test "timeslot can be specified in different ways" {
    for timeslot in \
s second \
m minute \
h hour \
d day \
w week \
mo month \
y year
    do
	run -0 datediff --within "$timeslot" "$NOW_DATE" \
	    && assert_output '' \
	    || fail "$timeslot"
    done
}

@test "compare timeslot of now and date" {
    while IFS=$'\t' read -r datetime timeslot expectedStatus
    do
	run datediff --within "$timeslot" "$datetime" \
	    && assert_equal $status $expectedStatus \
	    && assert_output '' \
	    || fail "--within $timeslot ${datetime@Q} ${NOW_DATE@Q}"

	run datediff --outside "$timeslot" "$datetime" \
	    && assert_equal $status $((expectedStatus ? 0 : 1)) \
	    && assert_output '' \
	    || fail "--outside $timeslot ${datetime@Q} ${NOW_DATE@Q}"
    done <<-EOF
$NOW_DATE	second	0
$NOW_DATE	day	0
2026-04-20 09:59:59	second	1
2026-04-20 09:59:59	minute	1
2026-04-20 10:00:01	second	1
2026-04-20 10:00:01	minute	0
2026-04-20 10:00:59	minute	0
2026-04-20 10:01:00	minute	1
2026-04-20 10:59:59	hour	0
2026-04-20 11:00:00	hour	1
2026-04-19 23:59:59	day	1
2026-04-20 00:00:00	day	0
2026-04-20 23:59:59	day	0
2026-04-21 00:00:00	day	1
2026-03-31	month	1
2026-04-01	month	0
2026-04-30	month	0
2026-05-01	month	1
2025-12-31	year	1
2026-01-01	year	0
2026-12-31	year	0
2027-01-01	year	1
EOF
}

@test "compare timeslot of dates" {
    while IFS=$'\t' read -r datetime1 datetime2 timeslot expectedStatus
    do
	run datediff --within "$timeslot" "$datetime1" "$datetime2" \
	    && assert_equal $status $expectedStatus \
	    && assert_output '' \
	    || fail "--within $timeslot ${datetime1@Q} ${datetime2@Q}"

	run datediff --outside "$timeslot" "$datetime1" "$datetime2" \
	    && assert_equal $status $((expectedStatus ? 0 : 1)) \
	    && assert_output '' \
	    || fail "--outside $timeslot ${datetime1@Q} ${datetime2@Q}"
    done <<-EOF
2026-04-21 12:32:48	2026-04-21 12:32:48	second	0
2026-04-21 12:32:48	2026-04-21 12:32:47	second	1
2026-04-21 12:32:48	2026-04-21 12:32:49	second	1
2026-04-21 12:32:48	2026-04-21 12:32:49	minute	0
2026-04-21 12:32:48	2026-04-21 12:31:59	minute	1
2026-04-21 12:32:48	2026-04-21 12:32:00	minute	0
2026-04-21 12:32:48	2026-04-21 12:32:59	minute	0
2026-04-21 12:32:48	2026-04-21 12:33:00	minute	1
2026-04-21 12:32:48	2026-04-19 10:00:00	week	1
2026-04-21 12:32:48	2026-04-20 10:00:00	week	0
2026-04-21 12:32:48	2026-04-26 10:00:00	week	0
2026-04-21 12:32:48	2026-04-27 10:00:00	week	1
EOF
}
