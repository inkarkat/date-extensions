#!/usr/bin/env bats

load fixture

@test "single time and addendum filtered from stdin against passed time" {
    run -0 datediff --filter --newer 3s '10:00' <<< $'10:00:02\taddendum'
    assert_output 'addendum'

    run -1 datediff --filter --older 3s '10:00' <<< $'10:00:02\taddendum'
    assert_output ''
}

@test "dates and addenda filtered from stdin against passed date" {
    run -1 datediff --filter --newer 1d '2026-04-20 10:00' < "${BATS_TEST_DIRNAME}/dates-addenda.tsv"
    assert_output - <<'EOF'
the time is now
just before the time
the day after
  midnight
a random time
next month


from here, without times
next next month, without time

next year
EOF
}

@test "dates and addenda filtered from file against passed date" {
    run -1 datediff --filter --absolute -ge 1d --file "${BATS_TEST_DIRNAME}/dates-addenda.tsv" '2026-04-20 10:00'
    assert_output - <<'EOF'
the day before
the day after
a random time
next month


from here, without times
next next month, without time

next year

a long long time ago
EOF
}
