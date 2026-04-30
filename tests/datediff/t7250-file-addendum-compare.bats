#!/usr/bin/env bats

load fixture

@test "compare diff between now and dates and addenda from file only succeeds when all comparisons succeed" {
    run -0 datediff --file - -lt 1h <<'EOF'
2026-04-20 09:59:59	just before the time
2026-04-20 10:59:59	just shy of the next hour
2026-04-20 10:10:10	10 later
EOF

    run -1 datediff --file - -lt 1h <<'EOF'
2026-04-20 09:59:59	just before the time
2026-04-20 10:59:59	just shy of the next hour
2026-04-20 11:00:00	the next hour
EOF

    run -0 datediff --file - -lt 1w <<'EOF'
2026-04-20 09:59:59	just before the time
2026-04-23 10:00:00	three days later
2026-04-26	six days later
2026-04-27 09:59:59	cornercase inside!
2026-04-18
EOF

    run -1 datediff --file - -lt 1w <<'EOF'
2026-04-20 09:59:59	just before the time
2026-04-23 10:00:00	three days later
2026-04-26	six days later
2026-04-27 10:00:00	cornercase outside!
2026-04-18
EOF
}

@test "compare timeslot of passed date and dates and addenda from file only succeeds when all comparisons succeed" {
    run -0 datediff --file - --within hour '2026-04-20 10:00:00' <<'EOF'
2026-04-20 10:00:00	the time is now

2026-04-20 10:10:10	10 later
	spaced out
2026-04-20 10:59:59	just shy of the next hour
EOF

    run -1 datediff --file - --within hour '2026-04-20 10:00:00' <<'EOF'
2026-04-20 10:00:00	the time is now

2026-04-20 10:10:10	10 later
	spaced out
2026-04-20 09:59:59	just before the time
EOF

    run -0 datediff --file - --within year '2026-04-20 10:00:00' <<'EOF'
2026-01-01	new year
2026-04-20 10:00:00	the time is now
2026-10-10 10:00:00	all tens
EOF

    run -1 datediff --file - --within year '2026-04-20 10:00:00' <<'EOF'
2026-01-01	new year
2025-12-31	last year's new year's eve
2026-04-20 10:00:00	the time is now
EOF
}
