#!/usr/bin/env bats

load fixture

@test "combining --seconds with -eq prints error" {
    run -2 datediff -eq 0 --seconds 1
    assert_line -n 0 'ERROR: Cannot combine -s|--seconds|-d|--days with --newer|--older|-lt|-le|-eq|-ne|-ge|-gt|--within|-w|--outside|-W.'
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

@test "both --seconds and --newer prints error" {
    run -2 datediff --seconds 1 --newer 1 2026-04-20
    assert_line -n 0 'ERROR: Cannot combine -s|--seconds|-d|--days with --newer|--older|-lt|-le|-eq|-ne|-ge|-gt|--within|-w|--outside|-W.'
    assert_line -n 1 -e '^Usage:'
}

@test "invalid AGE prints error" {
    run -2 datediff --newer 12x 2026-04-20
    assert_line -n 0 'ERROR: Invalid AGE: "12x".'
    assert_line -n 1 -e '^Usage:'
}

@test "invalid TIMESLOT prints error" {
    run -2 datediff --within eon 2026-04-20
    assert_line -n 0 'ERROR: Invalid TIMESLOT: "eon".'
    assert_line -n 1 -e '^Usage:'
}
