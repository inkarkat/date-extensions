#!/usr/bin/env bats

load fixture

@test "compare timeslot of now and date outputs seconds difference on failure" {
    while IFS=$'\t' read -r datetime cmpOp timeslot expectedOutput
    do
	run -1 datediff --output seconds $cmpOp "$timeslot" "$datetime" \
	    && assert_output "$expectedOutput" \
	    || fail "$datetime, $NOW_DATE $cmpOp $timeslot"
    done <<-EOF
$NOW_DATE	--outside	second	0
$NOW_DATE	--outside	day	0
2026-04-20 09:59:59	--within	second	-1
2026-04-20 09:59:59	--within	minute	-1
2026-04-20 10:00:01	--within	second	1
2026-04-20 10:00:01	--outside	minute	1
2026-04-20 10:00:59	--outside	minute	59
2026-04-20 10:01:00	--within	minute	60
2026-04-20 10:59:59	--outside	hour	3599
2026-04-20 11:00:00	--within	hour	3600
2026-04-19 23:59:59	--within	day	-36001
2026-04-20 00:00:00	--outside	day	-36000
2026-04-20 23:59:59	--outside	day	50399
2026-04-21 00:00:00	--within	day	50400
2026-03-31	--within	month	-1764000
2026-04-01	--outside	month	-1677600
2026-04-30	--outside	month	828000
2026-05-01	--within	month	914400
2025-12-31	--within	year	-9536400
2026-01-01	--outside	year	-9450000
2026-12-31	--outside	year	21999600
2027-01-01	--within	year	22086000
EOF
}
