#!/usr/bin/env bats

load fixture

@test "compare date against date" {
    while IFS=$'\t' read -r datetime cmpOp cmpDate expectedStatus
    do
	run datediff $cmpOp "$cmpDate" "$datetime" \
	    && assert_equal $status $expectedStatus \
	    && assert_output '' \
	    || fail "$cmpOp ${cmpDate@Q} ${datetime@Q}"
    done <<-EOF
$NOW_DATE	-eq	$NOW_DATE	0
$NOW_DATE	-ne	$NOW_DATE	1
$NOW_DATE	-gt	$NOW_DATE	1
$NOW_DATE	-lt	$NOW_DATE	1
$NOW_DATE	-le	$NOW_DATE	0
$NOW_DATE	-ge	$NOW_DATE	0
$NOW_DATE	-eq	@$NOW	0
$NOW_DATE	-ne	@$NOW	1
$NOW_DATE	-gt	@$NOW	1
$NOW_DATE	-lt	@$NOW	1
$NOW_DATE	-le	@$NOW	0
$NOW_DATE	-ge	@$NOW	0
2026-04-20 09:59:59	-eq	$NOW_DATE	1
2026-04-20 09:59:59	-eq	2026-04-20 09:59:58	1
2026-04-20 09:59:59	-eq	2026-04-20 10:00:01	1
2026-04-20 10:00:01	-eq	2026-04-20 09:59:59	1
2026-04-20 10:00:01	-eq	$NOW_DATE	1
2026-04-20 10:00:01	-eq	2026-04-20 10:00:01	0
2026-04-20 10:00:01	-eq	20-Apr-2026 10:00:01	0
2026-04-20 11:30:00	-eq	2026-04-20 11:30	0
2026-04-20 11:30:00	-eq	@1776677400	0
2026-04-20 11:30:00	-gt	2026-04-20T11:29:59	0
2026-04-20 11:30:00	--newer	2026-04-20 11:00:00	0
2026-04-20 11:30:00	--newer	2026-04-20 12:00:00	1
2026-04-20 11:30:00	--newer	2026-04-20 10:30:00	0
2026-04-20 11:30:00	--older	2026-04-20 11:00:00	1
2026-04-20 11:30:00	--older	2026-04-20 12:00:00	0
2026-04-20 11:30:00	--older	2026-04-20 10:30:00	1
2026-06-01	-lt	2026-08-01	0
2027-01-01	-lt	2026-11-01	1
EOF
}

@test "compare time against time" {
    while IFS=$'\t' read -r datetime cmpOp cmpDate expectedStatus
    do
	run datediff $cmpOp "$cmpDate" "$datetime" \
	    && assert_equal $status $expectedStatus \
	    && assert_output '' \
	    || fail "$cmpOp ${cmpDate@Q} ${datetime@Q}"
    done <<-EOF
today 09:59:59	-eq	today 09:59:58	1
today 09:59:59	-eq	today 10:00:01	1
today 10:00:01	-eq	today 09:59:59	1
today 10:00:01	-eq	today 10:00:01	0
today 11:30:00	-eq	today 11:30	0
today 11:30:00	--newer	today 11:00:00	0
today 11:30:00	--newer	today 12:00:00	1
today 11:30:00	--newer	today 10:30:00	0
today 11:30:00	--older	today 11:00:00	1
today 11:30:00	--older	today 12:00:00	0
today 11:30:00	--older	today 10:30:00	1
EOF
}
