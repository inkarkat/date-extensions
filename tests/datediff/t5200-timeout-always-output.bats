#!/usr/bin/env bats

load fixture

@test "compare timeslot of now and date outputs seconds difference with --always-output" {
    while IFS=$'\t' read -r datetime timeslot expectedStatus expectedOutput
    do
	run datediff --always-output --output seconds --within "$timeslot" "$datetime" \
	    && assert_equal $status $expectedStatus \
	    && assert_output "$expectedOutput" \
	    || fail "--within $timeslot ${datetime@Q} ${NOW_DATE@Q}"
    done <<-EOF
$NOW_DATE	second	0	0
$NOW_DATE	day	0	0
2026-04-20 09:59:59	second	1	-1
2026-04-20 09:59:59	minute	1	-1
2026-04-20 10:00:01	second	1	1
2026-04-20 10:00:01	minute	0	1
2026-04-20 10:00:59	minute	0	59
2026-04-20 10:01:00	minute	1	60
2026-04-20 10:59:59	hour	0	3599
2026-04-20 11:00:00	hour	1	3600
2026-04-19 23:59:59	day	1	-36001
2026-04-20 00:00:00	day	0	-36000
2026-04-20 23:59:59	day	0	50399
2026-04-21 00:00:00	day	1	50400
2026-03-31	month	1	-1764000
2026-04-01	month	0	-1677600
2026-04-30	month	0	828000
2026-05-01	month	1	914400
2025-12-31	year	1	-9536400
2026-01-01	year	0	-9450000
2026-12-31	year	0	21999600
2027-01-01	year	1	22086000
EOF
}
