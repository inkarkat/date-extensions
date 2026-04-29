#!/usr/bin/env bats

load fixture

@test "compare diff between now and dates from file only succeeds when all comparisons succeed" {
    run -0 datediff --file - -lt 1h <<-EOF
2026-04-20 09:59:59
2026-04-20 10:59:59
2026-04-20 10:10:10
EOF

    run -1 datediff --file - -lt 1h <<-EOF
2026-04-20 09:59:59
2026-04-20 10:59:59
2026-04-20 11:00:00
EOF

    run -0 datediff --file - -lt 1w <<-EOF
2026-04-20 09:59:59
2026-04-23 10:00:00
2026-04-26
2026-04-27 09:59:59
2026-04-18
EOF

    run -1 datediff --file - -lt 1w <<-EOF
2026-04-20 09:59:59
2026-04-23 10:00:00
2026-04-26
2026-04-27 10:00:00
2026-04-18
EOF
}

@test "compare timeslot of passed date and dates from file only succeeds when all comparisons succeed" {
    run -0 datediff --file - --within hour '2026-04-20 10:00:00' <<-EOF
2026-04-20 10:00:00
2026-04-20 10:10:10
2026-04-20 10:59:59
EOF

    run -1 datediff --file - --within hour '2026-04-20 10:00:00' <<-EOF
2026-04-20 10:00:00
2026-04-20 10:10:10
2026-04-20 09:59:59
EOF

    run -0 datediff --file - --within year '2026-04-20 10:00:00' <<-EOF
2026-01-01
2026-04-20 10:00:00
2026-10-10 10:00:00
EOF

    run -1 datediff --file - --within year '2026-04-20 10:00:00' <<-EOF
2026-01-01
2025-12-31
2026-04-20 10:00:00
EOF
}
