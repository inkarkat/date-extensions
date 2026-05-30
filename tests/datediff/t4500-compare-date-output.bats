#!/usr/bin/env bats

load fixture

@test "compare date against date does not do output on success" {
    while IFS=$'\t' read -r datetime cmpOp cmpDate
    do
	run -0 datediff --output best-unit $cmpOp "$cmpDate" "$datetime" \
	    && assert_output '' \
	    || fail "$cmpOp ${cmpDate@Q} ${datetime@Q}"
    done <<-EOF
$NOW_DATE	-eq	$NOW_DATE
$NOW_DATE	-le	$NOW_DATE
$NOW_DATE	-ge	$NOW_DATE
$NOW_DATE	-eq	@$NOW
$NOW_DATE	-le	@$NOW
$NOW_DATE	-ge	@$NOW
2026-04-20 10:00:01	-eq	2026-04-20 10:00:01
2026-04-20 10:00:01	-eq	20-Apr-2026 10:00:01
2026-04-20 11:30:00	-eq	2026-04-20 11:30
2026-04-20 11:30:00	-eq	@1776677400
2026-04-20 11:30:00	-gt	2026-04-20T11:29:59
2026-04-20 11:30:00	--newer	2026-04-20 11:00:00
2026-04-20 11:30:00	--newer	2026-04-20 10:30:00
2026-04-20 11:30:00	--older	2026-04-20 12:00:00
2026-06-01	-lt	2026-08-01
EOF
}

@test "compare date against date outputs best-unit difference on failure" {
    while IFS=$'\t' read -r datetime cmpOp cmpDate expectedOutput
    do
	run -1 datediff --output best-unit $cmpOp "$cmpDate" "$datetime" \
	    && assert_output "$expectedOutput" \
	    || fail "$cmpOp ${cmpDate@Q} ${datetime@Q}"
    done <<-EOF
$NOW_DATE	-ne	$NOW_DATE	just now
$NOW_DATE	-gt	$NOW_DATE	just now
$NOW_DATE	-lt	$NOW_DATE	just now
$NOW_DATE	-ne	@$NOW	just now
$NOW_DATE	-gt	@$NOW	just now
$NOW_DATE	-lt	@$NOW	just now
2026-04-20 09:59:59	-eq	$NOW_DATE	1 second ago
2026-04-20 09:59:59	-eq	2026-04-20 09:59:58	in 1 second
2026-04-20 09:59:59	-eq	2026-04-20 10:00:01	2 seconds ago
2026-04-20 10:00:01	-eq	2026-04-20 09:59:59	in 2 seconds
2026-04-20 10:00:01	-eq	$NOW_DATE	in 1 second
2026-04-20 11:30:00	--newer	2026-04-20 12:00:00	30 minutes ago
2026-04-20 11:30:00	--older	2026-04-20 11:00:00	in 30 minutes
2026-04-20 11:30:00	--older	2026-04-20 10:30:00	in 1 hour
2027-01-01	-lt	2026-11-01	in 2 months
EOF
}

@test "compare date against date with absolute output always" {
    while IFS=$'\t' read -r datetime cmpOp cmpDate expectedOutput
    do
	run datediff --output best-unit --absolute --always-output $cmpOp "$cmpDate" "$datetime" \
	    && assert_output "$expectedOutput" \
	    || fail "$cmpOp ${cmpDate@Q} ${datetime@Q}"
    done <<-EOF
$NOW_DATE	-eq	$NOW_DATE	0 seconds
$NOW_DATE	-ne	$NOW_DATE	0 seconds
$NOW_DATE	-gt	$NOW_DATE	0 seconds
$NOW_DATE	-lt	$NOW_DATE	0 seconds
$NOW_DATE	-le	$NOW_DATE	0 seconds
$NOW_DATE	-ge	$NOW_DATE	0 seconds
$NOW_DATE	-eq	@$NOW	0 seconds
$NOW_DATE	-ne	@$NOW	0 seconds
$NOW_DATE	-gt	@$NOW	0 seconds
$NOW_DATE	-lt	@$NOW	0 seconds
$NOW_DATE	-le	@$NOW	0 seconds
$NOW_DATE	-ge	@$NOW	0 seconds
2026-04-20 09:59:59	-eq	$NOW_DATE	1 second
2026-04-20 09:59:59	-eq	2026-04-20 09:59:58	1 second
2026-04-20 09:59:59	-eq	2026-04-20 10:00:01	2 seconds
2026-04-20 10:00:01	-eq	2026-04-20 09:59:59	2 seconds
2026-04-20 10:00:01	-eq	$NOW_DATE	1 second
2026-04-20 10:00:01	-eq	2026-04-20 10:00:01	0 seconds
2026-04-20 10:00:01	-eq	20-Apr-2026 10:00:01	0 seconds
2026-04-20 11:30:00	-eq	2026-04-20 11:30	0 seconds
2026-04-20 11:30:00	-eq	@1776677400	0 seconds
2026-04-20 11:30:00	-gt	2026-04-20T11:29:59	1 second
2026-06-01	-lt	2026-08-01	2 months
2027-01-01	-lt	2026-11-01	2 months
EOF
}
