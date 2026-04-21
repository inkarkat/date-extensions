#!/usr/bin/env bats

load fixture

@test "passed seconds diff" {
    typeset -A data=(
	[0]='0 seconds'
	[1]='1 second'
	[2]='2 seconds'
	[60]='60 seconds = 1 minute'
	[3600]='3600 seconds = 60 minutes = 1 hour'
	[50340]='839 minutes = 14 hours = 0.6 days = 0.1 weeks'
	[-36000]='-600 minutes = -10 hours = -0.4 days'
	[-3600]='-3600 seconds = -60 minutes = -1 hour'
	[-86400]='-1440 minutes = -24 hours = -1 day = -0.1 weeks'
	[86400]='1440 minutes = 24 hours = 1 day = 0.1 weeks'
	[50400]='840 minutes = 14 hours = 0.6 days = 0.1 weeks'
	[95580]='1593 minutes = 26.5 hours = 1.1 days = 0.1 weeks'
    )

    for seconds in "${!data[@]}"
    do
	run -0 datediff --seconds "$seconds"
	assert_output "${data["$seconds"]}" || fail "$seconds"
    done
}

@test "passed days diff" {
    typeset -A data=(
	[11]='1.6 weeks = 0.4 months'
	[22]='3.1 weeks = 0.7 months'
	[42]='6 weeks = 1.4 months = 0.1 years'
	[103]='14.7 weeks = 3.4 months = 0.3 years'
	[256]='36.6 weeks = 8.5 months = 0.7 years'
	[-18081]='-2583 weeks = -602.7 months = -49.5 years = -2 generations'
    )

    for days in "${!data[@]}"
    do
	run -0 datediff --days "$days"
	assert_output "${data["$days"]}" || fail "$days"
    done
}
